// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_filter_options_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyFilterOptionsDto _$PropertyFilterOptionsDtoFromJson(
  Map<String, dynamic> json,
) => PropertyFilterOptionsDto(
  price: PropertyPriceOptionsDto.fromJson(
    json['price'] as Map<String, dynamic>,
  ),
  area: PropertyAreaOptionsDto.fromJson(json['area'] as Map<String, dynamic>),
  bedrooms: _roomBounds(json['bedrooms'] as Map<String, Object?>),
  bathrooms: _roomBounds(json['bathrooms'] as Map<String, Object?>),
  types: _typeOptions(json['types'] as List),
);

PropertyPriceOptionsDto _$PropertyPriceOptionsDtoFromJson(
  Map<String, dynamic> json,
) => PropertyPriceOptionsDto(
  bounds: _decimalBounds(_boundsObject(json, 'bounds') as Map<String, Object?>),
  currency: propertyText(json['currency'] as String),
  pricingPeriod: propertyText(json['pricingPeriod'] as String),
  histogram: _histogram(json['histogram'] as List),
);

PropertyAreaOptionsDto _$PropertyAreaOptionsDtoFromJson(
  Map<String, dynamic> json,
) => PropertyAreaOptionsDto(
  bounds: _decimalBounds(_boundsObject(json, 'bounds') as Map<String, Object?>),
  unit: propertyText(json['unit'] as String),
);
