// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'past_purchase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PastPurchaseModelImpl _$$PastPurchaseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PastPurchaseModelImpl(
      orderId: json['orderId'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      iapSource: json['iapSource'] as String,
      purchaseDate: const TimestampSerializer().fromJson(json['purchaseDate']),
      expiryDate: const TimestampSerializer().fromJson(json['expiryDate']),
    );

Map<String, dynamic> _$$PastPurchaseModelImplToJson(
    _$PastPurchaseModelImpl instance) {
  final val = <String, dynamic>{
    'orderId': instance.orderId,
    'productId': instance.productId,
    'userId': instance.userId,
    'type': instance.type,
    'status': instance.status,
    'iapSource': instance.iapSource,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('purchaseDate',
      const TimestampSerializer().toJson(instance.purchaseDate));
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
