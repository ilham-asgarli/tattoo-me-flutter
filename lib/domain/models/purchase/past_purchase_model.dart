import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/logic/helpers/json/timestamp_serializer.dart';

part 'past_purchase_model.freezed.dart';
part 'past_purchase_model.g.dart';

// dart run build_runner build --delete-conflicting-outputs

@Freezed()
abstract class PastPurchaseModel with _$PastPurchaseModel {
  @JsonSerializable(
    explicitToJson: true,
    includeIfNull: false,
  )
  @TimestampSerializer()
  const factory PastPurchaseModel({
    required String orderId,
    required String productId,
    required String userId,
    required String type,
    required String status,
    required String iapSource,
    required DateTime purchaseDate,
    DateTime? expiryDate,
  }) = _PastPurchaseModel;

  factory PastPurchaseModel.fromJson(Map<String, Object?> json) =>
      _$PastPurchaseModelFromJson(json);
}
