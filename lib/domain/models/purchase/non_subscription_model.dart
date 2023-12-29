import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/logic/helpers/json/timestamp_serializer.dart';

part 'non_subscription_model.freezed.dart';
part 'non_subscription_model.g.dart';

// dart run build_runner build --delete-conflicting-outputs

@Freezed()
abstract class NonSubscriptionModel with _$NonSubscriptionModel {
  @JsonSerializable(
    explicitToJson: true,
    includeIfNull: false,
  )
  @TimestampSerializer()
  const factory NonSubscriptionModel({
    String? orderId,
    String? productId,
    String? userId,
    String? type,
    String? status,
    String? iapSource,
    DateTime? purchaseDate,
    DateTime? expiryDate,
  }) = _NonSubscriptionModel;

  factory NonSubscriptionModel.fromJson(Map<String, Object?> json) =>
      _$NonSubscriptionModelFromJson(json);
}
