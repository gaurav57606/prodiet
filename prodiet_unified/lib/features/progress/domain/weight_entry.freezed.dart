// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeightEntry _$WeightEntryFromJson(Map<String, dynamic> json) {
  return _WeightEntry.fromJson(json);
}

/// @nodoc
mixin _$WeightEntry {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get weightKg => throw _privateConstructorUsedError;
  DateTime get loggedAt => throw _privateConstructorUsedError;

  /// Serializes this WeightEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeightEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeightEntryCopyWith<WeightEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightEntryCopyWith<$Res> {
  factory $WeightEntryCopyWith(
          WeightEntry value, $Res Function(WeightEntry) then) =
      _$WeightEntryCopyWithImpl<$Res, WeightEntry>;
  @useResult
  $Res call({String id, String userId, double weightKg, DateTime loggedAt});
}

/// @nodoc
class _$WeightEntryCopyWithImpl<$Res, $Val extends WeightEntry>
    implements $WeightEntryCopyWith<$Res> {
  _$WeightEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeightEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? weightKg = null,
    Object? loggedAt = null,
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
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      loggedAt: null == loggedAt
          ? _value.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeightEntryImplCopyWith<$Res>
    implements $WeightEntryCopyWith<$Res> {
  factory _$$WeightEntryImplCopyWith(
          _$WeightEntryImpl value, $Res Function(_$WeightEntryImpl) then) =
      __$$WeightEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String userId, double weightKg, DateTime loggedAt});
}

/// @nodoc
class __$$WeightEntryImplCopyWithImpl<$Res>
    extends _$WeightEntryCopyWithImpl<$Res, _$WeightEntryImpl>
    implements _$$WeightEntryImplCopyWith<$Res> {
  __$$WeightEntryImplCopyWithImpl(
      _$WeightEntryImpl _value, $Res Function(_$WeightEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeightEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? weightKg = null,
    Object? loggedAt = null,
  }) {
    return _then(_$WeightEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      loggedAt: null == loggedAt
          ? _value.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeightEntryImpl implements _WeightEntry {
  const _$WeightEntryImpl(
      {required this.id,
      required this.userId,
      required this.weightKg,
      required this.loggedAt});

  factory _$WeightEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final double weightKg;
  @override
  final DateTime loggedAt;

  @override
  String toString() {
    return 'WeightEntry(id: $id, userId: $userId, weightKg: $weightKg, loggedAt: $loggedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, weightKg, loggedAt);

  /// Create a copy of WeightEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightEntryImplCopyWith<_$WeightEntryImpl> get copyWith =>
      __$$WeightEntryImplCopyWithImpl<_$WeightEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightEntryImplToJson(
      this,
    );
  }
}

abstract class _WeightEntry implements WeightEntry {
  const factory _WeightEntry(
      {required final String id,
      required final String userId,
      required final double weightKg,
      required final DateTime loggedAt}) = _$WeightEntryImpl;

  factory _WeightEntry.fromJson(Map<String, dynamic> json) =
      _$WeightEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  double get weightKg;
  @override
  DateTime get loggedAt;

  /// Create a copy of WeightEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeightEntryImplCopyWith<_$WeightEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
