// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DietPlan {
  String get id;
  String get userId;
  DateTime get generatedAt;
  List<DietDay> get days;
  double get summaryCalories;
  double get summaryProteinG;
  double get summaryCarbsG;
  double get summaryFatG;
  bool get isActive;

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DietPlanCopyWith<DietPlan> get copyWith =>
      _$DietPlanCopyWithImpl<DietPlan>(this as DietPlan, _$identity);

  /// Serializes this DietPlan to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DietPlan &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            const DeepCollectionEquality().equals(other.days, days) &&
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
      const DeepCollectionEquality().hash(days),
      summaryCalories,
      summaryProteinG,
      summaryCarbsG,
      summaryFatG,
      isActive);

  @override
  String toString() {
    return 'DietPlan(id: $id, userId: $userId, generatedAt: $generatedAt, days: $days, summaryCalories: $summaryCalories, summaryProteinG: $summaryProteinG, summaryCarbsG: $summaryCarbsG, summaryFatG: $summaryFatG, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class $DietPlanCopyWith<$Res> {
  factory $DietPlanCopyWith(DietPlan value, $Res Function(DietPlan) _then) =
      _$DietPlanCopyWithImpl;
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
class _$DietPlanCopyWithImpl<$Res> implements $DietPlanCopyWith<$Res> {
  _$DietPlanCopyWithImpl(this._self, this._then);

  final DietPlan _self;
  final $Res Function(DietPlan) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _self.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      days: null == days
          ? _self.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DietDay>,
      summaryCalories: null == summaryCalories
          ? _self.summaryCalories
          : summaryCalories // ignore: cast_nullable_to_non_nullable
              as double,
      summaryProteinG: null == summaryProteinG
          ? _self.summaryProteinG
          : summaryProteinG // ignore: cast_nullable_to_non_nullable
              as double,
      summaryCarbsG: null == summaryCarbsG
          ? _self.summaryCarbsG
          : summaryCarbsG // ignore: cast_nullable_to_non_nullable
              as double,
      summaryFatG: null == summaryFatG
          ? _self.summaryFatG
          : summaryFatG // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [DietPlan].
extension DietPlanPatterns on DietPlan {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DietPlan value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DietPlan() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DietPlan value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietPlan():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DietPlan value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietPlan() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String userId,
            DateTime generatedAt,
            List<DietDay> days,
            double summaryCalories,
            double summaryProteinG,
            double summaryCarbsG,
            double summaryFatG,
            bool isActive)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DietPlan() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.generatedAt,
            _that.days,
            _that.summaryCalories,
            _that.summaryProteinG,
            _that.summaryCarbsG,
            _that.summaryFatG,
            _that.isActive);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String userId,
            DateTime generatedAt,
            List<DietDay> days,
            double summaryCalories,
            double summaryProteinG,
            double summaryCarbsG,
            double summaryFatG,
            bool isActive)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietPlan():
        return $default(
            _that.id,
            _that.userId,
            _that.generatedAt,
            _that.days,
            _that.summaryCalories,
            _that.summaryProteinG,
            _that.summaryCarbsG,
            _that.summaryFatG,
            _that.isActive);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String userId,
            DateTime generatedAt,
            List<DietDay> days,
            double summaryCalories,
            double summaryProteinG,
            double summaryCarbsG,
            double summaryFatG,
            bool isActive)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietPlan() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.generatedAt,
            _that.days,
            _that.summaryCalories,
            _that.summaryProteinG,
            _that.summaryCarbsG,
            _that.summaryFatG,
            _that.isActive);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DietPlan implements DietPlan {
  const _DietPlan(
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
  factory _DietPlan.fromJson(Map<String, dynamic> json) =>
      _$DietPlanFromJson(json);

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

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DietPlanCopyWith<_DietPlan> get copyWith =>
      __$DietPlanCopyWithImpl<_DietPlan>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DietPlanToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DietPlan &&
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

  @override
  String toString() {
    return 'DietPlan(id: $id, userId: $userId, generatedAt: $generatedAt, days: $days, summaryCalories: $summaryCalories, summaryProteinG: $summaryProteinG, summaryCarbsG: $summaryCarbsG, summaryFatG: $summaryFatG, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class _$DietPlanCopyWith<$Res>
    implements $DietPlanCopyWith<$Res> {
  factory _$DietPlanCopyWith(_DietPlan value, $Res Function(_DietPlan) _then) =
      __$DietPlanCopyWithImpl;
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
class __$DietPlanCopyWithImpl<$Res> implements _$DietPlanCopyWith<$Res> {
  __$DietPlanCopyWithImpl(this._self, this._then);

  final _DietPlan _self;
  final $Res Function(_DietPlan) _then;

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_DietPlan(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _self.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      days: null == days
          ? _self._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DietDay>,
      summaryCalories: null == summaryCalories
          ? _self.summaryCalories
          : summaryCalories // ignore: cast_nullable_to_non_nullable
              as double,
      summaryProteinG: null == summaryProteinG
          ? _self.summaryProteinG
          : summaryProteinG // ignore: cast_nullable_to_non_nullable
              as double,
      summaryCarbsG: null == summaryCarbsG
          ? _self.summaryCarbsG
          : summaryCarbsG // ignore: cast_nullable_to_non_nullable
              as double,
      summaryFatG: null == summaryFatG
          ? _self.summaryFatG
          : summaryFatG // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
