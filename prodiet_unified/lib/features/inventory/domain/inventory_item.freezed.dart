// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryItem {
  String get id;
  String get userId;
  String get ingredientName;
  double get quantity;
  String get unit;
  String get category;
  double get reorderThreshold;
  DateTime get updatedAt;

  /// Create a copy of InventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InventoryItemCopyWith<InventoryItem> get copyWith =>
      _$InventoryItemCopyWithImpl<InventoryItem>(
          this as InventoryItem, _$identity);

  /// Serializes this InventoryItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InventoryItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.ingredientName, ingredientName) ||
                other.ingredientName == ingredientName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.reorderThreshold, reorderThreshold) ||
                other.reorderThreshold == reorderThreshold) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, ingredientName,
      quantity, unit, category, reorderThreshold, updatedAt);

  @override
  String toString() {
    return 'InventoryItem(id: $id, userId: $userId, ingredientName: $ingredientName, quantity: $quantity, unit: $unit, category: $category, reorderThreshold: $reorderThreshold, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $InventoryItemCopyWith<$Res> {
  factory $InventoryItemCopyWith(
          InventoryItem value, $Res Function(InventoryItem) _then) =
      _$InventoryItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String ingredientName,
      double quantity,
      String unit,
      String category,
      double reorderThreshold,
      DateTime updatedAt});
}

/// @nodoc
class _$InventoryItemCopyWithImpl<$Res>
    implements $InventoryItemCopyWith<$Res> {
  _$InventoryItemCopyWithImpl(this._self, this._then);

  final InventoryItem _self;
  final $Res Function(InventoryItem) _then;

  /// Create a copy of InventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? ingredientName = null,
    Object? quantity = null,
    Object? unit = null,
    Object? category = null,
    Object? reorderThreshold = null,
    Object? updatedAt = null,
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
      ingredientName: null == ingredientName
          ? _self.ingredientName
          : ingredientName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      reorderThreshold: null == reorderThreshold
          ? _self.reorderThreshold
          : reorderThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [InventoryItem].
extension InventoryItemPatterns on InventoryItem {
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
    TResult Function(_InventoryItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InventoryItem() when $default != null:
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
    TResult Function(_InventoryItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InventoryItem():
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
    TResult? Function(_InventoryItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InventoryItem() when $default != null:
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
            String ingredientName,
            double quantity,
            String unit,
            String category,
            double reorderThreshold,
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InventoryItem() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.ingredientName,
            _that.quantity,
            _that.unit,
            _that.category,
            _that.reorderThreshold,
            _that.updatedAt);
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
            String ingredientName,
            double quantity,
            String unit,
            String category,
            double reorderThreshold,
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InventoryItem():
        return $default(
            _that.id,
            _that.userId,
            _that.ingredientName,
            _that.quantity,
            _that.unit,
            _that.category,
            _that.reorderThreshold,
            _that.updatedAt);
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
            String ingredientName,
            double quantity,
            String unit,
            String category,
            double reorderThreshold,
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InventoryItem() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.ingredientName,
            _that.quantity,
            _that.unit,
            _that.category,
            _that.reorderThreshold,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _InventoryItem extends InventoryItem {
  const _InventoryItem(
      {required this.id,
      required this.userId,
      required this.ingredientName,
      required this.quantity,
      required this.unit,
      required this.category,
      required this.reorderThreshold,
      required this.updatedAt})
      : super._();
  factory _InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String ingredientName;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final String category;
  @override
  final double reorderThreshold;
  @override
  final DateTime updatedAt;

  /// Create a copy of InventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InventoryItemCopyWith<_InventoryItem> get copyWith =>
      __$InventoryItemCopyWithImpl<_InventoryItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InventoryItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InventoryItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.ingredientName, ingredientName) ||
                other.ingredientName == ingredientName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.reorderThreshold, reorderThreshold) ||
                other.reorderThreshold == reorderThreshold) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, ingredientName,
      quantity, unit, category, reorderThreshold, updatedAt);

  @override
  String toString() {
    return 'InventoryItem(id: $id, userId: $userId, ingredientName: $ingredientName, quantity: $quantity, unit: $unit, category: $category, reorderThreshold: $reorderThreshold, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$InventoryItemCopyWith<$Res>
    implements $InventoryItemCopyWith<$Res> {
  factory _$InventoryItemCopyWith(
          _InventoryItem value, $Res Function(_InventoryItem) _then) =
      __$InventoryItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String ingredientName,
      double quantity,
      String unit,
      String category,
      double reorderThreshold,
      DateTime updatedAt});
}

/// @nodoc
class __$InventoryItemCopyWithImpl<$Res>
    implements _$InventoryItemCopyWith<$Res> {
  __$InventoryItemCopyWithImpl(this._self, this._then);

  final _InventoryItem _self;
  final $Res Function(_InventoryItem) _then;

  /// Create a copy of InventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? ingredientName = null,
    Object? quantity = null,
    Object? unit = null,
    Object? category = null,
    Object? reorderThreshold = null,
    Object? updatedAt = null,
  }) {
    return _then(_InventoryItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientName: null == ingredientName
          ? _self.ingredientName
          : ingredientName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      reorderThreshold: null == reorderThreshold
          ? _self.reorderThreshold
          : reorderThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
