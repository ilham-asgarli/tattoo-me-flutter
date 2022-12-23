part of 'purchase_bloc.dart';

abstract class PurchaseEvent extends Equatable {
  const PurchaseEvent();
}

class PurchaseNotAvailableEvent extends PurchaseEvent {
  final bool isAvailable;
  final List<ProductDetails> products;
  final List<PurchaseDetails> purchases;
  final List<String> notFoundIds;
  final bool purchasePending;
  final bool loading;

  const PurchaseNotAvailableEvent({
    required this.isAvailable,
    required this.products,
    required this.purchases,
    required this.notFoundIds,
    required this.purchasePending,
    required this.loading,
  });

  @override
  List<Object?> get props =>
      [isAvailable, products, purchases, notFoundIds, purchasePending, loading];
}
