part of 'subscription_cubit.dart';

class SubscriptionState {
  List<PastPurchaseModel?> activeSubscriptions;

  SubscriptionState({
    this.activeSubscriptions = const [],
  });

  SubscriptionState copyWith({
    List<PastPurchaseModel?>? activeSubscriptions,
  }) {
    return SubscriptionState(
      activeSubscriptions: activeSubscriptions ?? this.activeSubscriptions,
    );
  }
}
