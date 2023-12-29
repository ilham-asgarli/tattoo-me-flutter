// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'past_purchase_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PastPurchaseModel _$PastPurchaseModelFromJson(Map<String, dynamic> json) {
  return _PastPurchaseModel.fromJson(json);
}

/// @nodoc
mixin _$PastPurchaseModel {
  String get orderId => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get iapSource => throw _privateConstructorUsedError;
  DateTime get purchaseDate => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PastPurchaseModelCopyWith<PastPurchaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PastPurchaseModelCopyWith<$Res> {
  factory $PastPurchaseModelCopyWith(
          PastPurchaseModel value, $Res Function(PastPurchaseModel) then) =
      _$PastPurchaseModelCopyWithImpl<$Res, PastPurchaseModel>;
  @useResult
  $Res call(
      {String orderId,
      String productId,
      String userId,
      String type,
      String status,
      String iapSource,
      DateTime purchaseDate,
      DateTime? expiryDate});
}

/// @nodoc
class _$PastPurchaseModelCopyWithImpl<$Res, $Val extends PastPurchaseModel>
    implements $PastPurchaseModelCopyWith<$Res> {
  _$PastPurchaseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? productId = null,
    Object? userId = null,
    Object? type = null,
    Object? status = null,
    Object? iapSource = null,
    Object? purchaseDate = null,
    Object? expiryDate = freezed,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      iapSource: null == iapSource
          ? _value.iapSource
          : iapSource // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseDate: null == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PastPurchaseModelImplCopyWith<$Res>
    implements $PastPurchaseModelCopyWith<$Res> {
  factory _$$PastPurchaseModelImplCopyWith(_$PastPurchaseModelImpl value,
          $Res Function(_$PastPurchaseModelImpl) then) =
      __$$PastPurchaseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String orderId,
      String productId,
      String userId,
      String type,
      String status,
      String iapSource,
      DateTime purchaseDate,
      DateTime? expiryDate});
}

/// @nodoc
class __$$PastPurchaseModelImplCopyWithImpl<$Res>
    extends _$PastPurchaseModelCopyWithImpl<$Res, _$PastPurchaseModelImpl>
    implements _$$PastPurchaseModelImplCopyWith<$Res> {
  __$$PastPurchaseModelImplCopyWithImpl(_$PastPurchaseModelImpl _value,
      $Res Function(_$PastPurchaseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? productId = null,
    Object? userId = null,
    Object? type = null,
    Object? status = null,
    Object? iapSource = null,
    Object? purchaseDate = null,
    Object? expiryDate = freezed,
  }) {
    return _then(_$PastPurchaseModelImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      iapSource: null == iapSource
          ? _value.iapSource
          : iapSource // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseDate: null == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
@TimestampSerializer()
class _$PastPurchaseModelImpl implements _PastPurchaseModel {
  const _$PastPurchaseModelImpl(
      {required this.orderId,
      required this.productId,
      required this.userId,
      required this.type,
      required this.status,
      required this.iapSource,
      required this.purchaseDate,
      this.expiryDate});

  factory _$PastPurchaseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PastPurchaseModelImplFromJson(json);

  @override
  final String orderId;
  @override
  final String productId;
  @override
  final String userId;
  @override
  final String type;
  @override
  final String status;
  @override
  final String iapSource;
  @override
  final DateTime purchaseDate;
  @override
  final DateTime? expiryDate;

  @override
  String toString() {
    return 'PastPurchaseModel(orderId: $orderId, productId: $productId, userId: $userId, type: $type, status: $status, iapSource: $iapSource, purchaseDate: $purchaseDate, expiryDate: $expiryDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PastPurchaseModelImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.iapSource, iapSource) ||
                other.iapSource == iapSource) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, orderId, productId, userId, type,
      status, iapSource, purchaseDate, expiryDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PastPurchaseModelImplCopyWith<_$PastPurchaseModelImpl> get copyWith =>
      __$$PastPurchaseModelImplCopyWithImpl<_$PastPurchaseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PastPurchaseModelImplToJson(
      this,
    );
  }
}

abstract class _PastPurchaseModel implements PastPurchaseModel {
  const factory _PastPurchaseModel(
      {required final String orderId,
      required final String productId,
      required final String userId,
      required final String type,
      required final String status,
      required final String iapSource,
      required final DateTime purchaseDate,
      final DateTime? expiryDate}) = _$PastPurchaseModelImpl;

  factory _PastPurchaseModel.fromJson(Map<String, dynamic> json) =
      _$PastPurchaseModelImpl.fromJson;

  @override
  String get orderId;
  @override
  String get productId;
  @override
  String get userId;
  @override
  String get type;
  @override
  String get status;
  @override
  String get iapSource;
  @override
  DateTime get purchaseDate;
  @override
  DateTime? get expiryDate;
  @override
  @JsonKey(ignore: true)
  _$$PastPurchaseModelImplCopyWith<_$PastPurchaseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
