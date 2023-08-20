import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/constants/enums/http_request_enum.dart';
import '../../../../core/network/core/core_http.dart';
import '../../../../domain/models/in_app_purchase/in_app_purchase_apple.dart';
import '../../constants/enums/purchase_enums.dart';
import '../../extensions/purchase_extensions.dart';
import '../../state/cubit/purchase/purchase_cubit.dart';

class PurchaseHelper {
  static const PurchaseHelper instance = PurchaseHelper._internal();

  const PurchaseHelper._internal();

  bool containsElementWithId(Purchase purchase, String targetId) {
    for (var enumValue in purchase.values) {
      var id = enumValue is InAppProducts
          ? enumValue.id
          : enumValue is Subscriptions
              ? enumValue.id
              : null;
      if (id == targetId) {
        return true;
      }
    }
    return false;
  }

  int? getCreditsForId(Purchase purchase, String targetId) {
    for (var enumValue in purchase.values) {
      var id = enumValue is InAppProducts
          ? enumValue.id
          : enumValue is Subscriptions
              ? enumValue.id
              : null;
      if (id == targetId) {
        var credit = enumValue is InAppProducts
            ? enumValue.credit
            : enumValue is Subscriptions
                ? enumValue.credit
                : null;
        return credit;
      }
    }

    return null;
  }

  int? getExtraForId(Purchase purchase, String targetId) {
    for (var enumValue in purchase.values) {
      var id = enumValue is InAppProducts
          ? enumValue.id
          : enumValue is Subscriptions
              ? enumValue.id
              : null;
      if (id == targetId) {
        var extra = enumValue is InAppProducts
            ? enumValue.extra
            : enumValue is Subscriptions
                ? enumValue.extra
                : null;
        return extra;
      }
    }

    return null;
  }

  List<String> getAllIds(Purchase purchase) {
    final idList = <String>[];

    for (var enumValue in purchase.values) {
      var id = enumValue is InAppProducts
          ? enumValue.id
          : enumValue is Subscriptions
              ? enumValue.id
              : null;
      idList.add(id!);
    }

    return idList;
  }

  void onTap(BuildContext context, ProductDetails productDetails) {
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
      context.read<PurchaseCubit>().state.purchases.map(
        (PurchaseDetails purchase) {
          if (purchase.pendingCompletePurchase) {
            context
                .read<PurchaseCubit>()
                .inAppPurchase
                .completePurchase(purchase);
          }
          return MapEntry<String, PurchaseDetails>(
              purchase.productID, purchase);
        },
      ),
    );
    final PurchaseDetails? previousPurchase = purchases[productDetails.id];

    if (previousPurchase != null) {
      confirmPriceChange(context, previousPurchase);
    } else {
      PurchaseParam purchaseParam;

      if (Platform.isAndroid) {
        final GooglePlayPurchaseDetails? oldSubscription =
            _getOldSubscription(productDetails, purchases);

        purchaseParam = GooglePlayPurchaseParam(
            productDetails: productDetails,
            changeSubscriptionParam: (oldSubscription != null)
                ? ChangeSubscriptionParam(
                    oldPurchaseDetails: oldSubscription,
                    prorationMode: ProrationMode.immediateWithTimeProration,
                  )
                : null);
      } else {
        purchaseParam = PurchaseParam(
          productDetails: productDetails,
        );
      }

      if (containsElementWithId(Purchase.inAppProduct, productDetails.id)) {
        context.read<PurchaseCubit>().inAppPurchase.buyConsumable(
              purchaseParam: purchaseParam,
              autoConsume: context.read<PurchaseCubit>().kAutoConsume,
            );
      } else {
        context.read<PurchaseCubit>().inAppPurchase.buyNonConsumable(
              purchaseParam: purchaseParam,
            );
      }
    }
  }

  Future<void> confirmPriceChange(
    BuildContext context,
    PurchaseDetails purchaseDetails,
  ) async {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          context
              .read<PurchaseCubit>()
              .inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
    ProductDetails productDetails,
    Map<String, PurchaseDetails> purchases,
  ) {
    GooglePlayPurchaseDetails? oldSubscription;
    if (containsElementWithId(Purchase.subscription, productDetails.id)) {
      for (String subscription in getAllIds(Purchase.subscription)) {
        if (purchases[subscription] != null) {
          oldSubscription =
              purchases[subscription]! as GooglePlayPurchaseDetails;
          break;
        }
      }
    }

    return oldSubscription;
  }

  Future<void> verifyReceiptIos(String receiptData) async {
    const String url = kDebugMode
        ? 'https://sandbox.itunes.apple.com/verifyReceipt'
        : 'https://buy.itunes.apple.com/verifyReceipt';

    BaseResponse<InAppPurchaseApple> baseResponse =
        await CoreHttp.instance.send<InAppPurchaseApple, InAppPurchaseApple>(
      url,
      type: HttpTypes.post,
      parseModel: InAppPurchaseApple(),
      body: {
        'receipt-data': receiptData,
        'exclude-old-transactions': true,
        'password': dotenv.env["appleAppSpecificSharedSecret"],
      },
    );
  }
}
