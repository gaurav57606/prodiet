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
  List<DietMeal> get breakfast => throw _privateConstructorUsedError;
  List<DietMeal> get lunch => throw _privateConstructorUsedError;
  List<DietMeal> get dinner => throw _privateConstructorUsedError;
  List<DietMeal> get snacks => throw _privateConstructorUsedError;
  double get totalCalories => throw _privateConstructorUsedError;

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
      List<DietMeal> breakfast,
      List<DietMeal> lunch,
      List<DietMeal> dinner,
      List<DietMeal> snacks,
      double totalCalories});
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
    Object? totalCalories = null,
  }) {
    return _then(_value.copyWith(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      breakfast: null == breakfast
          ? _value.breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      lunch: null == lunch
          ? _value.lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      dinner: null == dinner
          ? _value.dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      snacks: null == snacks
          ? _value.snacks
          : snacks // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as double,
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
      List<DietMeal> breakfast,
      List<DietMeal> lunch,
      List<DietMeal> dinner,
      List<DietMeal> snacks,
      double totalCalories});
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
    Object? totalCalories = null,
  }) {
    return _then(_$DietDayImpl(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      breakfast: null == breakfast
          ? _value._breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      lunch: null == lunch
          ? _value._lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      dinner: null == dinner
          ? _value._dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      snacks: null == snacks
          ? _value._snacks
          : snacks // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DietDayImpl implements _DietDay {
  const _$DietDayImpl(
      {required this.dayNumber,
      required final List<DietMeal> breakfast,
      required final List<DietMeal> lunch,
      required final List<DietMeal> dinner,
      required final List<DietMeal> snacks,
      required this.totalCalories})
      : _breakfast = breakfast,
        _lunch = lunch,
        _dinner = dinner,
        _snacks = snacks;

  factory _$DietDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$DietDayImplFromJson(json);

  @override
  final int dayNumber;
  final List<DietMeal> _breakfast;
  @override
  List<DietMeal> get breakfast {
    if (_breakfast is EqualUnmodifiableListView) return _breakfast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breakfast);
  }

  final List<DietMeal> _lunch;
  @override
  List<DietMeal> get lunch {
    if (_lunch is EqualUnmodifiableListView) return _lunch;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lunch);
  }

  final List<DietMeal> _dinner;
  @override
  List<DietMeal> get dinner {
    if (_dinner is EqualUnmodifiableListView) return _dinner;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dinner);
  }

  final List<DietMeal> _snacks;
  @override
  List<DietMeal> get snacks {
    if (_snacks is EqualUnmodifiableListView) return _snacks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_snacks);
  }

  @override
  final double totalCalories;

  @override
  String toString() {
    return 'DietDay(dayNumber: $dayNumber, breakfast: $breakfast, lunch: $lunch, dinner: $dinner, snacks: $snacks, totalCalories: $totalCalories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DietDayImpl &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            const DeepCollectionEquality()
                .equals(other._breakfast, _breakfast) &&
            const DeepCollectionEquality().equals(other._lunch, _lunch) &&
            const DeepCollectionEquality().equals(other._dinner, _dinner) &&
            const DeepCollectionEquality().equals(other._snacks, _snacks) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dayNumber,
      const DeepCollectionEquality().hash(_breakfast),
      const DeepCollectionEquality().hash(_lunch),
      const DeepCollectionEquality().hash(_dinner),
      const DeepCollectionEquality().hash(_snacks),
      totalCalories);

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
      required final List<DietMeal> breakfast,
      required final List<DietMeal> lunch,
      required final List<DietMeal> dinner,
      required final List<DietMeal> snacks,
      required final double totalCalories}) = _$DietDayImpl;

  factory _DietDay.fromJson(Map<String, dynamic> json) = _$DietDayImpl.fromJson;

  @override
  int get dayNumber;
  @override
  List<DietMeal> get breakfast;
  @override
  List<DietMeal> get lunch;
  @override
  List<DietMeal> get dinner;
  @override
  List<DietMeal> get snacks;
  @override
  double get totalCalories;

  /// Create a copy of DietDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DietDayImplCopyWith<_$DietDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
