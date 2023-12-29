part of 'subscription_cubit.dart';

class SubscriptionState {
  List<SubscriptionModel?> activeSubscriptions;

  SubscriptionState({
    this.activeSubscriptions = const [],
  });

  SubscriptionState copyWith({
    List<SubscriptionModel?>? activeSubscriptions,
  }) {
    return SubscriptionState(
      activeSubscriptions: activeSubscriptions ?? this.activeSubscriptions,
    );
  }
}
