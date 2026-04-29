// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DietPlan _$DietPlanFromJson(Map<String, dynamic> json) {
  return _DietPlan.fromJson(json);
}

/// @nodoc
mixin _$DietPlan {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<DietDay> get days => throw _privateConstructorUsedError;
  int get summaryCalories => throw _privateConstructorUsedError;
  int get summaryProteinG => throw _privateConstructorUsedError;
  int get summaryCarbsG => throw _privateConstructorUsedError;
  int get summaryFatG => throw _privateConstructorUsedError;
  String get fitnessGoal => throw _privateConstructorUsedError;
  String get activityLevel => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;
  bool get isFavorited => throw _privateConstructorUsedError;

  /// Serializes this DietPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DietPlanCopyWith<DietPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DietPlanCopyWith<$Res> {
  factory $DietPlanCopyWith(DietPlan value, $Res Function(DietPlan) then) =
      _$DietPlanCopyWithImpl<$Res, DietPlan>;
  @useResult
  $Res call(
      {String id,
      String userId,
      List<DietDay> days,
      int summaryCalories,
      int summaryProteinG,
      int summaryCarbsG,
      int summaryFatG,
      String fitnessGoal,
      String activityLevel,
      DateTime generatedAt,
      bool isFavorited});
}

/// @nodoc
class _$DietPlanCopyWithImpl<$Res, $Val extends DietPlan>
    implements $DietPlanCopyWith<$Res> {
  _$DietPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? days = null,
    Object? summaryCalories = null,
    Object? summaryProteinG = null,
    Object? summaryCarbsG = null,
    Object? summaryFatG = null,
    Object? fitnessGoal = null,
    Object? activityLevel = null,
    Object? generatedAt = null,
    Object? isFavorited = null,
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
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DietDay>,
      summaryCalories: null == summaryCalories
          ? _value.summaryCalories
          : summaryCalories // ignore: cast_nullable_to_non_nullable
              as int,
      summaryProteinG: null == summaryProteinG
          ? _value.summaryProteinG
          : summaryProteinG // ignore: cast_nullable_to_non_nullable
              as int,
      summaryCarbsG: null == summaryCarbsG
          ? _value.summaryCarbsG
          : summaryCarbsG // ignore: cast_nullable_to_non_nullable
              as int,
      summaryFatG: null == summaryFatG
          ? _value.summaryFatG
          : summaryFatG // ignore: cast_nullable_to_non_nullable
              as int,
      fitnessGoal: null == fitnessGoal
          ? _value.fitnessGoal
          : fitnessGoal // ignore: cast_nullable_to_non_nullable
              as String,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFavorited: null == isFavorited
          ? _value.isFavorited
          : isFavorited // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DietPlanImplCopyWith<$Res>
    implements $DietPlanCopyWith<$Res> {
  factory _$$DietPlanImplCopyWith(
          _$DietPlanImpl value, $Res Function(_$DietPlanImpl) then) =
      __$$DietPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      List<DietDay> days,
      int summaryCalories,
      int summaryProteinG,
      int summaryCarbsG,
      int summaryFatG,
      String fitnessGoal,
      String activityLevel,
      DateTime generatedAt,
      bool isFavorited});
}

/// @nodoc
class __$$DietPlanImplCopyWithImpl<$Res>
    extends _$DietPlanCopyWithImpl<$Res, _$DietPlanImpl>
    implements _$$DietPlanImplCopyWith<$Res> {
  __$$DietPlanImplCopyWithImpl(
      _$DietPlanImpl _value, $Res Function(_$DietPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? days = null,
    Object? summaryCalories = null,
    Object? summaryProteinG = null,
    Object? summaryCarbsG = null,
    Object? summaryFatG = null,
    Object? fitnessGoal = null,
    Object? activityLevel = null,
    Object? generatedAt = null,
    Object? isFavorited = null,
  }) {
    return _then(_$DietPlanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DietDay>,
      summaryCalories: null == summaryCalories
          ? _value.summaryCalories
          : summaryCalories // ignore: cast_nullable_to_non_nullable
              as int,
      summaryProteinG: null == summaryProteinG
          ? _value.summaryProteinG
          : summaryProteinG // ignore: cast_nullable_to_non_nullable
              as int,
      summaryCarbsG: null == summaryCarbsG
          ? _value.summaryCarbsG
          : summaryCarbsG // ignore: cast_nullable_to_non_nullable
              as int,
      summaryFatG: null == summaryFatG
          ? _value.summaryFatG
          : summaryFatG // ignore: cast_nullable_to_non_nullable
              as int,
      fitnessGoal: null == fitnessGoal
          ? _value.fitnessGoal
          : fitnessGoal // ignore: cast_nullable_to_non_nullable
              as String,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFavorited: null == isFavorited
          ? _value.isFavorited
          : isFavorited // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DietPlanImpl implements _DietPlan {
  const _$DietPlanImpl(
      {required this.id,
      required this.userId,
      required final List<DietDay> days,
      required this.summaryCalories,
      required this.summaryProteinG,
      required this.summaryCarbsG,
      required this.summaryFatG,
      required this.fitnessGoal,
      required this.activityLevel,
      required this.generatedAt,
      this.isFavorited = false})
      : _days = days;

  factory _$DietPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$DietPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  final List<DietDay> _days;
  @override
  List<DietDay> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  final int summaryCalories;
  @override
  final int summaryProteinG;
  @override
  final int summaryCarbsG;
  @override
  final int summaryFatG;
  @override
  final String fitnessGoal;
  @override
  final String activityLevel;
  @override
  final DateTime generatedAt;
  @override
  @JsonKey()
  final bool isFavorited;

  @override
  String toString() {
    return 'DietPlan(id: $id, userId: $userId, days: $days, summaryCalories: $summaryCalories, summaryProteinG: $summaryProteinG, summaryCarbsG: $summaryCarbsG, summaryFatG: $summaryFatG, fitnessGoal: $fitnessGoal, activityLevel: $activityLevel, generatedAt: $generatedAt, isFavorited: $isFavorited)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DietPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.summaryCalories, summaryCalories) ||
                other.summaryCalories == summaryCalories) &&
            (identical(other.summaryProteinG, summaryProteinG) ||
                other.summaryProteinG == summaryProteinG) &&
            (identical(other.summaryCarbsG, summaryCarbsG) ||
                other.summaryCarbsG == summaryCarbsG) &&
            (identical(other.summaryFatG, summaryFatG) ||
                other.summaryFatG == summaryFatG) &&
            (identical(other.fitnessGoal, fitnessGoal) ||
                other.fitnessGoal == fitnessGoal) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.isFavorited, isFavorited) ||
                other.isFavorited == isFavorited));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      const DeepCollectionEquality().hash(_days),
      summaryCalories,
      summaryProteinG,
      summaryCarbsG,
      summaryFatG,
      fitnessGoal,
      activityLevel,
      generatedAt,
      isFavorited);

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DietPlanImplCopyWith<_$DietPlanImpl> get copyWith =>
      __$$DietPlanImplCopyWithImpl<_$DietPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DietPlanImplToJson(
      this,
    );
  }
}

abstract class _DietPlan implements DietPlan {
  const factory _DietPlan(
      {required final String id,
      required final String userId,
      required final List<DietDay> days,
      required final int summaryCalories,
      required final int summaryProteinG,
      required final int summaryCarbsG,
      required final int summaryFatG,
      required final String fitnessGoal,
      required final String activityLevel,
      required final DateTime generatedAt,
      final bool isFavorited}) = _$DietPlanImpl;

  factory _DietPlan.fromJson(Map<String, dynamic> json) =
      _$DietPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  List<DietDay> get days;
  @override
  int get summaryCalories;
  @override
  int get summaryProteinG;
  @override
  int get summaryCarbsG;
  @override
  int get summaryFatG;
  @override
  String get fitnessGoal;
  @override
  String get activityLevel;
  @override
  DateTime get generatedAt;
  @override
  bool get isFavorited;

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DietPlanImplCopyWith<_$DietPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
