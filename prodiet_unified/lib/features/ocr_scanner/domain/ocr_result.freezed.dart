// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OcrResult _$OcrResultFromJson(Map<String, dynamic> json) {
  return _OcrResult.fromJson(json);
}

/// @nodoc
mixin _$OcrResult {
  List<ScannedItem> get items => throw _privateConstructorUsedError;
  String get rawText => throw _privateConstructorUsedError;
  DateTime get scannedAt => throw _privateConstructorUsedError;

  /// Serializes this OcrResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OcrResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OcrResultCopyWith<OcrResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OcrResultCopyWith<$Res> {
  factory $OcrResultCopyWith(OcrResult value, $Res Function(OcrResult) then) =
      _$OcrResultCopyWithImpl<$Res, OcrResult>;
  @useResult
  $Res call({List<ScannedItem> items, String rawText, DateTime scannedAt});
}

/// @nodoc
class _$OcrResultCopyWithImpl<$Res, $Val extends OcrResult>
    implements $OcrResultCopyWith<$Res> {
  _$OcrResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OcrResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? rawText = null,
    Object? scannedAt = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ScannedItem>,
      rawText: null == rawText
          ? _value.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String,
      scannedAt: null == scannedAt
          ? _value.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OcrResultImplCopyWith<$Res>
    implements $OcrResultCopyWith<$Res> {
  factory _$$OcrResultImplCopyWith(
          _$OcrResultImpl value, $Res Function(_$OcrResultImpl) then) =
      __$$OcrResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ScannedItem> items, String rawText, DateTime scannedAt});
}

/// @nodoc
class __$$OcrResultImplCopyWithImpl<$Res>
    extends _$OcrResultCopyWithImpl<$Res, _$OcrResultImpl>
    implements _$$OcrResultImplCopyWith<$Res> {
  __$$OcrResultImplCopyWithImpl(
      _$OcrResultImpl _value, $Res Function(_$OcrResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of OcrResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? rawText = null,
    Object? scannedAt = null,
  }) {
    return _then(_$OcrResultImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ScannedItem>,
      rawText: null == rawText
          ? _value.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String,
      scannedAt: null == scannedAt
          ? _value.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OcrResultImpl extends _OcrResult {
  const _$OcrResultImpl(
      {required final List<ScannedItem> items,
      required this.rawText,
      required this.scannedAt})
      : _items = items,
        super._();

  factory _$OcrResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$OcrResultImplFromJson(json);

  final List<ScannedItem> _items;
  @override
  List<ScannedItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String rawText;
  @override
  final DateTime scannedAt;

  @override
  String toString() {
    return 'OcrResult(items: $items, rawText: $rawText, scannedAt: $scannedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OcrResultImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.rawText, rawText) || other.rawText == rawText) &&
            (identical(other.scannedAt, scannedAt) ||
                other.scannedAt == scannedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), rawText, scannedAt);

  /// Create a copy of OcrResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OcrResultImplCopyWith<_$OcrResultImpl> get copyWith =>
      __$$OcrResultImplCopyWithImpl<_$OcrResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OcrResultImplToJson(
      this,
    );
  }
}

abstract class _OcrResult extends OcrResult {
  const factory _OcrResult(
      {required final List<ScannedItem> items,
      required final String rawText,
      required final DateTime scannedAt}) = _$OcrResultImpl;
  const _OcrResult._() : super._();

  factory _OcrResult.fromJson(Map<String, dynamic> json) =
      _$OcrResultImpl.fromJson;

  @override
  List<ScannedItem> get items;
  @override
  String get rawText;
  @override
  DateTime get scannedAt;

  /// Create a copy of OcrResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OcrResultImplCopyWith<_$OcrResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
