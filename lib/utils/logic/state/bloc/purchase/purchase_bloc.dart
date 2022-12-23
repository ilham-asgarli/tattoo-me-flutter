import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';
import 'package:tattoo/domain/repositories/auth/implementations/auto_auth_repository.dart';
import 'package:tattoo/utils/logic/state/bloc/sign/sign_bloc.dart';

import '../../../constants/purchase/purchase_constants.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  BuildContext context;
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final bool kAutoConsume = Platform.isIOS || true;

  PurchaseBloc(this.context) : super(PurchaseState()) {
    on<PurchaseNotAvailableEvent>(_onNotAvailableEvent);

    init();
  }

  _onNotAvailableEvent(
    PurchaseNotAvailableEvent event,
    Emitter<PurchaseState> emit,
  ) {
    emit(state.copyWith(
      isAvailable: event.isAvailable,
      loading: event.loading,
      purchasePending: event.purchasePending,
      notFoundIds: event.notFoundIds,
      purchases: event.purchases,
      products: event.products,
      consumables: event.consumables,
    ));
  }

  void init() {
    _subscription = inAppPurchase.purchaseStream.listen(
        (List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
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

  void showPendingUI() {
    emit(state.copyWith(purchasePending: true));
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    if (PurchaseConstants.inAppProducts.keys
        .contains(purchaseDetails.productID)) {
      AutoAuthRepository authRepository = AutoAuthRepository();
      authRepository.updateBalance(
        UserModel(id: context.read<SignBloc>().state.userModel.id),
        PurchaseConstants.inAppProducts[purchaseDetails.productID] ?? 0,
      );

      emit(state.copyWith(
        purchasePending: false,
      ));
    } else {
      List<PurchaseDetails> purchases = state.purchases;
      purchases.add(purchaseDetails);
      emit(state.copyWith(
        purchasePending: false,
        purchases: purchases,
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
          consumables: [],
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
          consumables: [],
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
          consumables: [],
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
        consumables: [],
        purchasePending: false,
        loading: false,
      ),
    );
  }

  @override
  Future<void> close() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
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
