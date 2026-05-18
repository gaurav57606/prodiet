// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Meal {
  String get id;
  String get userId;
  String get name;
  MealType get mealType;
  double get calories;
  double get proteinG;
  double get carbsG;
  double get fatG;
  List<String> get ingredients;
  MealStatus get status;
  DateTime get plannedDate;
  DateTime get createdAt;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealCopyWith<Meal> get copyWith =>
      _$MealCopyWithImpl<Meal>(this as Meal, _$identity);

  /// Serializes this Meal to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Meal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            const DeepCollectionEquality()
                .equals(other.ingredients, ingredients) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.plannedDate, plannedDate) ||
                other.plannedDate == plannedDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      mealType,
      calories,
      proteinG,
      carbsG,
      fatG,
      const DeepCollectionEquality().hash(ingredients),
      status,
      plannedDate,
      createdAt);

  @override
  String toString() {
    return 'Meal(id: $id, userId: $userId, name: $name, mealType: $mealType, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, ingredients: $ingredients, status: $status, plannedDate: $plannedDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $MealCopyWith<$Res> {
  factory $MealCopyWith(Meal value, $Res Function(Meal) _then) =
      _$MealCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      MealType mealType,
      double calories,
      double proteinG,
      double carbsG,
      double fatG,
      List<String> ingredients,
      MealStatus status,
      DateTime plannedDate,
      DateTime createdAt});
}

/// @nodoc
class _$MealCopyWithImpl<$Res> implements $MealCopyWith<$Res> {
  _$MealCopyWithImpl(this._self, this._then);

  final Meal _self;
  final $Res Function(Meal) _then;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? mealType = null,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? ingredients = null,
    Object? status = null,
    Object? plannedDate = null,
    Object? createdAt = null,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _self.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
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
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MealStatus,
      plannedDate: null == plannedDate
          ? _self.plannedDate
          : plannedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [Meal].
extension MealPatterns on Meal {
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
    TResult Function(_Meal value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Meal() when $default != null:
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
    TResult Function(_Meal value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Meal():
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
    TResult? Function(_Meal value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Meal() when $default != null:
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
            String name,
            MealType mealType,
            double calories,
            double proteinG,
            double carbsG,
            double fatG,
            List<String> ingredients,
            MealStatus status,
            DateTime plannedDate,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Meal() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.name,
            _that.mealType,
            _that.calories,
            _that.proteinG,
            _that.carbsG,
            _that.fatG,
            _that.ingredients,
            _that.status,
            _that.plannedDate,
            _that.createdAt);
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
            String name,
            MealType mealType,
            double calories,
            double proteinG,
            double carbsG,
            double fatG,
            List<String> ingredients,
            MealStatus status,
            DateTime plannedDate,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Meal():
        return $default(
            _that.id,
            _that.userId,
            _that.name,
            _that.mealType,
            _that.calories,
            _that.proteinG,
            _that.carbsG,
            _that.fatG,
            _that.ingredients,
            _that.status,
            _that.plannedDate,
            _that.createdAt);
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
            String name,
            MealType mealType,
            double calories,
            double proteinG,
            double carbsG,
            double fatG,
            List<String> ingredients,
            MealStatus status,
            DateTime plannedDate,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Meal() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.name,
            _that.mealType,
            _that.calories,
            _that.proteinG,
            _that.carbsG,
            _that.fatG,
            _that.ingredients,
            _that.status,
            _that.plannedDate,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Meal implements Meal {
  const _Meal(
      {required this.id,
      required this.userId,
      required this.name,
      required this.mealType,
      required this.calories,
      required this.proteinG,
      required this.carbsG,
      required this.fatG,
      required final List<String> ingredients,
      required this.status,
      required this.plannedDate,
      required this.createdAt})
      : _ingredients = ingredients;
  factory _Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final MealType mealType;
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

  @override
  final MealStatus status;
  @override
  final DateTime plannedDate;
  @override
  final DateTime createdAt;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealCopyWith<_Meal> get copyWith =>
      __$MealCopyWithImpl<_Meal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Meal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.plannedDate, plannedDate) ||
                other.plannedDate == plannedDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      mealType,
      calories,
      proteinG,
      carbsG,
      fatG,
      const DeepCollectionEquality().hash(_ingredients),
      status,
      plannedDate,
      createdAt);

  @override
  String toString() {
    return 'Meal(id: $id, userId: $userId, name: $name, mealType: $mealType, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, ingredients: $ingredients, status: $status, plannedDate: $plannedDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$MealCopyWith<$Res> implements $MealCopyWith<$Res> {
  factory _$MealCopyWith(_Meal value, $Res Function(_Meal) _then) =
      __$MealCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      MealType mealType,
      double calories,
      double proteinG,
      double carbsG,
      double fatG,
      List<String> ingredients,
      MealStatus status,
      DateTime plannedDate,
      DateTime createdAt});
}

/// @nodoc
class __$MealCopyWithImpl<$Res> implements _$MealCopyWith<$Res> {
  __$MealCopyWithImpl(this._self, this._then);

  final _Meal _self;
  final $Res Function(_Meal) _then;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? mealType = null,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? ingredients = null,
    Object? status = null,
    Object? plannedDate = null,
    Object? createdAt = null,
  }) {
    return _then(_Meal(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _self.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
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
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MealStatus,
      plannedDate: null == plannedDate
          ? _self.plannedDate
          : plannedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
