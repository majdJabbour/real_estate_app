import 'package:json_annotation/json_annotation.dart';

import '../domain/property_filter_options.dart';
import 'property_dto.dart';

part 'property_filter_options_dto.g.dart';

@JsonSerializable(createToJson: false)
final class PropertyFilterOptionsDto {
  const PropertyFilterOptionsDto({
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.types,
  });

  factory PropertyFilterOptionsDto.fromJson(Map<String, Object?> json) =>
      _$PropertyFilterOptionsDtoFromJson(json);

  final PropertyPriceOptionsDto price;
  final PropertyAreaOptionsDto area;
  @JsonKey(fromJson: _roomBounds)
  final PropertyBounds<int> bedrooms;
  @JsonKey(fromJson: _roomBounds)
  final PropertyBounds<int> bathrooms;
  @JsonKey(fromJson: _typeOptions)
  final List<PropertyTypeOption> types;

  PropertyFilterOptions toDomain() => PropertyFilterOptions(
    price: price.toDomain(),
    area: area.bounds,
    areaUnit: area.unit,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    types: types,
  );
}

@JsonSerializable(createToJson: false)
final class PropertyPriceOptionsDto {
  const PropertyPriceOptionsDto({
    required this.bounds,
    required this.currency,
    required this.pricingPeriod,
    required this.histogram,
  });

  factory PropertyPriceOptionsDto.fromJson(Map<String, Object?> json) =>
      _$PropertyPriceOptionsDtoFromJson(json);

  @JsonKey(readValue: _boundsObject, fromJson: _decimalBounds)
  final PropertyBounds<double> bounds;
  @JsonKey(fromJson: propertyText)
  final String currency;
  @JsonKey(fromJson: propertyText)
  final String pricingPeriod;
  @JsonKey(fromJson: _histogram)
  final List<PriceHistogramBucket> histogram;

  PropertyPriceOptions toDomain() => PropertyPriceOptions(
    bounds: bounds,
    currency: currency,
    pricingPeriod: pricingPeriod,
    histogram: histogram,
  );
}

@JsonSerializable(createToJson: false)
final class PropertyAreaOptionsDto {
  const PropertyAreaOptionsDto({required this.bounds, required this.unit});

  factory PropertyAreaOptionsDto.fromJson(Map<String, Object?> json) =>
      _$PropertyAreaOptionsDtoFromJson(json);

  @JsonKey(readValue: _boundsObject, fromJson: _decimalBounds)
  final PropertyBounds<double> bounds;
  @JsonKey(fromJson: propertyText)
  final String unit;
}

Object? _boundsObject(Map<Object?, Object?> json, String _) => json;

PropertyBounds<int> _roomBounds(Map<String, Object?> json) =>
    _bounds(json, propertyCount);

PropertyBounds<double> _decimalBounds(Map<String, Object?> json) =>
    _bounds(json, propertyNumber);

PropertyBounds<T> _bounds<T extends num>(
  Map<String, Object?> json,
  T Function(num) decode,
) {
  if (!json.containsKey('min') || !json.containsKey('max')) {
    throw const FormatException('Missing property filter bounds.');
  }
  final min = json['min'] as num?;
  final max = json['max'] as num?;
  return (
    min: min == null ? null : decode(min),
    max: max == null ? null : decode(max),
  );
}

List<PriceHistogramBucket> _histogram(List<Object?> list) => list.map((value) {
  final bucket = value as Map<String, Object?>;
  return PriceHistogramBucket(
    from: propertyNumber(bucket['from'] as num),
    to: propertyNumber(bucket['to'] as num),
    count: propertyCount(bucket['count'] as num),
  );
}).toList();

List<PropertyTypeOption> _typeOptions(List<Object?> list) => list.map((value) {
  final option = value as Map<String, Object?>;
  return PropertyTypeOption(
    id: propertyText(option['id'] as String),
    label: propertyText(option['label'] as String),
  );
}).toList();
