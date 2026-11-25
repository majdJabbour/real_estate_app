// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explore_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExploreState {
  PropertyQuery get query;
  AppLanguage get language;
  List<PropertySummary> get items;
  Pagination? get pagination;
  ExploreLoad? get loading;
  ({Object error, ExploreLoad operation})? get failure;
  bool get pagingStalled;

  /// Create a copy of ExploreState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExploreStateCopyWith<ExploreState> get copyWith =>
      _$ExploreStateCopyWithImpl<ExploreState>(
        this as ExploreState,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as ExploreState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExploreState &&
            (identical(other.query, _this.query) ||
                other.query == _this.query) &&
            (identical(other.language, _this.language) ||
                other.language == _this.language) &&
            const DeepCollectionEquality().equals(other.items, _this.items) &&
            (identical(other.pagination, _this.pagination) ||
                other.pagination == _this.pagination) &&
            (identical(other.loading, _this.loading) ||
                other.loading == _this.loading) &&
            (identical(other.failure, _this.failure) ||
                other.failure == _this.failure) &&
            (identical(other.pagingStalled, _this.pagingStalled) ||
                other.pagingStalled == _this.pagingStalled));
  }

  @override
  int get hashCode {
    final _this = this as ExploreState;
    return Object.hash(
      runtimeType,
      _this.query,
      _this.language,
      const DeepCollectionEquality().hash(_this.items),
      _this.pagination,
      _this.loading,
      _this.failure,
      _this.pagingStalled,
    );
  }

  @override
  String toString() {
    final _this = this as ExploreState;
    return 'ExploreState(query: ${_this.query}, language: ${_this.language}, items: ${_this.items}, pagination: ${_this.pagination}, loading: ${_this.loading}, failure: ${_this.failure}, pagingStalled: ${_this.pagingStalled})';
  }
}

/// @nodoc
abstract mixin class $ExploreStateCopyWith<$Res> {
  factory $ExploreStateCopyWith(
    ExploreState value,
    $Res Function(ExploreState) _then,
  ) = _$ExploreStateCopyWithImpl;
  @useResult
  $Res call({
    PropertyQuery query,
    AppLanguage language,
    List<PropertySummary> items,
    Pagination? pagination,
    ExploreLoad? loading,
    ({Object error, ExploreLoad operation})? failure,
    bool pagingStalled,
  });

  $PropertyQueryCopyWith<$Res> get query;
}

/// @nodoc
class _$ExploreStateCopyWithImpl<$Res> implements $ExploreStateCopyWith<$Res> {
  _$ExploreStateCopyWithImpl(this._self, this._then);

  final ExploreState _self;
  final $Res Function(ExploreState) _then;

  /// Create a copy of ExploreState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? language = null,
    Object? items = null,
    Object? pagination = freezed,
    Object? loading = freezed,
    Object? failure = freezed,
    Object? pagingStalled = null,
  }) {
    return _then(
      ExploreState(
        query: null == query
            ? _self.query
            : query // ignore: cast_nullable_to_non_nullable
                  as PropertyQuery,
        language: null == language
            ? _self.language
            : language // ignore: cast_nullable_to_non_nullable
                  as AppLanguage,
        items: null == items
            ? _self.items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<PropertySummary>,
        pagination: freezed == pagination
            ? _self.pagination
            : pagination // ignore: cast_nullable_to_non_nullable
                  as Pagination?,
        loading: freezed == loading
            ? _self.loading
            : loading // ignore: cast_nullable_to_non_nullable
                  as ExploreLoad?,
        failure: freezed == failure
            ? _self.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as ({Object error, ExploreLoad operation})?,
        pagingStalled: null == pagingStalled
            ? _self.pagingStalled
            : pagingStalled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }

  /// Create a copy of ExploreState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertyQueryCopyWith<$Res> get query {
    return $PropertyQueryCopyWith<$Res>(_self.query, (value) {
      return _then(_self.copyWith(query: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ExploreState].
extension ExploreStatePatterns on ExploreState {
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
    TResult Function(_ExploreState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExploreState() when $default != null:
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
    TResult Function(_ExploreState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExploreState():
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
    TResult? Function(_ExploreState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExploreState() when $default != null:
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
      PropertyQuery query,
      AppLanguage language,
      List<PropertySummary> items,
      Pagination? pagination,
      ExploreLoad? loading,
      ({Object error, ExploreLoad operation})? failure,
      bool pagingStalled,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExploreState() when $default != null:
        return $default(
          _that.query,
          _that.language,
          _that.items,
          _that.pagination,
          _that.loading,
          _that.failure,
          _that.pagingStalled,
        );
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
      PropertyQuery query,
      AppLanguage language,
      List<PropertySummary> items,
      Pagination? pagination,
      ExploreLoad? loading,
      ({Object error, ExploreLoad operation})? failure,
      bool pagingStalled,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExploreState():
        return $default(
          _that.query,
          _that.language,
          _that.items,
          _that.pagination,
          _that.loading,
          _that.failure,
          _that.pagingStalled,
        );
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
      PropertyQuery query,
      AppLanguage language,
      List<PropertySummary> items,
      Pagination? pagination,
      ExploreLoad? loading,
      ({Object error, ExploreLoad operation})? failure,
      bool pagingStalled,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExploreState() when $default != null:
        return $default(
          _that.query,
          _that.language,
          _that.items,
          _that.pagination,
          _that.loading,
          _that.failure,
          _that.pagingStalled,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ExploreState extends ExploreState {
  const _ExploreState({
    required this.query,
    required this.language,
    List<PropertySummary> items = const [],
    this.pagination,
    this.loading = ExploreLoad.initial,
    this.failure,
    this.pagingStalled = false,
  }) : _items = items,
       super._();

  @override
  final PropertyQuery query;
  @override
  final AppLanguage language;
  final List<PropertySummary> _items;
  @override
  @JsonKey()
  List<PropertySummary> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final Pagination? pagination;
  @override
  @JsonKey()
  final ExploreLoad? loading;
  @override
  final ({Object error, ExploreLoad operation})? failure;
  @override
  @JsonKey()
  final bool pagingStalled;

  /// Create a copy of ExploreState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExploreStateCopyWith<_ExploreState> get copyWith =>
      __$ExploreStateCopyWithImpl<_ExploreState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExploreState &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality().equals(other.items, _items) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.pagingStalled, pagingStalled) ||
                other.pagingStalled == pagingStalled));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      query,
      language,
      const DeepCollectionEquality().hash(_items),
      pagination,
      loading,
      failure,
      pagingStalled,
    );
  }

  @override
  String toString() {
    return 'ExploreState(query: $query, language: $language, items: $items, pagination: $pagination, loading: $loading, failure: $failure, pagingStalled: $pagingStalled)';
  }
}

/// @nodoc
abstract mixin class _$ExploreStateCopyWith<$Res>
    implements $ExploreStateCopyWith<$Res> {
  factory _$ExploreStateCopyWith(
    _ExploreState value,
    $Res Function(_ExploreState) _then,
  ) = __$ExploreStateCopyWithImpl;
  @override
  @useResult
  $Res call({
    PropertyQuery query,
    AppLanguage language,
    List<PropertySummary> items,
    Pagination? pagination,
    ExploreLoad? loading,
    ({Object error, ExploreLoad operation})? failure,
    bool pagingStalled,
  });

  @override
  $PropertyQueryCopyWith<$Res> get query;
}

/// @nodoc
class __$ExploreStateCopyWithImpl<$Res>
    implements _$ExploreStateCopyWith<$Res> {
  __$ExploreStateCopyWithImpl(this._self, this._then);

  final _ExploreState _self;
  final $Res Function(_ExploreState) _then;

  /// Create a copy of ExploreState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? query = null,
    Object? language = null,
    Object? items = null,
    Object? pagination = freezed,
    Object? loading = freezed,
    Object? failure = freezed,
    Object? pagingStalled = null,
  }) {
    return _then(
      _ExploreState(
        query: null == query
            ? _self.query
            : query // ignore: cast_nullable_to_non_nullable
                  as PropertyQuery,
        language: null == language
            ? _self.language
            : language // ignore: cast_nullable_to_non_nullable
                  as AppLanguage,
        items: null == items
            ? _self._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<PropertySummary>,
        pagination: freezed == pagination
            ? _self.pagination
            : pagination // ignore: cast_nullable_to_non_nullable
                  as Pagination?,
        loading: freezed == loading
            ? _self.loading
            : loading // ignore: cast_nullable_to_non_nullable
                  as ExploreLoad?,
        failure: freezed == failure
            ? _self.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as ({Object error, ExploreLoad operation})?,
        pagingStalled: null == pagingStalled
            ? _self.pagingStalled
            : pagingStalled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }

  /// Create a copy of ExploreState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertyQueryCopyWith<$Res> get query {
    return $PropertyQueryCopyWith<$Res>(_self.query, (value) {
      return _then(_self.copyWith(query: value));
    });
  }
}
