import 'package:freezed_annotation/freezed_annotation.dart';

import 'property_type.dart';

part 'property.freezed.dart';

@freezed
abstract class PropertySummary with _$PropertySummary {
  const PropertySummary._();

  const factory PropertySummary({
    required String id,
    required String title,
    required String address,
    required String typeId,
    required double price,
    required String currency,
    required String pricingPeriod,
    required double rating,
    required String thumbnail,
    required bool isFeatured,
  }) = _PropertySummary;

  PropertyType? get type => PropertyType.fromId(typeId);
}

@freezed
class PropertyDetails with _$PropertyDetails {
  PropertyDetails({
    required this.summary,
    required this.description,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.areaUnit,
    required List<String> images,
    required List<String> facilities,
    required this.agent,
    required this.location,
    required List<PropertyReview> reviews,
    required this.createdAt,
  }) : images = List.unmodifiable(images),
       facilities = List.unmodifiable(facilities),
       reviews = List.unmodifiable(reviews);

  final PropertySummary summary;
  final String description;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String areaUnit;
  final List<String> images;
  final List<String> facilities;
  final PropertyAgent agent;
  final PropertyLocation location;
  final List<PropertyReview> reviews;
  final DateTime createdAt;
}

@freezed
abstract class PropertyAgent with _$PropertyAgent {
  const factory PropertyAgent({
    required String id,
    required String name,
    required String? avatar,
  }) = _PropertyAgent;
}

@freezed
abstract class PropertyLocation with _$PropertyLocation {
  const factory PropertyLocation({
    required double latitude,
    required double longitude,
  }) = _PropertyLocation;
}

@freezed
abstract class PropertyReview with _$PropertyReview {
  const factory PropertyReview({
    required String id,
    required String reviewerName,
    required double rating,
    required String comment,
    required DateTime date,
  }) = _PropertyReview;
}
