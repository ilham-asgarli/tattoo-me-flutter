import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/models/subscriptions/subscription_model.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../models/subscriptions/backend_subscriptions_model.dart';
import '../interfaces/backend_subscription_interface.dart';

class BackendSubscription extends BackendSubscriptionInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference subscriptions =
      FirebaseFirestore.instance.collection("subscriptions");

  @override
  Future<BaseResponse<SubscriptionModel>> createSubscription(
      SubscriptionModel subscriptionModel) async {
    try {
      BackendSubscriptionModel backendSubscriptionModel =
          BackendSubscriptionModel.from(
        model: subscriptionModel,
      );
      backendSubscriptionModel.createdDate = FieldValue.serverTimestamp();

      DocumentReference documentReference = await subscriptions.add(
        backendSubscriptionModel.toJson(),
      );

      subscriptionModel.id = documentReference.id;

      return BaseSuccess<SubscriptionModel>(data: subscriptionModel);
    } catch (e) {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse> updateSubscription(
      SubscriptionModel subscriptionModel) async {
    try {
      await subscriptions.doc(subscriptionModel.id ?? "").update(
            BackendSubscriptionModel.from(model: subscriptionModel).toJson(),
          );

      return BaseSuccess();
    } catch (e) {
      return BaseError();
    }
  }
}
