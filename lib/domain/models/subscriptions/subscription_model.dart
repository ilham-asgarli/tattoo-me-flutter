import '../../../core/base/models/base_model.dart';

class SubscriptionModel extends BaseModel<SubscriptionModel> {
  String? id;
  String? userId;
  String? orderId;
  String? productId;
  String? source;
  String? purchaseToken;
  DateTime? purchaseTime;
  DateTime? createdDate;

  SubscriptionModel({
    this.id,
    this.userId,
    this.orderId,
    this.productId,
    this.source,
    this.purchaseToken,
    this.purchaseTime,
    this.createdDate,
  });

  @override
  SubscriptionModel fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
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
    return {
      "id": id,
      "userId": userId,
      "orderId": orderId,
      "productId": productId,
      "source": source,
      "purchaseToken": purchaseToken,
      "purchaseTime": purchaseTime,
      "createdDate": createdDate,
    };
  }
}
