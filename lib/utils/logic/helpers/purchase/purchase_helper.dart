import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import '../../constants/purchase/purchase_constants.dart';
import '../../state/bloc/purchase/purchase_bloc.dart';

class PurchaseHelper {
  static const PurchaseHelper instance = PurchaseHelper._internal();

  const PurchaseHelper._internal();

  void onTap(BuildContext context, ProductDetails productDetails) {
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
      context.read<PurchaseBloc>().state.purchases.map(
        (PurchaseDetails purchase) {
          if (purchase.pendingCompletePurchase) {
            context
                .read<PurchaseBloc>()
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
      confirmPriceChange(context);
    } else {
      late PurchaseParam purchaseParam;

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

      if (PurchaseConstants.inAppProducts.keys.contains(productDetails.id)) {
        context.read<PurchaseBloc>().inAppPurchase.buyConsumable(
              purchaseParam: purchaseParam,
              autoConsume: context.read<PurchaseBloc>().kAutoConsume,
            );
      } else {
        context.read<PurchaseBloc>().inAppPurchase.buyNonConsumable(
              purchaseParam: purchaseParam,
            );
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition = context
          .read<PurchaseBloc>()
          .inAppPurchase
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final BillingResultWrapper priceChangeConfirmationResult =
          await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
          ),
        ));
      }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          context
              .read<PurchaseBloc>()
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
    if (PurchaseConstants.subscriptions.keys.contains(productDetails.id)) {
      for (String subscription in PurchaseConstants.subscriptions.keys) {
        if (purchases[subscription] != null) {
          oldSubscription =
              purchases[subscription]! as GooglePlayPurchaseDetails;
          break;
        }
      }
    }

    return oldSubscription;
  }
}
