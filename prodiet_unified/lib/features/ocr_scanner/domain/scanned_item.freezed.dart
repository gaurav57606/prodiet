// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanned_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScannedItem _$ScannedItemFromJson(Map<String, dynamic> json) {
  return _ScannedItem.fromJson(json);
}

/// @nodoc
mixin _$ScannedItem {
  String get name => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  /// Serializes this ScannedItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScannedItemCopyWith<ScannedItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScannedItemCopyWith<$Res> {
  factory $ScannedItemCopyWith(
          ScannedItem value, $Res Function(ScannedItem) then) =
      _$ScannedItemCopyWithImpl<$Res, ScannedItem>;
  @useResult
  $Res call(
      {String name,
      double quantity,
      String unit,
      String category,
      bool isSelected});
}

/// @nodoc
class _$ScannedItemCopyWithImpl<$Res, $Val extends ScannedItem>
    implements $ScannedItemCopyWith<$Res> {
  _$ScannedItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScannedItemImplCopyWith<$Res>
    implements $ScannedItemCopyWith<$Res> {
  factory _$$ScannedItemImplCopyWith(
          _$ScannedItemImpl value, $Res Function(_$ScannedItemImpl) then) =
      __$$ScannedItemImplCopyWithImpl<$Res>;
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
class __$$ScannedItemImplCopyWithImpl<$Res>
    extends _$ScannedItemCopyWithImpl<$Res, _$ScannedItemImpl>
    implements _$$ScannedItemImplCopyWith<$Res> {
  __$$ScannedItemImplCopyWithImpl(
      _$ScannedItemImpl _value, $Res Function(_$ScannedItemImpl) _then)
      : super(_value, _then);

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
    return _then(_$ScannedItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScannedItemImpl implements _ScannedItem {
  const _$ScannedItemImpl(
      {required this.name,
      required this.quantity,
      required this.unit,
      required this.category,
      this.isSelected = true});

  factory _$ScannedItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScannedItemImplFromJson(json);

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

  @override
  String toString() {
    return 'ScannedItem(name: $name, quantity: $quantity, unit: $unit, category: $category, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScannedItemImpl &&
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

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScannedItemImplCopyWith<_$ScannedItemImpl> get copyWith =>
      __$$ScannedItemImplCopyWithImpl<_$ScannedItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScannedItemImplToJson(
      this,
    );
  }
}

abstract class _ScannedItem implements ScannedItem {
  const factory _ScannedItem(
      {required final String name,
      required final double quantity,
      required final String unit,
      required final String category,
      final bool isSelected}) = _$ScannedItemImpl;

  factory _ScannedItem.fromJson(Map<String, dynamic> json) =
      _$ScannedItemImpl.fromJson;

  @override
  String get name;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  String get category;
  @override
  bool get isSelected;

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScannedItemImplCopyWith<_$ScannedItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
