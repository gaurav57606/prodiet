// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DietDay _$DietDayFromJson(Map<String, dynamic> json) {
  return _DietDay.fromJson(json);
}

/// @nodoc
mixin _$DietDay {
  int get dayNumber => throw _privateConstructorUsedError;
  String get breakfast => throw _privateConstructorUsedError;
  String get lunch => throw _privateConstructorUsedError;
  String get dinner => throw _privateConstructorUsedError;
  String get snacks => throw _privateConstructorUsedError;

  /// Serializes this DietDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DietDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DietDayCopyWith<DietDay> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DietDayCopyWith<$Res> {
  factory $DietDayCopyWith(DietDay value, $Res Function(DietDay) then) =
      _$DietDayCopyWithImpl<$Res, DietDay>;
  @useResult
  $Res call(
      {int dayNumber,
      String breakfast,
      String lunch,
      String dinner,
      String snacks});
}

/// @nodoc
class _$DietDayCopyWithImpl<$Res, $Val extends DietDay>
    implements $DietDayCopyWith<$Res> {
  _$DietDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DietDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? breakfast = null,
    Object? lunch = null,
    Object? dinner = null,
    Object? snacks = null,
  }) {
    return _then(_value.copyWith(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      breakfast: null == breakfast
          ? _value.breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as String,
      lunch: null == lunch
          ? _value.lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as String,
      dinner: null == dinner
          ? _value.dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as String,
      snacks: null == snacks
          ? _value.snacks
          : snacks // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DietDayImplCopyWith<$Res> implements $DietDayCopyWith<$Res> {
  factory _$$DietDayImplCopyWith(
          _$DietDayImpl value, $Res Function(_$DietDayImpl) then) =
      __$$DietDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int dayNumber,
      String breakfast,
      String lunch,
      String dinner,
      String snacks});
}

/// @nodoc
class __$$DietDayImplCopyWithImpl<$Res>
    extends _$DietDayCopyWithImpl<$Res, _$DietDayImpl>
    implements _$$DietDayImplCopyWith<$Res> {
  __$$DietDayImplCopyWithImpl(
      _$DietDayImpl _value, $Res Function(_$DietDayImpl) _then)
      : super(_value, _then);

  /// Create a copy of DietDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? breakfast = null,
    Object? lunch = null,
    Object? dinner = null,
    Object? snacks = null,
  }) {
    return _then(_$DietDayImpl(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      breakfast: null == breakfast
          ? _value.breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as String,
      lunch: null == lunch
          ? _value.lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as String,
      dinner: null == dinner
          ? _value.dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as String,
      snacks: null == snacks
          ? _value.snacks
          : snacks // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DietDayImpl implements _DietDay {
  const _$DietDayImpl(
      {required this.dayNumber,
      required this.breakfast,
      required this.lunch,
      required this.dinner,
      required this.snacks});

  factory _$DietDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$DietDayImplFromJson(json);

  @override
  final int dayNumber;
  @override
  final String breakfast;
  @override
  final String lunch;
  @override
  final String dinner;
  @override
  final String snacks;

  @override
  String toString() {
    return 'DietDay(dayNumber: $dayNumber, breakfast: $breakfast, lunch: $lunch, dinner: $dinner, snacks: $snacks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DietDayImpl &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            (identical(other.breakfast, breakfast) ||
                other.breakfast == breakfast) &&
            (identical(other.lunch, lunch) || other.lunch == lunch) &&
            (identical(other.dinner, dinner) || other.dinner == dinner) &&
            (identical(other.snacks, snacks) || other.snacks == snacks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, dayNumber, breakfast, lunch, dinner, snacks);

  /// Create a copy of DietDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DietDayImplCopyWith<_$DietDayImpl> get copyWith =>
      __$$DietDayImplCopyWithImpl<_$DietDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DietDayImplToJson(
      this,
    );
  }
}

abstract class _DietDay implements DietDay {
  const factory _DietDay(
      {required final int dayNumber,
      required final String breakfast,
      required final String lunch,
      required final String dinner,
      required final String snacks}) = _$DietDayImpl;

  factory _DietDay.fromJson(Map<String, dynamic> json) = _$DietDayImpl.fromJson;

  @override
  int get dayNumber;
  @override
  String get breakfast;
  @override
  String get lunch;
  @override
  String get dinner;
  @override
  String get snacks;

  /// Create a copy of DietDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DietDayImplCopyWith<_$DietDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
