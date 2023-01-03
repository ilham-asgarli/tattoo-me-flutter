import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/core/base/models/base_model.dart';
import 'package:tattoo/core/extensions/map_extension.dart';

import '../../../domain/models/subscriptions/subscription_model.dart';

class BackendSubscriptionModel extends BaseModel<BackendSubscriptionModel> {
  String? id;
  String? userId;
  String? orderId;
  String? productId;
  String? source;
  String? purchaseToken;
  Timestamp? purchaseTime;
  dynamic createdDate;

  BackendSubscriptionModel({
    this.id,
    this.userId,
    this.orderId,
    this.productId,
    this.source,
    this.purchaseToken,
    this.purchaseTime,
    this.createdDate,
  });

  BackendSubscriptionModel.from({required SubscriptionModel model}) {
    id = model.id;
    userId = model.userId;
    orderId = model.orderId;
    productId = model.productId;
    source = model.source;
    purchaseToken = model.purchaseToken;
    purchaseTime = model.purchaseTime != null
        ? Timestamp.fromDate(model.purchaseTime!)
        : null;
    createdDate = model.createdDate != null
        ? Timestamp.fromDate(model.createdDate!)
        : null;
  }

  SubscriptionModel to({required BackendSubscriptionModel model}) {
    return SubscriptionModel(
      id: model.id,
      userId: model.userId,
      orderId: model.orderId,
      productId: model.productId,
      source: model.source,
      purchaseToken: model.purchaseToken,
      purchaseTime:
          model.createdDate is Timestamp ? model.purchaseTime?.toDate() : null,
      createdDate:
          model.createdDate is Timestamp ? model.createdDate?.toDate() : null,
    );
  }

  @override
  BackendSubscriptionModel fromJson(Map<String, dynamic> json) {
    return BackendSubscriptionModel(
      id: json["id"],
      userId: json["userId"],
      orderId: json["orderId"],
      productId: json["productId"],
      source: json["source"],
      purchaseToken: json["purchaseToken"],
      purchaseTime: json["purchaseTime"],
      createdDate: json["createdDate"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("userId", userId);
    map.putIfNotNull("orderId", orderId);
    map.putIfNotNull("productId", productId);
    map.putIfNotNull("source", source);
    map.putIfNotNull("purchaseToken", purchaseToken);
    map.putIfNotNull("purchaseTime", purchaseTime);
    map.putIfNotNull("createdDate", createdDate);

    return map;
  }
}
