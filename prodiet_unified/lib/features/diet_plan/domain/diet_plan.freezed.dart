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
  DateTime get generatedAt => throw _privateConstructorUsedError;
  List<DietDay> get days => throw _privateConstructorUsedError;
  double get summaryCalories => throw _privateConstructorUsedError;
  double get summaryProteinG => throw _privateConstructorUsedError;
  double get summaryCarbsG => throw _privateConstructorUsedError;
  double get summaryFatG => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

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
      DateTime generatedAt,
      List<DietDay> days,
      double summaryCalories,
      double summaryProteinG,
      double summaryCarbsG,
      double summaryFatG,
      bool isActive});
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
    Object? generatedAt = null,
    Object? days = null,
    Object? summaryCalories = null,
    Object? summaryProteinG = null,
    Object? summaryCarbsG = null,
    Object? summaryFatG = null,
    Object? isActive = null,
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
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DietDay>,
      summaryCalories: null == summaryCalories
          ? _value.summaryCalories
          : summaryCalories // ignore: cast_nullable_to_non_nullable
              as double,
      summaryProteinG: null == summaryProteinG
          ? _value.summaryProteinG
          : summaryProteinG // ignore: cast_nullable_to_non_nullable
              as double,
      summaryCarbsG: null == summaryCarbsG
          ? _value.summaryCarbsG
          : summaryCarbsG // ignore: cast_nullable_to_non_nullable
              as double,
      summaryFatG: null == summaryFatG
          ? _value.summaryFatG
          : summaryFatG // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
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
      DateTime generatedAt,
      List<DietDay> days,
      double summaryCalories,
      double summaryProteinG,
      double summaryCarbsG,
      double summaryFatG,
      bool isActive});
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
    Object? generatedAt = null,
    Object? days = null,
    Object? summaryCalories = null,
    Object? summaryProteinG = null,
    Object? summaryCarbsG = null,
    Object? summaryFatG = null,
    Object? isActive = null,
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
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DietDay>,
      summaryCalories: null == summaryCalories
          ? _value.summaryCalories
          : summaryCalories // ignore: cast_nullable_to_non_nullable
              as double,
      summaryProteinG: null == summaryProteinG
          ? _value.summaryProteinG
          : summaryProteinG // ignore: cast_nullable_to_non_nullable
              as double,
      summaryCarbsG: null == summaryCarbsG
          ? _value.summaryCarbsG
          : summaryCarbsG // ignore: cast_nullable_to_non_nullable
              as double,
      summaryFatG: null == summaryFatG
          ? _value.summaryFatG
          : summaryFatG // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
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
      required this.generatedAt,
      required final List<DietDay> days,
      required this.summaryCalories,
      required this.summaryProteinG,
      required this.summaryCarbsG,
      required this.summaryFatG,
      required this.isActive})
      : _days = days;

  factory _$DietPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$DietPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime generatedAt;
  final List<DietDay> _days;
  @override
  List<DietDay> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  final double summaryCalories;
  @override
  final double summaryProteinG;
  @override
  final double summaryCarbsG;
  @override
  final double summaryFatG;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'DietPlan(id: $id, userId: $userId, generatedAt: $generatedAt, days: $days, summaryCalories: $summaryCalories, summaryProteinG: $summaryProteinG, summaryCarbsG: $summaryCarbsG, summaryFatG: $summaryFatG, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DietPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.summaryCalories, summaryCalories) ||
                other.summaryCalories == summaryCalories) &&
            (identical(other.summaryProteinG, summaryProteinG) ||
                other.summaryProteinG == summaryProteinG) &&
            (identical(other.summaryCarbsG, summaryCarbsG) ||
                other.summaryCarbsG == summaryCarbsG) &&
            (identical(other.summaryFatG, summaryFatG) ||
                other.summaryFatG == summaryFatG) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      generatedAt,
      const DeepCollectionEquality().hash(_days),
      summaryCalories,
      summaryProteinG,
      summaryCarbsG,
      summaryFatG,
      isActive);

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
      required final DateTime generatedAt,
      required final List<DietDay> days,
      required final double summaryCalories,
      required final double summaryProteinG,
      required final double summaryCarbsG,
      required final double summaryFatG,
      required final bool isActive}) = _$DietPlanImpl;

  factory _DietPlan.fromJson(Map<String, dynamic> json) =
      _$DietPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get generatedAt;
  @override
  List<DietDay> get days;
  @override
  double get summaryCalories;
  @override
  double get summaryProteinG;
  @override
  double get summaryCarbsG;
  @override
  double get summaryFatG;
  @override
  bool get isActive;

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DietPlanImplCopyWith<_$DietPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
