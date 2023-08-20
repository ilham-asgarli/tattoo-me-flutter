import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../domain/models/subscriptions/subscription_model.dart';
import '../../../../utils/logic/constants/enums/purchase_enums.dart';
import '../../../../utils/logic/helpers/purchase/purchase_helper.dart';
import '../../../models/auth/backend_user_model.dart';
import '../../../models/subscriptions/backend_subscriptions_model.dart';
import '../interfaces/backend_subscription_interface.dart';

class BackendSubscription extends BackendSubscriptionInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference users = FirebaseFirestore.instance.collection("users");
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
      return BaseError(message: e.toString());
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
      return BaseError(message: e.toString());
    }
  }

  @override
  Future<BaseResponse<SubscriptionModel>> loadSubscriptionByToken(
      SubscriptionModel subscriptionModel) async {
    try {
      QuerySnapshot querySnapshot = await subscriptions
          .where("purchaseToken", isEqualTo: subscriptionModel.purchaseToken)
          .get();
      if (querySnapshot.size == 1) {
        QueryDocumentSnapshot documentReference = querySnapshot.docs[0];
        Map<String, dynamic>? subscriptionData =
            documentReference.data() as Map<String, dynamic>?;

        if (subscriptionData != null) {
          subscriptionModel = BackendSubscriptionModel()
              .to(model: BackendSubscriptionModel().fromJson(subscriptionData));
          subscriptionModel.id = documentReference.id;

          int factor = 0;

          if (subscriptionModel.lastLoadTime == null) {
            factor = 1;
          } else {
            factor = subscriptionModel.lastLoadTime!
                    .difference(subscriptionModel.createdDate!)
                    .inDays ~/
                30;
          }

          int? value = PurchaseHelper.instance.getCreditsForId(
              Purchase.subscription, subscriptionModel.productId ?? "");
          ;

          if (value != null && factor > 0) {
            await firestore.runTransaction((transaction) async {
              transaction.update(
                users.doc(subscriptionModel.userId),
                BackendUserModel(balance: FieldValue.increment(value * factor))
                    .toJson(),
              );

              transaction.update(
                subscriptions.doc(subscriptionModel.id),
                BackendSubscriptionModel(
                  lastLoadTime: FieldValue.serverTimestamp(),
                ).toJson(),
              );
            }, maxAttempts: 1).catchError((e) {
              throw e.toString();
            });

            return BaseSuccess<SubscriptionModel>(data: subscriptionModel);
          }
        }
      }

      return BaseError();
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }
}
