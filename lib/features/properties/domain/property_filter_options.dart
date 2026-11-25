import 'package:freezed_annotation/freezed_annotation.dart';

import 'property_type.dart';

part 'property_filter_options.freezed.dart';

typedef PropertyBounds<T extends num> = ({T? min, T? max});

@freezed
class PropertyFilterOptions with _$PropertyFilterOptions {
  PropertyFilterOptions({
    required this.price,
    required this.area,
    required this.areaUnit,
    required this.bedrooms,
    required this.bathrooms,
    required List<PropertyTypeOption> types,
  }) : types = List.unmodifiable(types);

  final PropertyPriceOptions price;
  final PropertyBounds<double> area;
  final String areaUnit;
  final PropertyBounds<int> bedrooms;
  final PropertyBounds<int> bathrooms;
  final List<PropertyTypeOption> types;
}

@freezed
class PropertyPriceOptions with _$PropertyPriceOptions {
  PropertyPriceOptions({
    required this.bounds,
    required this.currency,
    required this.pricingPeriod,
    required List<PriceHistogramBucket> histogram,
  }) : histogram = List.unmodifiable(histogram);

  final PropertyBounds<double> bounds;
  final String currency;
  final String pricingPeriod;
  final List<PriceHistogramBucket> histogram;
}

@freezed
abstract class PriceHistogramBucket with _$PriceHistogramBucket {
  const factory PriceHistogramBucket({
    required double from,
    required double to,
    required int count,
  }) = _PriceHistogramBucket;
}

@freezed
abstract class PropertyTypeOption with _$PropertyTypeOption {
  const PropertyTypeOption._();

  const factory PropertyTypeOption({
    required String id,
    required String label,
  }) = _PropertyTypeOption;

  PropertyType? get type => PropertyType.fromId(id);
}
