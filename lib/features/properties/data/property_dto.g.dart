// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertySummaryDto _$PropertySummaryDtoFromJson(Map<String, dynamic> json) =>
    PropertySummaryDto(
      id: propertyText(json['id'] as String),
      title: propertyText(json['title'] as String),
      address: propertyText(json['address'] as String),
      type: propertyText(json['type'] as String),
      price: _positive(json['price'] as num),
      currency: propertyText(json['currency'] as String),
      pricingPeriod: propertyText(json['pricingPeriod'] as String),
      rating: _rating(json['rating'] as num),
      thumbnail: _httpsUrl(json['thumbnail'] as String),
      isFeatured: json['isFeatured'] as bool,
    );

PropertyDetailsDto _$PropertyDetailsDtoFromJson(Map<String, dynamic> json) =>
    PropertyDetailsDto(
      summary: PropertySummaryDto.fromJson(
        _detailSummary(json, 'summary') as Map<String, dynamic>,
      ),
      description: propertyText(json['description'] as String),
      bedrooms: propertyCount(json['bedrooms'] as num),
      bathrooms: propertyCount(json['bathrooms'] as num),
      area: _positive(json['area'] as num),
      areaUnit: propertyText(json['areaUnit'] as String),
      images: _images(json['images'] as List),
      facilities: _facilities(json['facilities'] as List),
      agent: _agent(json['agent'] as Map<String, Object?>),
      location: _location(json['location']),
      reviews: _reviews(json['reviews'] as List),
      createdAt: _timestamp(json['createdAt'] as String),
    );
