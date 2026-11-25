// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthenticatedUser {
  String get id;
  String? get email;
  String? get name;
  String? get avatar;

  /// Create a copy of AuthenticatedUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthenticatedUserCopyWith<AuthenticatedUser> get copyWith =>
      _$AuthenticatedUserCopyWithImpl<AuthenticatedUser>(
        this as AuthenticatedUser,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as AuthenticatedUser;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthenticatedUser &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.email, _this.email) ||
                other.email == _this.email) &&
            (identical(other.name, _this.name) || other.name == _this.name) &&
            (identical(other.avatar, _this.avatar) ||
                other.avatar == _this.avatar));
  }

  @override
  int get hashCode {
    final _this = this as AuthenticatedUser;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.email,
      _this.name,
      _this.avatar,
    );
  }

  @override
  String toString() {
    final _this = this as AuthenticatedUser;
    return 'AuthenticatedUser(id: ${_this.id}, email: ${_this.email}, name: ${_this.name}, avatar: ${_this.avatar})';
  }
}

/// @nodoc
abstract mixin class $AuthenticatedUserCopyWith<$Res> {
  factory $AuthenticatedUserCopyWith(
    AuthenticatedUser value,
    $Res Function(AuthenticatedUser) _then,
  ) = _$AuthenticatedUserCopyWithImpl;
  @useResult
  $Res call({String id, String? email, String? name, String? avatar});
}

/// @nodoc
class _$AuthenticatedUserCopyWithImpl<$Res>
    implements $AuthenticatedUserCopyWith<$Res> {
  _$AuthenticatedUserCopyWithImpl(this._self, this._then);

  final AuthenticatedUser _self;
  final $Res Function(AuthenticatedUser) _then;

  /// Create a copy of AuthenticatedUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? name = freezed,
    Object? avatar = freezed,
  }) {
    return _then(
      AuthenticatedUser(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _self.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatar: freezed == avatar
            ? _self.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AuthenticatedUser].
extension AuthenticatedUserPatterns on AuthenticatedUser {
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
    TResult Function(_AuthenticatedUser value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthenticatedUser() when $default != null:
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
    TResult Function(_AuthenticatedUser value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthenticatedUser():
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
    TResult? Function(_AuthenticatedUser value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthenticatedUser() when $default != null:
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
    TResult Function(String id, String? email, String? name, String? avatar)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthenticatedUser() when $default != null:
        return $default(_that.id, _that.email, _that.name, _that.avatar);
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
    TResult Function(String id, String? email, String? name, String? avatar)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthenticatedUser():
        return $default(_that.id, _that.email, _that.name, _that.avatar);
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
    TResult? Function(String id, String? email, String? name, String? avatar)?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthenticatedUser() when $default != null:
        return $default(_that.id, _that.email, _that.name, _that.avatar);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AuthenticatedUser implements AuthenticatedUser {
  const _AuthenticatedUser({
    required this.id,
    this.email,
    this.name,
    this.avatar,
  });

  @override
  final String id;
  @override
  final String? email;
  @override
  final String? name;
  @override
  final String? avatar;

  /// Create a copy of AuthenticatedUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthenticatedUserCopyWith<_AuthenticatedUser> get copyWith =>
      __$AuthenticatedUserCopyWithImpl<_AuthenticatedUser>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthenticatedUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, email, name, avatar);
  }

  @override
  String toString() {
    return 'AuthenticatedUser(id: $id, email: $email, name: $name, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class _$AuthenticatedUserCopyWith<$Res>
    implements $AuthenticatedUserCopyWith<$Res> {
  factory _$AuthenticatedUserCopyWith(
    _AuthenticatedUser value,
    $Res Function(_AuthenticatedUser) _then,
  ) = __$AuthenticatedUserCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String? email, String? name, String? avatar});
}

/// @nodoc
class __$AuthenticatedUserCopyWithImpl<$Res>
    implements _$AuthenticatedUserCopyWith<$Res> {
  __$AuthenticatedUserCopyWithImpl(this._self, this._then);

  final _AuthenticatedUser _self;
  final $Res Function(_AuthenticatedUser) _then;

  /// Create a copy of AuthenticatedUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? name = freezed,
    Object? avatar = freezed,
  }) {
    return _then(
      _AuthenticatedUser(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _self.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatar: freezed == avatar
            ? _self.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
