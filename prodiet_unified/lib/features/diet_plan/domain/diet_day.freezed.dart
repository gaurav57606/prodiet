// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DietDay {
  int get dayNumber;
  List<DietMeal> get breakfast;
  List<DietMeal> get lunch;
  List<DietMeal> get dinner;
  List<DietMeal> get snacks;
  double get totalCalories;

  /// Create a copy of DietDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DietDayCopyWith<DietDay> get copyWith =>
      _$DietDayCopyWithImpl<DietDay>(this as DietDay, _$identity);

  /// Serializes this DietDay to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DietDay &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            const DeepCollectionEquality().equals(other.breakfast, breakfast) &&
            const DeepCollectionEquality().equals(other.lunch, lunch) &&
            const DeepCollectionEquality().equals(other.dinner, dinner) &&
            const DeepCollectionEquality().equals(other.snacks, snacks) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dayNumber,
      const DeepCollectionEquality().hash(breakfast),
      const DeepCollectionEquality().hash(lunch),
      const DeepCollectionEquality().hash(dinner),
      const DeepCollectionEquality().hash(snacks),
      totalCalories);

  @override
  String toString() {
    return 'DietDay(dayNumber: $dayNumber, breakfast: $breakfast, lunch: $lunch, dinner: $dinner, snacks: $snacks, totalCalories: $totalCalories)';
  }
}

/// @nodoc
abstract mixin class $DietDayCopyWith<$Res> {
  factory $DietDayCopyWith(DietDay value, $Res Function(DietDay) _then) =
      _$DietDayCopyWithImpl;
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
class _$DietDayCopyWithImpl<$Res> implements $DietDayCopyWith<$Res> {
  _$DietDayCopyWithImpl(this._self, this._then);

  final DietDay _self;
  final $Res Function(DietDay) _then;

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
    return _then(_self.copyWith(
      dayNumber: null == dayNumber
          ? _self.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      breakfast: null == breakfast
          ? _self.breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      lunch: null == lunch
          ? _self.lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      dinner: null == dinner
          ? _self.dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      snacks: null == snacks
          ? _self.snacks
          : snacks // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      totalCalories: null == totalCalories
          ? _self.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [DietDay].
extension DietDayPatterns on DietDay {
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
    TResult Function(_DietDay value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DietDay() when $default != null:
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
    TResult Function(_DietDay value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietDay():
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
    TResult? Function(_DietDay value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietDay() when $default != null:
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
            int dayNumber,
            List<DietMeal> breakfast,
            List<DietMeal> lunch,
            List<DietMeal> dinner,
            List<DietMeal> snacks,
            double totalCalories)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DietDay() when $default != null:
        return $default(_that.dayNumber, _that.breakfast, _that.lunch,
            _that.dinner, _that.snacks, _that.totalCalories);
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
            int dayNumber,
            List<DietMeal> breakfast,
            List<DietMeal> lunch,
            List<DietMeal> dinner,
            List<DietMeal> snacks,
            double totalCalories)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietDay():
        return $default(_that.dayNumber, _that.breakfast, _that.lunch,
            _that.dinner, _that.snacks, _that.totalCalories);
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
            int dayNumber,
            List<DietMeal> breakfast,
            List<DietMeal> lunch,
            List<DietMeal> dinner,
            List<DietMeal> snacks,
            double totalCalories)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietDay() when $default != null:
        return $default(_that.dayNumber, _that.breakfast, _that.lunch,
            _that.dinner, _that.snacks, _that.totalCalories);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DietDay extends DietDay {
  const _DietDay(
      {required this.dayNumber,
      required final List<DietMeal> breakfast,
      required final List<DietMeal> lunch,
      required final List<DietMeal> dinner,
      required final List<DietMeal> snacks,
      required this.totalCalories})
      : _breakfast = breakfast,
        _lunch = lunch,
        _dinner = dinner,
        _snacks = snacks,
        super._();
  factory _DietDay.fromJson(Map<String, dynamic> json) =>
      _$DietDayFromJson(json);

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

  /// Create a copy of DietDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DietDayCopyWith<_DietDay> get copyWith =>
      __$DietDayCopyWithImpl<_DietDay>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DietDayToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DietDay &&
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

  @override
  String toString() {
    return 'DietDay(dayNumber: $dayNumber, breakfast: $breakfast, lunch: $lunch, dinner: $dinner, snacks: $snacks, totalCalories: $totalCalories)';
  }
}

/// @nodoc
abstract mixin class _$DietDayCopyWith<$Res> implements $DietDayCopyWith<$Res> {
  factory _$DietDayCopyWith(_DietDay value, $Res Function(_DietDay) _then) =
      __$DietDayCopyWithImpl;
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
class __$DietDayCopyWithImpl<$Res> implements _$DietDayCopyWith<$Res> {
  __$DietDayCopyWithImpl(this._self, this._then);

  final _DietDay _self;
  final $Res Function(_DietDay) _then;

  /// Create a copy of DietDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dayNumber = null,
    Object? breakfast = null,
    Object? lunch = null,
    Object? dinner = null,
    Object? snacks = null,
    Object? totalCalories = null,
  }) {
    return _then(_DietDay(
      dayNumber: null == dayNumber
          ? _self.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      breakfast: null == breakfast
          ? _self._breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      lunch: null == lunch
          ? _self._lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      dinner: null == dinner
          ? _self._dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      snacks: null == snacks
          ? _self._snacks
          : snacks // ignore: cast_nullable_to_non_nullable
              as List<DietMeal>,
      totalCalories: null == totalCalories
          ? _self.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
