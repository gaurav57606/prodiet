// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_plan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DietPlanState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DietPlanState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DietPlanState()';
  }
}

/// @nodoc
class $DietPlanStateCopyWith<$Res> {
  $DietPlanStateCopyWith(DietPlanState _, $Res Function(DietPlanState) __);
}

/// Adds pattern-matching-related methods to [DietPlanState].
extension DietPlanStatePatterns on DietPlanState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DietPlanInitial value)? initial,
    TResult Function(DietPlanLoading value)? loading,
    TResult Function(DietPlanLoaded value)? loaded,
    TResult Function(DietPlanError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DietPlanInitial() when initial != null:
        return initial(_that);
      case DietPlanLoading() when loading != null:
        return loading(_that);
      case DietPlanLoaded() when loaded != null:
        return loaded(_that);
      case DietPlanError() when error != null:
        return error(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(DietPlanInitial value) initial,
    required TResult Function(DietPlanLoading value) loading,
    required TResult Function(DietPlanLoaded value) loaded,
    required TResult Function(DietPlanError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case DietPlanInitial():
        return initial(_that);
      case DietPlanLoading():
        return loading(_that);
      case DietPlanLoaded():
        return loaded(_that);
      case DietPlanError():
        return error(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DietPlanInitial value)? initial,
    TResult? Function(DietPlanLoading value)? loading,
    TResult? Function(DietPlanLoaded value)? loaded,
    TResult? Function(DietPlanError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case DietPlanInitial() when initial != null:
        return initial(_that);
      case DietPlanLoading() when loading != null:
        return loading(_that);
      case DietPlanLoaded() when loaded != null:
        return loaded(_that);
      case DietPlanError() when error != null:
        return error(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(DietPlan plan)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DietPlanInitial() when initial != null:
        return initial();
      case DietPlanLoading() when loading != null:
        return loading();
      case DietPlanLoaded() when loaded != null:
        return loaded(_that.plan);
      case DietPlanError() when error != null:
        return error(_that.message);
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
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(DietPlan plan) loaded,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case DietPlanInitial():
        return initial();
      case DietPlanLoading():
        return loading();
      case DietPlanLoaded():
        return loaded(_that.plan);
      case DietPlanError():
        return error(_that.message);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(DietPlan plan)? loaded,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case DietPlanInitial() when initial != null:
        return initial();
      case DietPlanLoading() when loading != null:
        return loading();
      case DietPlanLoaded() when loaded != null:
        return loaded(_that.plan);
      case DietPlanError() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class DietPlanInitial implements DietPlanState {
  const DietPlanInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DietPlanInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DietPlanState.initial()';
  }
}

/// @nodoc

class DietPlanLoading implements DietPlanState {
  const DietPlanLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DietPlanLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DietPlanState.loading()';
  }
}

/// @nodoc

class DietPlanLoaded implements DietPlanState {
  const DietPlanLoaded(this.plan);

  final DietPlan plan;

  /// Create a copy of DietPlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DietPlanLoadedCopyWith<DietPlanLoaded> get copyWith =>
      _$DietPlanLoadedCopyWithImpl<DietPlanLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DietPlanLoaded &&
            (identical(other.plan, plan) || other.plan == plan));
  }

  @override
  int get hashCode => Object.hash(runtimeType, plan);

  @override
  String toString() {
    return 'DietPlanState.loaded(plan: $plan)';
  }
}

/// @nodoc
abstract mixin class $DietPlanLoadedCopyWith<$Res>
    implements $DietPlanStateCopyWith<$Res> {
  factory $DietPlanLoadedCopyWith(
          DietPlanLoaded value, $Res Function(DietPlanLoaded) _then) =
      _$DietPlanLoadedCopyWithImpl;
  @useResult
  $Res call({DietPlan plan});

  $DietPlanCopyWith<$Res> get plan;
}

/// @nodoc
class _$DietPlanLoadedCopyWithImpl<$Res>
    implements $DietPlanLoadedCopyWith<$Res> {
  _$DietPlanLoadedCopyWithImpl(this._self, this._then);

  final DietPlanLoaded _self;
  final $Res Function(DietPlanLoaded) _then;

  /// Create a copy of DietPlanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? plan = null,
  }) {
    return _then(DietPlanLoaded(
      null == plan
          ? _self.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as DietPlan,
    ));
  }

  /// Create a copy of DietPlanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DietPlanCopyWith<$Res> get plan {
    return $DietPlanCopyWith<$Res>(_self.plan, (value) {
      return _then(_self.copyWith(plan: value));
    });
  }
}

/// @nodoc

class DietPlanError implements DietPlanState {
  const DietPlanError(this.message);

  final String message;

  /// Create a copy of DietPlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DietPlanErrorCopyWith<DietPlanError> get copyWith =>
      _$DietPlanErrorCopyWithImpl<DietPlanError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DietPlanError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'DietPlanState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $DietPlanErrorCopyWith<$Res>
    implements $DietPlanStateCopyWith<$Res> {
  factory $DietPlanErrorCopyWith(
          DietPlanError value, $Res Function(DietPlanError) _then) =
      _$DietPlanErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$DietPlanErrorCopyWithImpl<$Res>
    implements $DietPlanErrorCopyWith<$Res> {
  _$DietPlanErrorCopyWithImpl(this._self, this._then);

  final DietPlanError _self;
  final $Res Function(DietPlanError) _then;

  /// Create a copy of DietPlanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(DietPlanError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
