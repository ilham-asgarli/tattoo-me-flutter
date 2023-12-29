import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/logic/helpers/json/timestamp_serializer.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

// dart run build_runner build --delete-conflicting-outputs

@Freezed()
abstract class SubscriptionModel with _$SubscriptionModel {
  @JsonSerializable(
    explicitToJson: true,
    includeIfNull: false,
  )
  @TimestampSerializer()
  const factory SubscriptionModel({
    String? orderId,
    String? productId,
    String? userId,
    String? type,
    String? status,
    String? iapSource,
    DateTime? purchaseDate,
    DateTime? expiryDate,
  }) = _SubscriptionModel;

  factory SubscriptionModel.fromJson(Map<String, Object?> json) =>
      _$SubscriptionModelFromJson(json);
}
