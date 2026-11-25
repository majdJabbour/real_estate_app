// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_filter_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PropertyFilterOptions {
  /// Create a copy of PropertyFilterOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PropertyFilterOptionsCopyWith<PropertyFilterOptions> get copyWith =>
      _$PropertyFilterOptionsCopyWithImpl<PropertyFilterOptions>(
        this as PropertyFilterOptions,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PropertyFilterOptions;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PropertyFilterOptions &&
            (identical(other.price, _this.price) ||
                other.price == _this.price) &&
            (identical(other.area, _this.area) || other.area == _this.area) &&
            (identical(other.areaUnit, _this.areaUnit) ||
                other.areaUnit == _this.areaUnit) &&
            (identical(other.bedrooms, _this.bedrooms) ||
                other.bedrooms == _this.bedrooms) &&
            (identical(other.bathrooms, _this.bathrooms) ||
                other.bathrooms == _this.bathrooms) &&
            const DeepCollectionEquality().equals(other.types, _this.types));
  }

  @override
  int get hashCode {
    final _this = this as PropertyFilterOptions;
    return Object.hash(
      runtimeType,
      _this.price,
      _this.area,
      _this.areaUnit,
      _this.bedrooms,
      _this.bathrooms,
      const DeepCollectionEquality().hash(_this.types),
    );
  }

  @override
  String toString() {
    final _this = this as PropertyFilterOptions;
    return 'PropertyFilterOptions(price: ${_this.price}, area: ${_this.area}, areaUnit: ${_this.areaUnit}, bedrooms: ${_this.bedrooms}, bathrooms: ${_this.bathrooms}, types: ${_this.types})';
  }
}

/// @nodoc
abstract mixin class $PropertyFilterOptionsCopyWith<$Res> {
  factory $PropertyFilterOptionsCopyWith(
    PropertyFilterOptions value,
    $Res Function(PropertyFilterOptions) _then,
  ) = _$PropertyFilterOptionsCopyWithImpl;
  @useResult
  $Res call({
    PropertyPriceOptions price,
    PropertyBounds<double> area,
    String areaUnit,
    PropertyBounds<int> bedrooms,
    PropertyBounds<int> bathrooms,
    List<PropertyTypeOption> types,
  });

  $PropertyPriceOptionsCopyWith<$Res> get price;
}

/// @nodoc
class _$PropertyFilterOptionsCopyWithImpl<$Res>
    implements $PropertyFilterOptionsCopyWith<$Res> {
  _$PropertyFilterOptionsCopyWithImpl(this._self, this._then);

  final PropertyFilterOptions _self;
  final $Res Function(PropertyFilterOptions) _then;

  /// Create a copy of PropertyFilterOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = null,
    Object? area = null,
    Object? areaUnit = null,
    Object? bedrooms = null,
    Object? bathrooms = null,
    Object? types = null,
  }) {
    return _then(
      PropertyFilterOptions(
        price: null == price
            ? _self.price
            : price // ignore: cast_nullable_to_non_nullable
                  as PropertyPriceOptions,
        area: null == area
            ? _self.area
            : area // ignore: cast_nullable_to_non_nullable
                  as PropertyBounds<double>,
        areaUnit: null == areaUnit
            ? _self.areaUnit
            : areaUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        bedrooms: null == bedrooms
            ? _self.bedrooms
            : bedrooms // ignore: cast_nullable_to_non_nullable
                  as PropertyBounds<int>,
        bathrooms: null == bathrooms
            ? _self.bathrooms
            : bathrooms // ignore: cast_nullable_to_non_nullable
                  as PropertyBounds<int>,
        types: null == types
            ? _self.types
            : types // ignore: cast_nullable_to_non_nullable
                  as List<PropertyTypeOption>,
      ),
    );
  }

  /// Create a copy of PropertyFilterOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertyPriceOptionsCopyWith<$Res> get price {
    return $PropertyPriceOptionsCopyWith<$Res>(_self.price, (value) {
      return _then(_self.copyWith(price: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PropertyFilterOptions].
extension PropertyFilterOptionsPatterns on PropertyFilterOptions {
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

/// @nodoc
mixin _$PropertyPriceOptions {
  /// Create a copy of PropertyPriceOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PropertyPriceOptionsCopyWith<PropertyPriceOptions> get copyWith =>
      _$PropertyPriceOptionsCopyWithImpl<PropertyPriceOptions>(
        this as PropertyPriceOptions,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PropertyPriceOptions;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PropertyPriceOptions &&
            (identical(other.bounds, _this.bounds) ||
                other.bounds == _this.bounds) &&
            (identical(other.currency, _this.currency) ||
                other.currency == _this.currency) &&
            (identical(other.pricingPeriod, _this.pricingPeriod) ||
                other.pricingPeriod == _this.pricingPeriod) &&
            const DeepCollectionEquality().equals(
              other.histogram,
              _this.histogram,
            ));
  }

  @override
  int get hashCode {
    final _this = this as PropertyPriceOptions;
    return Object.hash(
      runtimeType,
      _this.bounds,
      _this.currency,
      _this.pricingPeriod,
      const DeepCollectionEquality().hash(_this.histogram),
    );
  }

  @override
  String toString() {
    final _this = this as PropertyPriceOptions;
    return 'PropertyPriceOptions(bounds: ${_this.bounds}, currency: ${_this.currency}, pricingPeriod: ${_this.pricingPeriod}, histogram: ${_this.histogram})';
  }
}

/// @nodoc
abstract mixin class $PropertyPriceOptionsCopyWith<$Res> {
  factory $PropertyPriceOptionsCopyWith(
    PropertyPriceOptions value,
    $Res Function(PropertyPriceOptions) _then,
  ) = _$PropertyPriceOptionsCopyWithImpl;
  @useResult
  $Res call({
    PropertyBounds<double> bounds,
    String currency,
    String pricingPeriod,
    List<PriceHistogramBucket> histogram,
  });
}

/// @nodoc
class _$PropertyPriceOptionsCopyWithImpl<$Res>
    implements $PropertyPriceOptionsCopyWith<$Res> {
  _$PropertyPriceOptionsCopyWithImpl(this._self, this._then);

  final PropertyPriceOptions _self;
  final $Res Function(PropertyPriceOptions) _then;

  /// Create a copy of PropertyPriceOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bounds = null,
    Object? currency = null,
    Object? pricingPeriod = null,
    Object? histogram = null,
  }) {
    return _then(
      PropertyPriceOptions(
        bounds: null == bounds
            ? _self.bounds
            : bounds // ignore: cast_nullable_to_non_nullable
                  as PropertyBounds<double>,
        currency: null == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        pricingPeriod: null == pricingPeriod
            ? _self.pricingPeriod
            : pricingPeriod // ignore: cast_nullable_to_non_nullable
                  as String,
        histogram: null == histogram
            ? _self.histogram
            : histogram // ignore: cast_nullable_to_non_nullable
                  as List<PriceHistogramBucket>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [PropertyPriceOptions].
extension PropertyPriceOptionsPatterns on PropertyPriceOptions {
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

/// @nodoc
mixin _$PriceHistogramBucket {
  double get from;
  double get to;
  int get count;

  /// Create a copy of PriceHistogramBucket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PriceHistogramBucketCopyWith<PriceHistogramBucket> get copyWith =>
      _$PriceHistogramBucketCopyWithImpl<PriceHistogramBucket>(
        this as PriceHistogramBucket,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PriceHistogramBucket;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PriceHistogramBucket &&
            (identical(other.from, _this.from) || other.from == _this.from) &&
            (identical(other.to, _this.to) || other.to == _this.to) &&
            (identical(other.count, _this.count) ||
                other.count == _this.count));
  }

  @override
  int get hashCode {
    final _this = this as PriceHistogramBucket;
    return Object.hash(runtimeType, _this.from, _this.to, _this.count);
  }

  @override
  String toString() {
    final _this = this as PriceHistogramBucket;
    return 'PriceHistogramBucket(from: ${_this.from}, to: ${_this.to}, count: ${_this.count})';
  }
}

/// @nodoc
abstract mixin class $PriceHistogramBucketCopyWith<$Res> {
  factory $PriceHistogramBucketCopyWith(
    PriceHistogramBucket value,
    $Res Function(PriceHistogramBucket) _then,
  ) = _$PriceHistogramBucketCopyWithImpl;
  @useResult
  $Res call({double from, double to, int count});
}

/// @nodoc
class _$PriceHistogramBucketCopyWithImpl<$Res>
    implements $PriceHistogramBucketCopyWith<$Res> {
  _$PriceHistogramBucketCopyWithImpl(this._self, this._then);

  final PriceHistogramBucket _self;
  final $Res Function(PriceHistogramBucket) _then;

  /// Create a copy of PriceHistogramBucket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? from = null, Object? to = null, Object? count = null}) {
    return _then(
      PriceHistogramBucket(
        from: null == from
            ? _self.from
            : from // ignore: cast_nullable_to_non_nullable
                  as double,
        to: null == to
            ? _self.to
            : to // ignore: cast_nullable_to_non_nullable
                  as double,
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [PriceHistogramBucket].
extension PriceHistogramBucketPatterns on PriceHistogramBucket {
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
    TResult Function(_PriceHistogramBucket value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PriceHistogramBucket() when $default != null:
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
    TResult Function(_PriceHistogramBucket value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PriceHistogramBucket():
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
    TResult? Function(_PriceHistogramBucket value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PriceHistogramBucket() when $default != null:
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
    TResult Function(double from, double to, int count)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PriceHistogramBucket() when $default != null:
        return $default(_that.from, _that.to, _that.count);
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
    TResult Function(double from, double to, int count) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PriceHistogramBucket():
        return $default(_that.from, _that.to, _that.count);
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
    TResult? Function(double from, double to, int count)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PriceHistogramBucket() when $default != null:
        return $default(_that.from, _that.to, _that.count);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PriceHistogramBucket implements PriceHistogramBucket {
  const _PriceHistogramBucket({
    required this.from,
    required this.to,
    required this.count,
  });

  @override
  final double from;
  @override
  final double to;
  @override
  final int count;

  /// Create a copy of PriceHistogramBucket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PriceHistogramBucketCopyWith<_PriceHistogramBucket> get copyWith =>
      __$PriceHistogramBucketCopyWithImpl<_PriceHistogramBucket>(
        this,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PriceHistogramBucket &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, from, to, count);
  }

  @override
  String toString() {
    return 'PriceHistogramBucket(from: $from, to: $to, count: $count)';
  }
}

/// @nodoc
abstract mixin class _$PriceHistogramBucketCopyWith<$Res>
    implements $PriceHistogramBucketCopyWith<$Res> {
  factory _$PriceHistogramBucketCopyWith(
    _PriceHistogramBucket value,
    $Res Function(_PriceHistogramBucket) _then,
  ) = __$PriceHistogramBucketCopyWithImpl;
  @override
  @useResult
  $Res call({double from, double to, int count});
}

/// @nodoc
class __$PriceHistogramBucketCopyWithImpl<$Res>
    implements _$PriceHistogramBucketCopyWith<$Res> {
  __$PriceHistogramBucketCopyWithImpl(this._self, this._then);

  final _PriceHistogramBucket _self;
  final $Res Function(_PriceHistogramBucket) _then;

  /// Create a copy of PriceHistogramBucket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? from = null, Object? to = null, Object? count = null}) {
    return _then(
      _PriceHistogramBucket(
        from: null == from
            ? _self.from
            : from // ignore: cast_nullable_to_non_nullable
                  as double,
        to: null == to
            ? _self.to
            : to // ignore: cast_nullable_to_non_nullable
                  as double,
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
mixin _$PropertyTypeOption {
  String get id;
  String get label;

  /// Create a copy of PropertyTypeOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PropertyTypeOptionCopyWith<PropertyTypeOption> get copyWith =>
      _$PropertyTypeOptionCopyWithImpl<PropertyTypeOption>(
        this as PropertyTypeOption,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PropertyTypeOption;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PropertyTypeOption &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.label, _this.label) ||
                other.label == _this.label));
  }

  @override
  int get hashCode {
    final _this = this as PropertyTypeOption;
    return Object.hash(runtimeType, _this.id, _this.label);
  }

  @override
  String toString() {
    final _this = this as PropertyTypeOption;
    return 'PropertyTypeOption(id: ${_this.id}, label: ${_this.label})';
  }
}

/// @nodoc
abstract mixin class $PropertyTypeOptionCopyWith<$Res> {
  factory $PropertyTypeOptionCopyWith(
    PropertyTypeOption value,
    $Res Function(PropertyTypeOption) _then,
  ) = _$PropertyTypeOptionCopyWithImpl;
  @useResult
  $Res call({String id, String label});
}

/// @nodoc
class _$PropertyTypeOptionCopyWithImpl<$Res>
    implements $PropertyTypeOptionCopyWith<$Res> {
  _$PropertyTypeOptionCopyWithImpl(this._self, this._then);

  final PropertyTypeOption _self;
  final $Res Function(PropertyTypeOption) _then;

  /// Create a copy of PropertyTypeOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? label = null}) {
    return _then(
      PropertyTypeOption(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [PropertyTypeOption].
extension PropertyTypeOptionPatterns on PropertyTypeOption {
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
    TResult Function(_PropertyTypeOption value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PropertyTypeOption() when $default != null:
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
    TResult Function(_PropertyTypeOption value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyTypeOption():
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
    TResult? Function(_PropertyTypeOption value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyTypeOption() when $default != null:
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
    TResult Function(String id, String label)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PropertyTypeOption() when $default != null:
        return $default(_that.id, _that.label);
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
    TResult Function(String id, String label) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyTypeOption():
        return $default(_that.id, _that.label);
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
    TResult? Function(String id, String label)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyTypeOption() when $default != null:
        return $default(_that.id, _that.label);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PropertyTypeOption extends PropertyTypeOption {
  const _PropertyTypeOption({required this.id, required this.label})
    : super._();

  @override
  final String id;
  @override
  final String label;

  /// Create a copy of PropertyTypeOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PropertyTypeOptionCopyWith<_PropertyTypeOption> get copyWith =>
      __$PropertyTypeOptionCopyWithImpl<_PropertyTypeOption>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PropertyTypeOption &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, label);
  }

  @override
  String toString() {
    return 'PropertyTypeOption(id: $id, label: $label)';
  }
}

/// @nodoc
abstract mixin class _$PropertyTypeOptionCopyWith<$Res>
    implements $PropertyTypeOptionCopyWith<$Res> {
  factory _$PropertyTypeOptionCopyWith(
    _PropertyTypeOption value,
    $Res Function(_PropertyTypeOption) _then,
  ) = __$PropertyTypeOptionCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String label});
}

/// @nodoc
class __$PropertyTypeOptionCopyWithImpl<$Res>
    implements _$PropertyTypeOptionCopyWith<$Res> {
  __$PropertyTypeOptionCopyWithImpl(this._self, this._then);

  final _PropertyTypeOption _self;
  final $Res Function(_PropertyTypeOption) _then;

  /// Create a copy of PropertyTypeOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? id = null, Object? label = null}) {
    return _then(
      _PropertyTypeOption(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
