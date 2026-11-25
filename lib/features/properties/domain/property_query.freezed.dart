// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PropertyQuery {
  /// Create a copy of PropertyQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PropertyQueryCopyWith<PropertyQuery> get copyWith =>
      _$PropertyQueryCopyWithImpl<PropertyQuery>(
        this as PropertyQuery,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PropertyQuery;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PropertyQuery &&
            (identical(other.search, _this.search) ||
                other.search == _this.search) &&
            const DeepCollectionEquality().equals(other.types, _this.types) &&
            (identical(other.minPrice, _this.minPrice) ||
                other.minPrice == _this.minPrice) &&
            (identical(other.maxPrice, _this.maxPrice) ||
                other.maxPrice == _this.maxPrice) &&
            (identical(other.minBedrooms, _this.minBedrooms) ||
                other.minBedrooms == _this.minBedrooms) &&
            (identical(other.minBathrooms, _this.minBathrooms) ||
                other.minBathrooms == _this.minBathrooms) &&
            (identical(other.minArea, _this.minArea) ||
                other.minArea == _this.minArea) &&
            (identical(other.maxArea, _this.maxArea) ||
                other.maxArea == _this.maxArea) &&
            (identical(other.featured, _this.featured) ||
                other.featured == _this.featured) &&
            (identical(other.sortBy, _this.sortBy) ||
                other.sortBy == _this.sortBy) &&
            (identical(other.sortOrder, _this.sortOrder) ||
                other.sortOrder == _this.sortOrder) &&
            (identical(other.page, _this.page) || other.page == _this.page) &&
            (identical(other.limit, _this.limit) ||
                other.limit == _this.limit));
  }

  @override
  int get hashCode {
    final _this = this as PropertyQuery;
    return Object.hash(
      runtimeType,
      _this.search,
      const DeepCollectionEquality().hash(_this.types),
      _this.minPrice,
      _this.maxPrice,
      _this.minBedrooms,
      _this.minBathrooms,
      _this.minArea,
      _this.maxArea,
      _this.featured,
      _this.sortBy,
      _this.sortOrder,
      _this.page,
      _this.limit,
    );
  }

  @override
  String toString() {
    final _this = this as PropertyQuery;
    return 'PropertyQuery(search: ${_this.search}, types: ${_this.types}, minPrice: ${_this.minPrice}, maxPrice: ${_this.maxPrice}, minBedrooms: ${_this.minBedrooms}, minBathrooms: ${_this.minBathrooms}, minArea: ${_this.minArea}, maxArea: ${_this.maxArea}, featured: ${_this.featured}, sortBy: ${_this.sortBy}, sortOrder: ${_this.sortOrder}, page: ${_this.page}, limit: ${_this.limit})';
  }
}

/// @nodoc
abstract mixin class $PropertyQueryCopyWith<$Res> {
  factory $PropertyQueryCopyWith(
    PropertyQuery value,
    $Res Function(PropertyQuery) _then,
  ) = _$PropertyQueryCopyWithImpl;
  @useResult
  $Res call({
    String? search,
    Set<PropertyType> types,
    double? minPrice,
    double? maxPrice,
    int? minBedrooms,
    int? minBathrooms,
    double? minArea,
    double? maxArea,
    bool? featured,
    PropertySortBy sortBy,
    SortOrder sortOrder,
    int page,
    int limit,
  });
}

/// @nodoc
class _$PropertyQueryCopyWithImpl<$Res>
    implements $PropertyQueryCopyWith<$Res> {
  _$PropertyQueryCopyWithImpl(this._self, this._then);

  final PropertyQuery _self;
  final $Res Function(PropertyQuery) _then;

  /// Create a copy of PropertyQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? types = null,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? minBedrooms = freezed,
    Object? minBathrooms = freezed,
    Object? minArea = freezed,
    Object? maxArea = freezed,
    Object? featured = freezed,
    Object? sortBy = null,
    Object? sortOrder = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(
      PropertyQuery(
        search: freezed == search
            ? _self.search
            : search // ignore: cast_nullable_to_non_nullable
                  as String?,
        types: null == types
            ? _self.types
            : types // ignore: cast_nullable_to_non_nullable
                  as Set<PropertyType>,
        minPrice: freezed == minPrice
            ? _self.minPrice
            : minPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxPrice: freezed == maxPrice
            ? _self.maxPrice
            : maxPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        minBedrooms: freezed == minBedrooms
            ? _self.minBedrooms
            : minBedrooms // ignore: cast_nullable_to_non_nullable
                  as int?,
        minBathrooms: freezed == minBathrooms
            ? _self.minBathrooms
            : minBathrooms // ignore: cast_nullable_to_non_nullable
                  as int?,
        minArea: freezed == minArea
            ? _self.minArea
            : minArea // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxArea: freezed == maxArea
            ? _self.maxArea
            : maxArea // ignore: cast_nullable_to_non_nullable
                  as double?,
        featured: freezed == featured
            ? _self.featured
            : featured // ignore: cast_nullable_to_non_nullable
                  as bool?,
        sortBy: null == sortBy
            ? _self.sortBy
            : sortBy // ignore: cast_nullable_to_non_nullable
                  as PropertySortBy,
        sortOrder: null == sortOrder
            ? _self.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as SortOrder,
        page: null == page
            ? _self.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [PropertyQuery].
extension PropertyQueryPatterns on PropertyQuery {
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
  TResult maybeMap<TResult extends Object?>({required TResult orElse()}) {
    final _that = this;
    switch (_that) {
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
  TResult map<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
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
  TResult? mapOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
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
  TResult maybeWhen<TResult extends Object?>({required TResult orElse()}) {
    final _that = this;
    switch (_that) {
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
  TResult when<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
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
  TResult? whenOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }
}
