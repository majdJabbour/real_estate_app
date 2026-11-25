// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PropertySummary {
  String get id;
  String get title;
  String get address;
  String get typeId;
  double get price;
  String get currency;
  String get pricingPeriod;
  double get rating;
  String get thumbnail;
  bool get isFeatured;

  /// Create a copy of PropertySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PropertySummaryCopyWith<PropertySummary> get copyWith =>
      _$PropertySummaryCopyWithImpl<PropertySummary>(
        this as PropertySummary,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PropertySummary;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PropertySummary &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.title, _this.title) ||
                other.title == _this.title) &&
            (identical(other.address, _this.address) ||
                other.address == _this.address) &&
            (identical(other.typeId, _this.typeId) ||
                other.typeId == _this.typeId) &&
            (identical(other.price, _this.price) ||
                other.price == _this.price) &&
            (identical(other.currency, _this.currency) ||
                other.currency == _this.currency) &&
            (identical(other.pricingPeriod, _this.pricingPeriod) ||
                other.pricingPeriod == _this.pricingPeriod) &&
            (identical(other.rating, _this.rating) ||
                other.rating == _this.rating) &&
            (identical(other.thumbnail, _this.thumbnail) ||
                other.thumbnail == _this.thumbnail) &&
            (identical(other.isFeatured, _this.isFeatured) ||
                other.isFeatured == _this.isFeatured));
  }

  @override
  int get hashCode {
    final _this = this as PropertySummary;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.title,
      _this.address,
      _this.typeId,
      _this.price,
      _this.currency,
      _this.pricingPeriod,
      _this.rating,
      _this.thumbnail,
      _this.isFeatured,
    );
  }

  @override
  String toString() {
    final _this = this as PropertySummary;
    return 'PropertySummary(id: ${_this.id}, title: ${_this.title}, address: ${_this.address}, typeId: ${_this.typeId}, price: ${_this.price}, currency: ${_this.currency}, pricingPeriod: ${_this.pricingPeriod}, rating: ${_this.rating}, thumbnail: ${_this.thumbnail}, isFeatured: ${_this.isFeatured})';
  }
}

/// @nodoc
abstract mixin class $PropertySummaryCopyWith<$Res> {
  factory $PropertySummaryCopyWith(
    PropertySummary value,
    $Res Function(PropertySummary) _then,
  ) = _$PropertySummaryCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String address,
    String typeId,
    double price,
    String currency,
    String pricingPeriod,
    double rating,
    String thumbnail,
    bool isFeatured,
  });
}

/// @nodoc
class _$PropertySummaryCopyWithImpl<$Res>
    implements $PropertySummaryCopyWith<$Res> {
  _$PropertySummaryCopyWithImpl(this._self, this._then);

  final PropertySummary _self;
  final $Res Function(PropertySummary) _then;

  /// Create a copy of PropertySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? address = null,
    Object? typeId = null,
    Object? price = null,
    Object? currency = null,
    Object? pricingPeriod = null,
    Object? rating = null,
    Object? thumbnail = null,
    Object? isFeatured = null,
  }) {
    return _then(
      PropertySummary(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _self.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        typeId: null == typeId
            ? _self.typeId
            : typeId // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _self.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        pricingPeriod: null == pricingPeriod
            ? _self.pricingPeriod
            : pricingPeriod // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _self.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        thumbnail: null == thumbnail
            ? _self.thumbnail
            : thumbnail // ignore: cast_nullable_to_non_nullable
                  as String,
        isFeatured: null == isFeatured
            ? _self.isFeatured
            : isFeatured // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [PropertySummary].
extension PropertySummaryPatterns on PropertySummary {
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
    TResult Function(_PropertySummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PropertySummary() when $default != null:
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
    TResult Function(_PropertySummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertySummary():
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
    TResult? Function(_PropertySummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertySummary() when $default != null:
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
      String title,
      String address,
      String typeId,
      double price,
      String currency,
      String pricingPeriod,
      double rating,
      String thumbnail,
      bool isFeatured,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PropertySummary() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.address,
          _that.typeId,
          _that.price,
          _that.currency,
          _that.pricingPeriod,
          _that.rating,
          _that.thumbnail,
          _that.isFeatured,
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
      String id,
      String title,
      String address,
      String typeId,
      double price,
      String currency,
      String pricingPeriod,
      double rating,
      String thumbnail,
      bool isFeatured,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertySummary():
        return $default(
          _that.id,
          _that.title,
          _that.address,
          _that.typeId,
          _that.price,
          _that.currency,
          _that.pricingPeriod,
          _that.rating,
          _that.thumbnail,
          _that.isFeatured,
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
      String id,
      String title,
      String address,
      String typeId,
      double price,
      String currency,
      String pricingPeriod,
      double rating,
      String thumbnail,
      bool isFeatured,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertySummary() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.address,
          _that.typeId,
          _that.price,
          _that.currency,
          _that.pricingPeriod,
          _that.rating,
          _that.thumbnail,
          _that.isFeatured,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PropertySummary extends PropertySummary {
  const _PropertySummary({
    required this.id,
    required this.title,
    required this.address,
    required this.typeId,
    required this.price,
    required this.currency,
    required this.pricingPeriod,
    required this.rating,
    required this.thumbnail,
    required this.isFeatured,
  }) : super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final String address;
  @override
  final String typeId;
  @override
  final double price;
  @override
  final String currency;
  @override
  final String pricingPeriod;
  @override
  final double rating;
  @override
  final String thumbnail;
  @override
  final bool isFeatured;

  /// Create a copy of PropertySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PropertySummaryCopyWith<_PropertySummary> get copyWith =>
      __$PropertySummaryCopyWithImpl<_PropertySummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PropertySummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.typeId, typeId) || other.typeId == typeId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.pricingPeriod, pricingPeriod) ||
                other.pricingPeriod == pricingPeriod) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      title,
      address,
      typeId,
      price,
      currency,
      pricingPeriod,
      rating,
      thumbnail,
      isFeatured,
    );
  }

  @override
  String toString() {
    return 'PropertySummary(id: $id, title: $title, address: $address, typeId: $typeId, price: $price, currency: $currency, pricingPeriod: $pricingPeriod, rating: $rating, thumbnail: $thumbnail, isFeatured: $isFeatured)';
  }
}

/// @nodoc
abstract mixin class _$PropertySummaryCopyWith<$Res>
    implements $PropertySummaryCopyWith<$Res> {
  factory _$PropertySummaryCopyWith(
    _PropertySummary value,
    $Res Function(_PropertySummary) _then,
  ) = __$PropertySummaryCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String address,
    String typeId,
    double price,
    String currency,
    String pricingPeriod,
    double rating,
    String thumbnail,
    bool isFeatured,
  });
}

/// @nodoc
class __$PropertySummaryCopyWithImpl<$Res>
    implements _$PropertySummaryCopyWith<$Res> {
  __$PropertySummaryCopyWithImpl(this._self, this._then);

  final _PropertySummary _self;
  final $Res Function(_PropertySummary) _then;

  /// Create a copy of PropertySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? address = null,
    Object? typeId = null,
    Object? price = null,
    Object? currency = null,
    Object? pricingPeriod = null,
    Object? rating = null,
    Object? thumbnail = null,
    Object? isFeatured = null,
  }) {
    return _then(
      _PropertySummary(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _self.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        typeId: null == typeId
            ? _self.typeId
            : typeId // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _self.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        pricingPeriod: null == pricingPeriod
            ? _self.pricingPeriod
            : pricingPeriod // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _self.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        thumbnail: null == thumbnail
            ? _self.thumbnail
            : thumbnail // ignore: cast_nullable_to_non_nullable
                  as String,
        isFeatured: null == isFeatured
            ? _self.isFeatured
            : isFeatured // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$PropertyDetails {
  /// Create a copy of PropertyDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PropertyDetailsCopyWith<PropertyDetails> get copyWith =>
      _$PropertyDetailsCopyWithImpl<PropertyDetails>(
        this as PropertyDetails,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PropertyDetails;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PropertyDetails &&
            (identical(other.summary, _this.summary) ||
                other.summary == _this.summary) &&
            (identical(other.description, _this.description) ||
                other.description == _this.description) &&
            (identical(other.bedrooms, _this.bedrooms) ||
                other.bedrooms == _this.bedrooms) &&
            (identical(other.bathrooms, _this.bathrooms) ||
                other.bathrooms == _this.bathrooms) &&
            (identical(other.area, _this.area) || other.area == _this.area) &&
            (identical(other.areaUnit, _this.areaUnit) ||
                other.areaUnit == _this.areaUnit) &&
            const DeepCollectionEquality().equals(other.images, _this.images) &&
            const DeepCollectionEquality().equals(
              other.facilities,
              _this.facilities,
            ) &&
            (identical(other.agent, _this.agent) ||
                other.agent == _this.agent) &&
            (identical(other.location, _this.location) ||
                other.location == _this.location) &&
            const DeepCollectionEquality().equals(
              other.reviews,
              _this.reviews,
            ) &&
            (identical(other.createdAt, _this.createdAt) ||
                other.createdAt == _this.createdAt));
  }

  @override
  int get hashCode {
    final _this = this as PropertyDetails;
    return Object.hash(
      runtimeType,
      _this.summary,
      _this.description,
      _this.bedrooms,
      _this.bathrooms,
      _this.area,
      _this.areaUnit,
      const DeepCollectionEquality().hash(_this.images),
      const DeepCollectionEquality().hash(_this.facilities),
      _this.agent,
      _this.location,
      const DeepCollectionEquality().hash(_this.reviews),
      _this.createdAt,
    );
  }

  @override
  String toString() {
    final _this = this as PropertyDetails;
    return 'PropertyDetails(summary: ${_this.summary}, description: ${_this.description}, bedrooms: ${_this.bedrooms}, bathrooms: ${_this.bathrooms}, area: ${_this.area}, areaUnit: ${_this.areaUnit}, images: ${_this.images}, facilities: ${_this.facilities}, agent: ${_this.agent}, location: ${_this.location}, reviews: ${_this.reviews}, createdAt: ${_this.createdAt})';
  }
}

/// @nodoc
abstract mixin class $PropertyDetailsCopyWith<$Res> {
  factory $PropertyDetailsCopyWith(
    PropertyDetails value,
    $Res Function(PropertyDetails) _then,
  ) = _$PropertyDetailsCopyWithImpl;
  @useResult
  $Res call({
    PropertySummary summary,
    String description,
    int bedrooms,
    int bathrooms,
    double area,
    String areaUnit,
    List<String> images,
    List<String> facilities,
    PropertyAgent agent,
    PropertyLocation location,
    List<PropertyReview> reviews,
    DateTime createdAt,
  });

  $PropertySummaryCopyWith<$Res> get summary;
  $PropertyAgentCopyWith<$Res> get agent;
  $PropertyLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$PropertyDetailsCopyWithImpl<$Res>
    implements $PropertyDetailsCopyWith<$Res> {
  _$PropertyDetailsCopyWithImpl(this._self, this._then);

  final PropertyDetails _self;
  final $Res Function(PropertyDetails) _then;

  /// Create a copy of PropertyDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? description = null,
    Object? bedrooms = null,
    Object? bathrooms = null,
    Object? area = null,
    Object? areaUnit = null,
    Object? images = null,
    Object? facilities = null,
    Object? agent = null,
    Object? location = null,
    Object? reviews = null,
    Object? createdAt = null,
  }) {
    return _then(
      PropertyDetails(
        summary: null == summary
            ? _self.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as PropertySummary,
        description: null == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        bedrooms: null == bedrooms
            ? _self.bedrooms
            : bedrooms // ignore: cast_nullable_to_non_nullable
                  as int,
        bathrooms: null == bathrooms
            ? _self.bathrooms
            : bathrooms // ignore: cast_nullable_to_non_nullable
                  as int,
        area: null == area
            ? _self.area
            : area // ignore: cast_nullable_to_non_nullable
                  as double,
        areaUnit: null == areaUnit
            ? _self.areaUnit
            : areaUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _self.images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        facilities: null == facilities
            ? _self.facilities
            : facilities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        agent: null == agent
            ? _self.agent
            : agent // ignore: cast_nullable_to_non_nullable
                  as PropertyAgent,
        location: null == location
            ? _self.location
            : location // ignore: cast_nullable_to_non_nullable
                  as PropertyLocation,
        reviews: null == reviews
            ? _self.reviews
            : reviews // ignore: cast_nullable_to_non_nullable
                  as List<PropertyReview>,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }

  /// Create a copy of PropertyDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertySummaryCopyWith<$Res> get summary {
    return $PropertySummaryCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }

  /// Create a copy of PropertyDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertyAgentCopyWith<$Res> get agent {
    return $PropertyAgentCopyWith<$Res>(_self.agent, (value) {
      return _then(_self.copyWith(agent: value));
    });
  }

  /// Create a copy of PropertyDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertyLocationCopyWith<$Res> get location {
    return $PropertyLocationCopyWith<$Res>(_self.location, (value) {
      return _then(_self.copyWith(location: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PropertyDetails].
extension PropertyDetailsPatterns on PropertyDetails {
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
mixin _$PropertyAgent {
  String get id;
  String get name;
  String? get avatar;

  /// Create a copy of PropertyAgent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PropertyAgentCopyWith<PropertyAgent> get copyWith =>
      _$PropertyAgentCopyWithImpl<PropertyAgent>(
        this as PropertyAgent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PropertyAgent;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PropertyAgent &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.name, _this.name) || other.name == _this.name) &&
            (identical(other.avatar, _this.avatar) ||
                other.avatar == _this.avatar));
  }

  @override
  int get hashCode {
    final _this = this as PropertyAgent;
    return Object.hash(runtimeType, _this.id, _this.name, _this.avatar);
  }

  @override
  String toString() {
    final _this = this as PropertyAgent;
    return 'PropertyAgent(id: ${_this.id}, name: ${_this.name}, avatar: ${_this.avatar})';
  }
}

/// @nodoc
abstract mixin class $PropertyAgentCopyWith<$Res> {
  factory $PropertyAgentCopyWith(
    PropertyAgent value,
    $Res Function(PropertyAgent) _then,
  ) = _$PropertyAgentCopyWithImpl;
  @useResult
  $Res call({String id, String name, String? avatar});
}

/// @nodoc
class _$PropertyAgentCopyWithImpl<$Res>
    implements $PropertyAgentCopyWith<$Res> {
  _$PropertyAgentCopyWithImpl(this._self, this._then);

  final PropertyAgent _self;
  final $Res Function(PropertyAgent) _then;

  /// Create a copy of PropertyAgent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
  }) {
    return _then(
      PropertyAgent(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        avatar: freezed == avatar
            ? _self.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [PropertyAgent].
extension PropertyAgentPatterns on PropertyAgent {
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
    TResult Function(_PropertyAgent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PropertyAgent() when $default != null:
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
    TResult Function(_PropertyAgent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyAgent():
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
    TResult? Function(_PropertyAgent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyAgent() when $default != null:
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
    TResult Function(String id, String name, String? avatar)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PropertyAgent() when $default != null:
        return $default(_that.id, _that.name, _that.avatar);
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
    TResult Function(String id, String name, String? avatar) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyAgent():
        return $default(_that.id, _that.name, _that.avatar);
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
    TResult? Function(String id, String name, String? avatar)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyAgent() when $default != null:
        return $default(_that.id, _that.name, _that.avatar);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PropertyAgent implements PropertyAgent {
  const _PropertyAgent({
    required this.id,
    required this.name,
    required this.avatar,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String? avatar;

  /// Create a copy of PropertyAgent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PropertyAgentCopyWith<_PropertyAgent> get copyWith =>
      __$PropertyAgentCopyWithImpl<_PropertyAgent>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PropertyAgent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, name, avatar);
  }

  @override
  String toString() {
    return 'PropertyAgent(id: $id, name: $name, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class _$PropertyAgentCopyWith<$Res>
    implements $PropertyAgentCopyWith<$Res> {
  factory _$PropertyAgentCopyWith(
    _PropertyAgent value,
    $Res Function(_PropertyAgent) _then,
  ) = __$PropertyAgentCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name, String? avatar});
}

/// @nodoc
class __$PropertyAgentCopyWithImpl<$Res>
    implements _$PropertyAgentCopyWith<$Res> {
  __$PropertyAgentCopyWithImpl(this._self, this._then);

  final _PropertyAgent _self;
  final $Res Function(_PropertyAgent) _then;

  /// Create a copy of PropertyAgent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
  }) {
    return _then(
      _PropertyAgent(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        avatar: freezed == avatar
            ? _self.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
mixin _$PropertyLocation {
  double get latitude;
  double get longitude;

  /// Create a copy of PropertyLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PropertyLocationCopyWith<PropertyLocation> get copyWith =>
      _$PropertyLocationCopyWithImpl<PropertyLocation>(
        this as PropertyLocation,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PropertyLocation;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PropertyLocation &&
            (identical(other.latitude, _this.latitude) ||
                other.latitude == _this.latitude) &&
            (identical(other.longitude, _this.longitude) ||
                other.longitude == _this.longitude));
  }

  @override
  int get hashCode {
    final _this = this as PropertyLocation;
    return Object.hash(runtimeType, _this.latitude, _this.longitude);
  }

  @override
  String toString() {
    final _this = this as PropertyLocation;
    return 'PropertyLocation(latitude: ${_this.latitude}, longitude: ${_this.longitude})';
  }
}

/// @nodoc
abstract mixin class $PropertyLocationCopyWith<$Res> {
  factory $PropertyLocationCopyWith(
    PropertyLocation value,
    $Res Function(PropertyLocation) _then,
  ) = _$PropertyLocationCopyWithImpl;
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class _$PropertyLocationCopyWithImpl<$Res>
    implements $PropertyLocationCopyWith<$Res> {
  _$PropertyLocationCopyWithImpl(this._self, this._then);

  final PropertyLocation _self;
  final $Res Function(PropertyLocation) _then;

  /// Create a copy of PropertyLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? latitude = null, Object? longitude = null}) {
    return _then(
      PropertyLocation(
        latitude: null == latitude
            ? _self.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _self.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [PropertyLocation].
extension PropertyLocationPatterns on PropertyLocation {
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
    TResult Function(_PropertyLocation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PropertyLocation() when $default != null:
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
    TResult Function(_PropertyLocation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyLocation():
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
    TResult? Function(_PropertyLocation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyLocation() when $default != null:
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
    TResult Function(double latitude, double longitude)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PropertyLocation() when $default != null:
        return $default(_that.latitude, _that.longitude);
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
    TResult Function(double latitude, double longitude) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyLocation():
        return $default(_that.latitude, _that.longitude);
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
    TResult? Function(double latitude, double longitude)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyLocation() when $default != null:
        return $default(_that.latitude, _that.longitude);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PropertyLocation implements PropertyLocation {
  const _PropertyLocation({required this.latitude, required this.longitude});

  @override
  final double latitude;
  @override
  final double longitude;

  /// Create a copy of PropertyLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PropertyLocationCopyWith<_PropertyLocation> get copyWith =>
      __$PropertyLocationCopyWithImpl<_PropertyLocation>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PropertyLocation &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, latitude, longitude);
  }

  @override
  String toString() {
    return 'PropertyLocation(latitude: $latitude, longitude: $longitude)';
  }
}

/// @nodoc
abstract mixin class _$PropertyLocationCopyWith<$Res>
    implements $PropertyLocationCopyWith<$Res> {
  factory _$PropertyLocationCopyWith(
    _PropertyLocation value,
    $Res Function(_PropertyLocation) _then,
  ) = __$PropertyLocationCopyWithImpl;
  @override
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class __$PropertyLocationCopyWithImpl<$Res>
    implements _$PropertyLocationCopyWith<$Res> {
  __$PropertyLocationCopyWithImpl(this._self, this._then);

  final _PropertyLocation _self;
  final $Res Function(_PropertyLocation) _then;

  /// Create a copy of PropertyLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? latitude = null, Object? longitude = null}) {
    return _then(
      _PropertyLocation(
        latitude: null == latitude
            ? _self.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _self.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
mixin _$PropertyReview {
  String get id;
  String get reviewerName;
  double get rating;
  String get comment;
  DateTime get date;

  /// Create a copy of PropertyReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PropertyReviewCopyWith<PropertyReview> get copyWith =>
      _$PropertyReviewCopyWithImpl<PropertyReview>(
        this as PropertyReview,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as PropertyReview;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PropertyReview &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.reviewerName, _this.reviewerName) ||
                other.reviewerName == _this.reviewerName) &&
            (identical(other.rating, _this.rating) ||
                other.rating == _this.rating) &&
            (identical(other.comment, _this.comment) ||
                other.comment == _this.comment) &&
            (identical(other.date, _this.date) || other.date == _this.date));
  }

  @override
  int get hashCode {
    final _this = this as PropertyReview;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.reviewerName,
      _this.rating,
      _this.comment,
      _this.date,
    );
  }

  @override
  String toString() {
    final _this = this as PropertyReview;
    return 'PropertyReview(id: ${_this.id}, reviewerName: ${_this.reviewerName}, rating: ${_this.rating}, comment: ${_this.comment}, date: ${_this.date})';
  }
}

/// @nodoc
abstract mixin class $PropertyReviewCopyWith<$Res> {
  factory $PropertyReviewCopyWith(
    PropertyReview value,
    $Res Function(PropertyReview) _then,
  ) = _$PropertyReviewCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String reviewerName,
    double rating,
    String comment,
    DateTime date,
  });
}

/// @nodoc
class _$PropertyReviewCopyWithImpl<$Res>
    implements $PropertyReviewCopyWith<$Res> {
  _$PropertyReviewCopyWithImpl(this._self, this._then);

  final PropertyReview _self;
  final $Res Function(PropertyReview) _then;

  /// Create a copy of PropertyReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerName = null,
    Object? rating = null,
    Object? comment = null,
    Object? date = null,
  }) {
    return _then(
      PropertyReview(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewerName: null == reviewerName
            ? _self.reviewerName
            : reviewerName // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _self.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        comment: null == comment
            ? _self.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [PropertyReview].
extension PropertyReviewPatterns on PropertyReview {
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
    TResult Function(_PropertyReview value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PropertyReview() when $default != null:
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
    TResult Function(_PropertyReview value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyReview():
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
    TResult? Function(_PropertyReview value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyReview() when $default != null:
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
      String reviewerName,
      double rating,
      String comment,
      DateTime date,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PropertyReview() when $default != null:
        return $default(
          _that.id,
          _that.reviewerName,
          _that.rating,
          _that.comment,
          _that.date,
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
      String id,
      String reviewerName,
      double rating,
      String comment,
      DateTime date,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyReview():
        return $default(
          _that.id,
          _that.reviewerName,
          _that.rating,
          _that.comment,
          _that.date,
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
      String id,
      String reviewerName,
      double rating,
      String comment,
      DateTime date,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PropertyReview() when $default != null:
        return $default(
          _that.id,
          _that.reviewerName,
          _that.rating,
          _that.comment,
          _that.date,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PropertyReview implements PropertyReview {
  const _PropertyReview({
    required this.id,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  final String id;
  @override
  final String reviewerName;
  @override
  final double rating;
  @override
  final String comment;
  @override
  final DateTime date;

  /// Create a copy of PropertyReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PropertyReviewCopyWith<_PropertyReview> get copyWith =>
      __$PropertyReviewCopyWithImpl<_PropertyReview>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PropertyReview &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reviewerName, reviewerName) ||
                other.reviewerName == reviewerName) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, reviewerName, rating, comment, date);
  }

  @override
  String toString() {
    return 'PropertyReview(id: $id, reviewerName: $reviewerName, rating: $rating, comment: $comment, date: $date)';
  }
}

/// @nodoc
abstract mixin class _$PropertyReviewCopyWith<$Res>
    implements $PropertyReviewCopyWith<$Res> {
  factory _$PropertyReviewCopyWith(
    _PropertyReview value,
    $Res Function(_PropertyReview) _then,
  ) = __$PropertyReviewCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String reviewerName,
    double rating,
    String comment,
    DateTime date,
  });
}

/// @nodoc
class __$PropertyReviewCopyWithImpl<$Res>
    implements _$PropertyReviewCopyWith<$Res> {
  __$PropertyReviewCopyWithImpl(this._self, this._then);

  final _PropertyReview _self;
  final $Res Function(_PropertyReview) _then;

  /// Create a copy of PropertyReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? reviewerName = null,
    Object? rating = null,
    Object? comment = null,
    Object? date = null,
  }) {
    return _then(
      _PropertyReview(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewerName: null == reviewerName
            ? _self.reviewerName
            : reviewerName // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _self.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        comment: null == comment
            ? _self.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
