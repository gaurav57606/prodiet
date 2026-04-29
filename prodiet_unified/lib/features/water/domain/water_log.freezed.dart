// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WaterLog _$WaterLogFromJson(Map<String, dynamic> json) {
  return _WaterLog.fromJson(json);
}

/// @nodoc
mixin _$WaterLog {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get amountMl => throw _privateConstructorUsedError;
  DateTime get loggedAt => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  /// Serializes this WaterLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WaterLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaterLogCopyWith<WaterLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaterLogCopyWith<$Res> {
  factory $WaterLogCopyWith(WaterLog value, $Res Function(WaterLog) then) =
      _$WaterLogCopyWithImpl<$Res, WaterLog>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int amountMl,
      DateTime loggedAt,
      DateTime date});
}

/// @nodoc
class _$WaterLogCopyWithImpl<$Res, $Val extends WaterLog>
    implements $WaterLogCopyWith<$Res> {
  _$WaterLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaterLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amountMl = null,
    Object? loggedAt = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMl: null == amountMl
          ? _value.amountMl
          : amountMl // ignore: cast_nullable_to_non_nullable
              as int,
      loggedAt: null == loggedAt
          ? _value.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WaterLogImplCopyWith<$Res>
    implements $WaterLogCopyWith<$Res> {
  factory _$$WaterLogImplCopyWith(
          _$WaterLogImpl value, $Res Function(_$WaterLogImpl) then) =
      __$$WaterLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int amountMl,
      DateTime loggedAt,
      DateTime date});
}

/// @nodoc
class __$$WaterLogImplCopyWithImpl<$Res>
    extends _$WaterLogCopyWithImpl<$Res, _$WaterLogImpl>
    implements _$$WaterLogImplCopyWith<$Res> {
  __$$WaterLogImplCopyWithImpl(
      _$WaterLogImpl _value, $Res Function(_$WaterLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of WaterLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amountMl = null,
    Object? loggedAt = null,
    Object? date = null,
  }) {
    return _then(_$WaterLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMl: null == amountMl
          ? _value.amountMl
          : amountMl // ignore: cast_nullable_to_non_nullable
              as int,
      loggedAt: null == loggedAt
          ? _value.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WaterLogImpl implements _WaterLog {
  const _$WaterLogImpl(
      {required this.id,
      required this.userId,
      required this.amountMl,
      required this.loggedAt,
      required this.date});

  factory _$WaterLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$WaterLogImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final int amountMl;
  @override
  final DateTime loggedAt;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'WaterLog(id: $id, userId: $userId, amountMl: $amountMl, loggedAt: $loggedAt, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaterLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amountMl, amountMl) ||
                other.amountMl == amountMl) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, amountMl, loggedAt, date);

  /// Create a copy of WaterLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaterLogImplCopyWith<_$WaterLogImpl> get copyWith =>
      __$$WaterLogImplCopyWithImpl<_$WaterLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WaterLogImplToJson(
      this,
    );
  }
}

abstract class _WaterLog implements WaterLog {
  const factory _WaterLog(
      {required final String id,
      required final String userId,
      required final int amountMl,
      required final DateTime loggedAt,
      required final DateTime date}) = _$WaterLogImpl;

  factory _WaterLog.fromJson(Map<String, dynamic> json) =
      _$WaterLogImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get amountMl;
  @override
  DateTime get loggedAt;
  @override
  DateTime get date;

  /// Create a copy of WaterLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaterLogImplCopyWith<_$WaterLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
