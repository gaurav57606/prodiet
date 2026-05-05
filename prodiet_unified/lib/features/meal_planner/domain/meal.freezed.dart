// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Meal _$MealFromJson(Map<String, dynamic> json) {
  return _Meal.fromJson(json);
}

/// @nodoc
mixin _$Meal {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  MealType get mealType => throw _privateConstructorUsedError;
  double get calories => throw _privateConstructorUsedError;
  double get proteinG => throw _privateConstructorUsedError;
  double get carbsG => throw _privateConstructorUsedError;
  double get fatG => throw _privateConstructorUsedError;
  List<String> get ingredients => throw _privateConstructorUsedError;
  MealStatus get status => throw _privateConstructorUsedError;
  DateTime get plannedDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Meal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealCopyWith<Meal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealCopyWith<$Res> {
  factory $MealCopyWith(Meal value, $Res Function(Meal) then) =
      _$MealCopyWithImpl<$Res, Meal>;
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
class _$MealCopyWithImpl<$Res, $Val extends Meal>
    implements $MealCopyWith<$Res> {
  _$MealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      proteinG: null == proteinG
          ? _value.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as double,
      carbsG: null == carbsG
          ? _value.carbsG
          : carbsG // ignore: cast_nullable_to_non_nullable
              as double,
      fatG: null == fatG
          ? _value.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as double,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MealStatus,
      plannedDate: null == plannedDate
          ? _value.plannedDate
          : plannedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealImplCopyWith<$Res> implements $MealCopyWith<$Res> {
  factory _$$MealImplCopyWith(
          _$MealImpl value, $Res Function(_$MealImpl) then) =
      __$$MealImplCopyWithImpl<$Res>;
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
class __$$MealImplCopyWithImpl<$Res>
    extends _$MealCopyWithImpl<$Res, _$MealImpl>
    implements _$$MealImplCopyWith<$Res> {
  __$$MealImplCopyWithImpl(_$MealImpl _value, $Res Function(_$MealImpl) _then)
      : super(_value, _then);

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
    return _then(_$MealImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      proteinG: null == proteinG
          ? _value.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as double,
      carbsG: null == carbsG
          ? _value.carbsG
          : carbsG // ignore: cast_nullable_to_non_nullable
              as double,
      fatG: null == fatG
          ? _value.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as double,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MealStatus,
      plannedDate: null == plannedDate
          ? _value.plannedDate
          : plannedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MealImpl implements _Meal {
  const _$MealImpl(
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

  factory _$MealImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealImplFromJson(json);

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

  @override
  String toString() {
    return 'Meal(id: $id, userId: $userId, name: $name, mealType: $mealType, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, ingredients: $ingredients, status: $status, plannedDate: $plannedDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealImpl &&
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

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      __$$MealImplCopyWithImpl<_$MealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealImplToJson(
      this,
    );
  }
}

abstract class _Meal implements Meal {
  const factory _Meal(
      {required final String id,
      required final String userId,
      required final String name,
      required final MealType mealType,
      required final double calories,
      required final double proteinG,
      required final double carbsG,
      required final double fatG,
      required final List<String> ingredients,
      required final MealStatus status,
      required final DateTime plannedDate,
      required final DateTime createdAt}) = _$MealImpl;

  factory _Meal.fromJson(Map<String, dynamic> json) = _$MealImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  MealType get mealType;
  @override
  double get calories;
  @override
  double get proteinG;
  @override
  double get carbsG;
  @override
  double get fatG;
  @override
  List<String> get ingredients;
  @override
  MealStatus get status;
  @override
  DateTime get plannedDate;
  @override
  DateTime get createdAt;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
