// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DietMeal {
  String get name;
  double get calories;
  double get proteinG;
  double get carbsG;
  double get fatG;
  List<String> get ingredients;

  /// Create a copy of DietMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DietMealCopyWith<DietMeal> get copyWith =>
      _$DietMealCopyWithImpl<DietMeal>(this as DietMeal, _$identity);

  /// Serializes this DietMeal to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DietMeal &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            const DeepCollectionEquality()
                .equals(other.ingredients, ingredients));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, calories, proteinG, carbsG,
      fatG, const DeepCollectionEquality().hash(ingredients));

  @override
  String toString() {
    return 'DietMeal(name: $name, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, ingredients: $ingredients)';
  }
}

/// @nodoc
abstract mixin class $DietMealCopyWith<$Res> {
  factory $DietMealCopyWith(DietMeal value, $Res Function(DietMeal) _then) =
      _$DietMealCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      double calories,
      double proteinG,
      double carbsG,
      double fatG,
      List<String> ingredients});
}

/// @nodoc
class _$DietMealCopyWithImpl<$Res> implements $DietMealCopyWith<$Res> {
  _$DietMealCopyWithImpl(this._self, this._then);

  final DietMeal _self;
  final $Res Function(DietMeal) _then;

  /// Create a copy of DietMeal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? ingredients = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      calories: null == calories
          ? _self.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      proteinG: null == proteinG
          ? _self.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as double,
      carbsG: null == carbsG
          ? _self.carbsG
          : carbsG // ignore: cast_nullable_to_non_nullable
              as double,
      fatG: null == fatG
          ? _self.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as double,
      ingredients: null == ingredients
          ? _self.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DietMeal].
extension DietMealPatterns on DietMeal {
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
    TResult Function(_DietMeal value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DietMeal() when $default != null:
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
    TResult Function(_DietMeal value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietMeal():
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
    TResult? Function(_DietMeal value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietMeal() when $default != null:
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
    TResult Function(String name, double calories, double proteinG,
            double carbsG, double fatG, List<String> ingredients)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DietMeal() when $default != null:
        return $default(_that.name, _that.calories, _that.proteinG,
            _that.carbsG, _that.fatG, _that.ingredients);
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
    TResult Function(String name, double calories, double proteinG,
            double carbsG, double fatG, List<String> ingredients)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietMeal():
        return $default(_that.name, _that.calories, _that.proteinG,
            _that.carbsG, _that.fatG, _that.ingredients);
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
    TResult? Function(String name, double calories, double proteinG,
            double carbsG, double fatG, List<String> ingredients)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DietMeal() when $default != null:
        return $default(_that.name, _that.calories, _that.proteinG,
            _that.carbsG, _that.fatG, _that.ingredients);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DietMeal implements DietMeal {
  const _DietMeal(
      {required this.name,
      required this.calories,
      required this.proteinG,
      required this.carbsG,
      required this.fatG,
      required final List<String> ingredients})
      : _ingredients = ingredients;
  factory _DietMeal.fromJson(Map<String, dynamic> json) =>
      _$DietMealFromJson(json);

  @override
  final String name;
  @override
  final double calories;
  @override
  final double proteinG;
  @override
  final double carbsG;
  @override
  final double fatG;
  final List<String> _ingredients;
  @override
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  /// Create a copy of DietMeal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DietMealCopyWith<_DietMeal> get copyWith =>
      __$DietMealCopyWithImpl<_DietMeal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DietMealToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DietMeal &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, calories, proteinG, carbsG,
      fatG, const DeepCollectionEquality().hash(_ingredients));

  @override
  String toString() {
    return 'DietMeal(name: $name, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, ingredients: $ingredients)';
  }
}

/// @nodoc
abstract mixin class _$DietMealCopyWith<$Res>
    implements $DietMealCopyWith<$Res> {
  factory _$DietMealCopyWith(_DietMeal value, $Res Function(_DietMeal) _then) =
      __$DietMealCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      double calories,
      double proteinG,
      double carbsG,
      double fatG,
      List<String> ingredients});
}

/// @nodoc
class __$DietMealCopyWithImpl<$Res> implements _$DietMealCopyWith<$Res> {
  __$DietMealCopyWithImpl(this._self, this._then);

  final _DietMeal _self;
  final $Res Function(_DietMeal) _then;

  /// Create a copy of DietMeal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? ingredients = null,
  }) {
    return _then(_DietMeal(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      calories: null == calories
          ? _self.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      proteinG: null == proteinG
          ? _self.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as double,
      carbsG: null == carbsG
          ? _self.carbsG
          : carbsG // ignore: cast_nullable_to_non_nullable
              as double,
      fatG: null == fatG
          ? _self.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as double,
      ingredients: null == ingredients
          ? _self._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
