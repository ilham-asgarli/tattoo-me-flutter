part of 'purchase_bloc.dart';

class PurchaseState {
  List<String> notFoundIds;
  List<ProductDetails> products;
  List<PurchaseDetails> purchases;
  bool isAvailable;
  bool purchasePending;
  bool loading;
  String? queryProductError;

  PurchaseState({
    this.notFoundIds = const [],
    this.products = const [],
    this.purchases = const [],
    this.isAvailable = false,
    this.purchasePending = false,
    this.loading = true,
    this.queryProductError,
  });

  PurchaseState copyWith({
    List<String>? notFoundIds,
    List<ProductDetails>? products,
    List<PurchaseDetails>? purchases,
    List<String>? consumables,
    bool? isAvailable,
    bool? purchasePending,
    bool? loading,
    String? queryProductError,
  }) {
    return PurchaseState(
      notFoundIds: notFoundIds ?? this.notFoundIds,
      products: products ?? this.products,
      purchases: purchases ?? this.purchases,
      isAvailable: isAvailable ?? this.isAvailable,
      purchasePending: purchasePending ?? this.purchasePending,
      loading: loading ?? this.loading,
      queryProductError: queryProductError ?? this.queryProductError,
    );
  }
}
