import 'package:tattoo/backend/features/subscriptions/implementations/backend_subscription.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/models/subscriptions/subscription_model.dart';

import '../interfaces/subscriptions_interface.dart';

class SubscriptionsRepository extends SubscriptionInterface {
  final BackendSubscription backendSubscription = BackendSubscription();

  @override
  Future<BaseResponse<SubscriptionModel>> createSubscription(
      SubscriptionModel subscriptionModel) async {
    BaseResponse<SubscriptionModel> baseResponse =
        await backendSubscription.createSubscription(subscriptionModel);
    return baseResponse;
  }

  @override
  Future<BaseResponse> updateSubscription(
      SubscriptionModel subscriptionModel) async {
    BaseResponse baseResponse =
        await backendSubscription.updateSubscription(subscriptionModel);
    return baseResponse;
  }
}
