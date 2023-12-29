// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'non_subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NonSubscriptionModelImpl _$$NonSubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NonSubscriptionModelImpl(
      orderId: json['orderId'] as String?,
      productId: json['productId'] as String?,
      userId: json['userId'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      iapSource: json['iapSource'] as String?,
      purchaseDate: const TimestampSerializer().fromJson(json['purchaseDate']),
      expiryDate: const TimestampSerializer().fromJson(json['expiryDate']),
    );

Map<String, dynamic> _$$NonSubscriptionModelImplToJson(
    _$NonSubscriptionModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('orderId', instance.orderId);
  writeNotNull('productId', instance.productId);
  writeNotNull('userId', instance.userId);
  writeNotNull('type', instance.type);
  writeNotNull('status', instance.status);
  writeNotNull('iapSource', instance.iapSource);
  writeNotNull(
      'purchaseDate',
      _$JsonConverterToJson<dynamic, DateTime>(
          instance.purchaseDate, const TimestampSerializer().toJson));
  writeNotNull(
      'expiryDate',
      _$JsonConverterToJson<dynamic, DateTime>(
          instance.expiryDate, const TimestampSerializer().toJson));
  return val;
}

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
