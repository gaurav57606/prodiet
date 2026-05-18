// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanned_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScannedItem {
  String get name;
  double get quantity;
  String get unit;
  String get category;
  bool get isSelected;

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScannedItemCopyWith<ScannedItem> get copyWith =>
      _$ScannedItemCopyWithImpl<ScannedItem>(this as ScannedItem, _$identity);

  /// Serializes this ScannedItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScannedItem &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, quantity, unit, category, isSelected);

  @override
  String toString() {
    return 'ScannedItem(name: $name, quantity: $quantity, unit: $unit, category: $category, isSelected: $isSelected)';
  }
}

/// @nodoc
abstract mixin class $ScannedItemCopyWith<$Res> {
  factory $ScannedItemCopyWith(
          ScannedItem value, $Res Function(ScannedItem) _then) =
      _$ScannedItemCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      double quantity,
      String unit,
      String category,
      bool isSelected});
}

/// @nodoc
class _$ScannedItemCopyWithImpl<$Res> implements $ScannedItemCopyWith<$Res> {
  _$ScannedItemCopyWithImpl(this._self, this._then);

  final ScannedItem _self;
  final $Res Function(ScannedItem) _then;

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? category = null,
    Object? isSelected = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
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
      isSelected: null == isSelected
          ? _self.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ScannedItem].
extension ScannedItemPatterns on ScannedItem {
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
    TResult Function(_ScannedItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScannedItem() when $default != null:
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
    TResult Function(_ScannedItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScannedItem():
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
    TResult? Function(_ScannedItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScannedItem() when $default != null:
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
    TResult Function(String name, double quantity, String unit, String category,
            bool isSelected)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScannedItem() when $default != null:
        return $default(_that.name, _that.quantity, _that.unit, _that.category,
            _that.isSelected);
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
    TResult Function(String name, double quantity, String unit, String category,
            bool isSelected)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScannedItem():
        return $default(_that.name, _that.quantity, _that.unit, _that.category,
            _that.isSelected);
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
    TResult? Function(String name, double quantity, String unit,
            String category, bool isSelected)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScannedItem() when $default != null:
        return $default(_that.name, _that.quantity, _that.unit, _that.category,
            _that.isSelected);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ScannedItem implements ScannedItem {
  const _ScannedItem(
      {required this.name,
      required this.quantity,
      required this.unit,
      required this.category,
      this.isSelected = true});
  factory _ScannedItem.fromJson(Map<String, dynamic> json) =>
      _$ScannedItemFromJson(json);

  @override
  final String name;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final String category;
  @override
  @JsonKey()
  final bool isSelected;

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScannedItemCopyWith<_ScannedItem> get copyWith =>
      __$ScannedItemCopyWithImpl<_ScannedItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ScannedItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScannedItem &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, quantity, unit, category, isSelected);

  @override
  String toString() {
    return 'ScannedItem(name: $name, quantity: $quantity, unit: $unit, category: $category, isSelected: $isSelected)';
  }
}

/// @nodoc
abstract mixin class _$ScannedItemCopyWith<$Res>
    implements $ScannedItemCopyWith<$Res> {
  factory _$ScannedItemCopyWith(
          _ScannedItem value, $Res Function(_ScannedItem) _then) =
      __$ScannedItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      double quantity,
      String unit,
      String category,
      bool isSelected});
}

/// @nodoc
class __$ScannedItemCopyWithImpl<$Res> implements _$ScannedItemCopyWith<$Res> {
  __$ScannedItemCopyWithImpl(this._self, this._then);

  final _ScannedItem _self;
  final $Res Function(_ScannedItem) _then;

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? category = null,
    Object? isSelected = null,
  }) {
    return _then(_ScannedItem(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
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
      isSelected: null == isSelected
          ? _self.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
