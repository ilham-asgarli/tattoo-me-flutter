import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../../../constants/enums/purchase_enums.dart';
import '../../../constants/purchase/purchase_constants.dart';
import '../../../helpers/purchase/purchase_helper.dart';
import '../../bloc/sign/sign_bloc.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final BuildContext context;
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  final bool kAutoConsume = Platform.isIOS || true;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  PurchaseCubit(this.context) : super(PurchaseState()) {
    init();
  }

  void init() async {
    _subscription = inAppPurchase.purchaseStream.listen(
      _listenToPurchaseUpdated,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (Object error) {
        // handle error here.
        print(error);
      },
    );
    await initStoreInfo();
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      handlePurchase(purchaseDetails);
    }
  }

  void handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      showPendingUI();
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        handleError(purchaseDetails.error!);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        verifyAndDeliverProduct(purchaseDetails);
      }

      if (Platform.isAndroid) {
        if (!kAutoConsume &&
            PurchaseHelper.instance.containsElementWithId(
              Purchase.inAppProduct,
              purchaseDetails.productID,
            )) {
          final InAppPurchaseAndroidPlatformAddition androidAddition =
              inAppPurchase
                  .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchaseDetails);
        }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void showPendingUI() {
    emit(state.copyWith(
      purchasePending: true,
    ));
  }

  Future<void> verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    print('source : ${purchaseDetails.verificationData.source}');
    print('productId : ${purchaseDetails.productID}');
    print('uid : ${context.read<SignBloc>().state.userModel.id}');
    print(
        'verificationData : ${purchaseDetails.verificationData.serverVerificationData}');

    print("purchases-1: ${state.purchases}");
    print("PurchaseStatus-1: ${purchaseDetails.status}");

    if (purchaseDetails.status == PurchaseStatus.restored) {
      List<PurchaseDetails> purchases = state.purchases.toList();
      purchases.add(purchaseDetails);

      emit(state.copyWith(
        purchasePending: false,
        purchases: purchases,
      ));
    } else {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('verifyPurchase');
      final res = await callable.call<bool>({
        'source': purchaseDetails.verificationData.source,
        'productId': purchaseDetails.productID,
        'uid': context.read<SignBloc>().state.userModel.id,
        'verificationData':
            purchaseDetails.verificationData.serverVerificationData
      });

      print('Purchase verified : ${res.data}');
      List<PurchaseDetails>? p;

      if (res.data) {
        // payment succeed
        List<PurchaseDetails> purchases = state.purchases.toList();
        purchases.add(purchaseDetails);

        p = purchases;
      } else {
        // payment failed
        _handleInvalidPurchase(purchaseDetails);
      }

      emit(state.copyWith(
        purchasePending: false,
        purchases: p,
      ));
    }

    print("purchases-2: ${state.purchases}");
    print("PurchaseStatus-2: ${purchaseDetails.status}");
  }

  void handleError(IAPError error) {
    emit(state.copyWith(
      purchasePending: false,
    ));
  }

  // failed to verify purchase
  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {}

  Future<void> initStoreInfo() async {
    final bool isAvailable = await inAppPurchase.isAvailable();
    if (!isAvailable) {
      emit(state.copyWith(
        isAvailable: isAvailable,
        products: [],
        purchases: [],
        notFoundIds: [],
        purchasePending: false,
        loading: false,
      ));
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
      emit(state.copyWith(
        queryProductError: productDetailResponse.error!.message,
        isAvailable: isAvailable,
        products: productDetailResponse.productDetails,
        purchases: [],
        notFoundIds: productDetailResponse.notFoundIDs,
        purchasePending: false,
        loading: false,
      ));
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      emit(state.copyWith(
        queryProductError: "",
        isAvailable: isAvailable,
        products: productDetailResponse.productDetails,
        purchases: [],
        notFoundIds: productDetailResponse.notFoundIDs,
        purchasePending: false,
        loading: false,
      ));
      return;
    }

    emit(state.copyWith(
      isAvailable: isAvailable,
      products: productDetailResponse.productDetails,
      notFoundIds: productDetailResponse.notFoundIDs,
      purchasePending: false,
      loading: false,
    ));
  }

  void resetPurchases() {
    emit(state.copyWith(
      purchases: [],
    ));
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
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return true;
  }
}
