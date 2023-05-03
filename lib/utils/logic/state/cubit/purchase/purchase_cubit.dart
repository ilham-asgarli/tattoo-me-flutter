import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../../../../../domain/models/auth/user_model.dart';
import '../../../../../domain/models/subscriptions/subscription_model.dart';
import '../../../../../domain/repositories/auth/implementations/auto_auth_repository.dart';
import '../../../../../domain/repositories/subscriptions/implementations/subscriptions_repository.dart';
import '../../../constants/purchase/purchase_constants.dart';
import '../../bloc/sign/sign_bloc.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final SubscriptionsRepository subscriptionsRepository =
      SubscriptionsRepository();
  final AutoAuthRepository authRepository = AutoAuthRepository();

  final BuildContext context;
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  final bool kAutoConsume = Platform.isIOS || true;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  PurchaseCubit(this.context) : super(PurchaseState()) {
    init(context);
  }

  void init(BuildContext context) async {
    //_subscription?.cancel();
    _subscription = inAppPurchase.purchaseStream.listen(
        (List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    await initStoreInfo();
    restorePurchases();
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            print(purchaseDetails.status);
            deliverProduct(purchaseDetails);

            if (purchaseDetails.status == PurchaseStatus.purchased) {
              await writeSubscriptionToServer(purchaseDetails);
              restorePurchases();
            } else {
              // restored
              await loadSubscriptionBalance(purchaseDetails);
            }
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (Platform.isAndroid) {
          if (!kAutoConsume &&
              PurchaseConstants.inAppProducts.keys
                  .contains(purchaseDetails.productID)) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> loadSubscriptionBalance(PurchaseDetails purchaseDetails) async {
    if (Platform.isAndroid) {
      Map map =
          json.decode(purchaseDetails.verificationData.localVerificationData);
      await subscriptionsRepository.loadSubscriptionByToken(
          SubscriptionModel(purchaseToken: map["purchaseToken"]));
    } else if (Platform.isIOS) {
      var receiptBody = {
        'receipt-data': purchaseDetails.verificationData.localVerificationData,
        'exclude-old-transactions': true,
        'password': dotenv.env["appleAppSpecificSharedSecret"],
      };

      //print(purchaseDetails.verificationData.localVerificationData);

      Response res = await validateReceiptIos(receiptBody);
      Map map = json.decode(res.body);
      var latestReceiptInfo = map["latest_receipt_info"];
      print(latestReceiptInfo[0]["transaction_id"]);
      await subscriptionsRepository.loadSubscriptionByToken(SubscriptionModel(
          purchaseToken: latestReceiptInfo[0]["transaction_id"]));
    }
  }

  Future<Response> validateReceiptIos(receiptBody) async {
    const String url = kDebugMode
        ? 'https://sandbox.itunes.apple.com/verifyReceipt'
        : 'https://buy.itunes.apple.com/verifyReceipt';
    return await Client().post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(receiptBody),
    );
  }

  Future<void> writeSubscriptionToServer(
      PurchaseDetails purchaseDetails) async {
    print("3");
    if (PurchaseConstants.subscriptions.keys
        .contains(purchaseDetails.productID)) {
      SubscriptionModel? subscriptionModel;

      if (Platform.isAndroid) {
        Map map =
            json.decode(purchaseDetails.verificationData.localVerificationData);

        subscriptionModel = SubscriptionModel(
          userId: context.read<SignBloc>().state.userModel.id,
          orderId: map["orderId"],
          productId: map["productId"],
          source: purchaseDetails.verificationData.source,
          purchaseToken: map["purchaseToken"],
          purchaseTime:
              DateTime.fromMillisecondsSinceEpoch(map["purchaseTime"]),
        );
      } else if (Platform.isIOS) {
        var receiptBody = {
          'receipt-data':
              purchaseDetails.verificationData.localVerificationData,
          'exclude-old-transactions': true,
          'password': dotenv.env["appleAppSpecificSharedSecret"],
        };

        Response res = await validateReceiptIos(receiptBody);

        Map map = json.decode(res.body);
        var latestReceiptInfo = map["latest_receipt_info"];
        var latestReceipt = map["latest_receipt"];

        subscriptionModel = SubscriptionModel(
          userId: context.read<SignBloc>().state.userModel.id,
          orderId: latestReceiptInfo[0]["original_transaction_id"],
          productId: latestReceiptInfo[0]["product_id"],
          source: purchaseDetails.verificationData.source,
          purchaseToken: latestReceiptInfo[0]["transaction_id"],
          purchaseTime: DateTime.fromMillisecondsSinceEpoch(
              int.parse(latestReceiptInfo[0]["purchase_date_ms"])),
        );
      }

      if (subscriptionModel != null) {
        await subscriptionsRepository.createSubscription(subscriptionModel);
      }
    }
    print("4");
  }

  void showPendingUI() {
    emit(state.copyWith(purchasePending: true));
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.restored) {
      List<PurchaseDetails> purchases = state.purchases.toList();
      purchases.add(purchaseDetails);
      emit(state.copyWith(
        purchasePending: false,
        purchases: purchases,
      ));
    } else if (PurchaseConstants.inAppProducts.keys
        .contains(purchaseDetails.productID)) {
      authRepository.updateBalance(
        UserModel(id: context.read<SignBloc>().state.userModel.id),
        PurchaseConstants.inAppProducts[purchaseDetails.productID] ?? 0,
      );

      emit(state.copyWith(
        purchasePending: false,
      ));
    }
  }

  void handleError(IAPError error) {
    emit(state.copyWith(purchasePending: false));
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await inAppPurchase.isAvailable();
    if (!isAvailable) {
      emit(
        state.copyWith(
          isAvailable: isAvailable,
          products: [],
          purchases: [],
          notFoundIds: [],
          purchasePending: false,
          loading: false,
        ),
      );
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await inAppPurchase.queryProductDetails(PurchaseConstants.all.toSet());
    if (productDetailResponse.error != null) {
      emit(
        state.copyWith(
          queryProductError: productDetailResponse.error!.message,
          isAvailable: isAvailable,
          products: productDetailResponse.productDetails,
          purchases: [],
          notFoundIds: productDetailResponse.notFoundIDs,
          purchasePending: false,
          loading: false,
        ),
      );
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      emit(
        state.copyWith(
          queryProductError: "",
          isAvailable: isAvailable,
          products: productDetailResponse.productDetails,
          purchases: [],
          notFoundIds: productDetailResponse.notFoundIDs,
          purchasePending: false,
          loading: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isAvailable: isAvailable,
        products: productDetailResponse.productDetails,
        notFoundIds: productDetailResponse.notFoundIDs,
        purchasePending: false,
        loading: false,
      ),
    );
  }

  void restorePurchases() {
    emit(state.copyWith(
      purchases: [],
    ));

    inAppPurchase.restorePurchases();
  }

  @override
  Future<void> close() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription?.cancel();
    return super.close();
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return true;
  }
}
