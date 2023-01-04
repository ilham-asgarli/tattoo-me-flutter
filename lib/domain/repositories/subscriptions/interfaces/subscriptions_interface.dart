import 'package:tattoo/domain/models/subscriptions/subscription_model.dart';

import '../../../../core/base/models/base_response.dart';

abstract class SubscriptionInterface {
  Future<BaseResponse<SubscriptionModel>> loadSubscriptionByToken(
      SubscriptionModel subscriptionModel);

  Future<BaseResponse<SubscriptionModel>> createSubscription(
      SubscriptionModel subscriptionModel);

  Future<BaseResponse> updateSubscription(SubscriptionModel subscriptionModel);
}
