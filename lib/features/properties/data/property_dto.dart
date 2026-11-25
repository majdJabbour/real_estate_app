import 'package:json_annotation/json_annotation.dart';

import '../domain/property.dart';

part 'property_dto.g.dart';

@JsonSerializable(createToJson: false)
final class PropertySummaryDto {
  const PropertySummaryDto({
    required this.id,
    required this.title,
    required this.address,
    required this.type,
    required this.price,
    required this.currency,
    required this.pricingPeriod,
    required this.rating,
    required this.thumbnail,
    required this.isFeatured,
  });

  factory PropertySummaryDto.fromJson(Map<String, Object?> json) =>
      _$PropertySummaryDtoFromJson(json);

  @JsonKey(fromJson: propertyText)
  final String id;
  @JsonKey(fromJson: propertyText)
  final String title;
  @JsonKey(fromJson: propertyText)
  final String address;
  @JsonKey(fromJson: propertyText)
  final String type;
  @JsonKey(fromJson: _positive)
  final double price;
  @JsonKey(fromJson: propertyText)
  final String currency;
  @JsonKey(fromJson: propertyText)
  final String pricingPeriod;
  @JsonKey(fromJson: _rating)
  final double rating;
  @JsonKey(fromJson: _httpsUrl)
  final String thumbnail;
  final bool isFeatured;

  PropertySummary toDomain() => PropertySummary(
    id: id,
    title: title,
    address: address,
    typeId: type,
    price: price,
    currency: currency,
    pricingPeriod: pricingPeriod,
    rating: rating,
    thumbnail: thumbnail,
    isFeatured: isFeatured,
  );
}

@JsonSerializable(createToJson: false)
final class PropertyDetailsDto {
  const PropertyDetailsDto({
    required this.summary,
    required this.description,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.areaUnit,
    required this.images,
    required this.facilities,
    required this.agent,
    required this.location,
    required this.reviews,
    required this.createdAt,
  });

  factory PropertyDetailsDto.fromJson(Map<String, Object?> json) =>
      _$PropertyDetailsDtoFromJson(json);

  // The server flattens the summary fields into the detail object.
  @JsonKey(readValue: _detailSummary)
  final PropertySummaryDto summary;
  @JsonKey(fromJson: propertyText)
  final String description;
  @JsonKey(fromJson: propertyCount)
  final int bedrooms;
  @JsonKey(fromJson: propertyCount)
  final int bathrooms;
  @JsonKey(fromJson: _positive)
  final double area;
  @JsonKey(fromJson: propertyText)
  final String areaUnit;
  @JsonKey(fromJson: _images)
  final List<String> images;
  @JsonKey(fromJson: _facilities)
  final List<String> facilities;
  @JsonKey(fromJson: _agent)
  final PropertyAgent agent;
  @JsonKey(fromJson: _location)
  final PropertyLocation? location;
  @JsonKey(fromJson: _reviews)
  final List<PropertyReview> reviews;
  @JsonKey(fromJson: _timestamp)
  final DateTime createdAt;

  PropertyDetails toDomain() => PropertyDetails(
    summary: summary.toDomain(),
    description: description,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    area: area,
    areaUnit: areaUnit,
    images: images,
    facilities: facilities,
    agent: agent,
    location: location,
    reviews: reviews,
    createdAt: createdAt,
  );
}

Map<String, Object?> _detailSummary(Map<dynamic, dynamic> json, String _) =>
    json as Map<String, Object?>;

String propertyText(String value) {
  if (value.trim().isEmpty) throw const FormatException('Empty property text.');
  return value;
}

double propertyNumber(num value) {
  if (!value.isFinite) throw const FormatException('Invalid property number.');
  return value.toDouble();
}

double _positive(num value) {
  if (value <= 0) throw const FormatException('Expected a positive number.');
  return propertyNumber(value);
}

int propertyCount(num value) {
  if (value < 0 || value > 9007199254740991 || value % 1 != 0) {
    throw const FormatException('Expected a nonnegative integer count.');
  }
  return value.toInt();
}

double _inRange(num value, int min, int max) {
  if (value < min || value > max) {
    throw const FormatException('Property number out of range.');
  }
  return propertyNumber(value);
}

double _rating(num value) => _inRange(value, 0, 5);

String _httpsUrl(String value) {
  final uri = Uri.tryParse(value);
  if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
    throw const FormatException('Invalid property image URL.');
  }
  return value;
}

DateTime _timestamp(String value) {
  final date = DateTime.tryParse(value);
  if (date == null || !value.endsWith('Z')) {
    throw const FormatException('Expected a UTC property timestamp.');
  }
  return date;
}

List<String> _images(List<Object?> list) =>
    list.map((value) => _httpsUrl(value as String)).toList();

List<String> _facilities(List<Object?> list) =>
    list.map((value) => propertyText(value as String)).toList();

PropertyAgent _agent(Map<String, Object?> json) {
  if (!json.containsKey('avatar')) {
    throw const FormatException('Missing property agent avatar field.');
  }
  final avatar = json['avatar'] as String?;
  return PropertyAgent(
    id: propertyText(json['id'] as String),
    name: propertyText(json['name'] as String),
    avatar: avatar == null ? null : _httpsUrl(avatar),
  );
}

PropertyLocation? _location(Object? json) {
  if (json
      case {'latitude': final num latitude, 'longitude': final num longitude}
      when latitude.isFinite &&
          latitude.abs() <= 90 &&
          longitude.isFinite &&
          longitude.abs() <= 180) {
    return PropertyLocation(
      latitude: latitude.toDouble(),
      longitude: longitude.toDouble(),
    );
  }
  return null;
}

List<PropertyReview> _reviews(List<Object?> list) =>
    list.map((value) => _review(value as Map<String, Object?>)).toList();

PropertyReview _review(Map<String, Object?> json) => PropertyReview(
  id: propertyText(json['id'] as String),
  reviewerName: propertyText(json['reviewerName'] as String),
  rating: _rating(json['rating'] as num),
  comment: propertyText(json['comment'] as String),
  date: _timestamp(json['date'] as String),
);
