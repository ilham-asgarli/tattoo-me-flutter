import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            deliverProduct(purchaseDetails);

            if (purchaseDetails.status == PurchaseStatus.purchased) {
              await writeSubscriptionToServer(purchaseDetails);
              restorePurchases();
            } else {
              // restored
              loadSubscriptionBalance(purchaseDetails);
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

  void loadSubscriptionBalance(PurchaseDetails purchaseDetails) async {
    Map map =
        json.decode(purchaseDetails.verificationData.localVerificationData);
    await subscriptionsRepository.loadSubscriptionByToken(
        SubscriptionModel(purchaseToken: map["purchaseToken"]));
  }

  Future<void> writeSubscriptionToServer(
      PurchaseDetails purchaseDetails) async {
    if (PurchaseConstants.subscriptions.keys
        .contains(purchaseDetails.productID)) {
      Map map =
          json.decode(purchaseDetails.verificationData.localVerificationData);

      await subscriptionsRepository.createSubscription(
        SubscriptionModel(
          userId: context.read<SignBloc>().state.userModel.id,
          orderId: map["orderId"],
          productId: map["productId"],
          source: purchaseDetails.verificationData.source,
          purchaseToken: map["purchaseToken"],
          purchaseTime:
              DateTime.fromMillisecondsSinceEpoch(map["purchaseTime"]),
        ),
      );
    }
  }

  void showPendingUI() {
    emit(state.copyWith(purchasePending: true));
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    if (PurchaseConstants.inAppProducts.keys
        .contains(purchaseDetails.productID)) {
      authRepository.updateBalance(
        UserModel(id: context.read<SignBloc>().state.userModel.id),
        PurchaseConstants.inAppProducts[purchaseDetails.productID] ?? 0,
      );

      emit(state.copyWith(
        purchasePending: false,
      ));
    } else {
      if (purchaseDetails.status == PurchaseStatus.restored) {
        List<PurchaseDetails> purchases = state.purchases.toList();
        purchases.add(purchaseDetails);
        emit(state.copyWith(
          purchasePending: false,
          purchases: purchases,
        ));
      }
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
    return false;
  }
}
