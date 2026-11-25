import 'package:freezed_annotation/freezed_annotation.dart';

import 'property_type.dart';

part 'property_query.freezed.dart';

enum PropertySortBy { createdAt, price, rating, area }

enum SortOrder { asc, desc }

@freezed
class PropertyQuery with _$PropertyQuery {
  PropertyQuery({
    String? search,
    Set<PropertyType> types = const {},
    this.minPrice,
    this.maxPrice,
    this.minBedrooms,
    this.minBathrooms,
    this.minArea,
    this.maxArea,
    this.featured,
    this.sortBy = PropertySortBy.createdAt,
    this.sortOrder = SortOrder.desc,
    this.page = 1,
    this.limit = 20,
  }) : search = _normalizeSearch(search),
       types = Set.unmodifiable(types) {
    RangeError.checkValueInInterval(page, 1, 1000000, 'page');
    RangeError.checkValueInInterval(limit, 1, 100, 'limit');
    _validateRooms(minBedrooms, 'minBedrooms');
    _validateRooms(minBathrooms, 'minBathrooms');
    _validateRange(minPrice, maxPrice, 'Price');
    _validateRange(minArea, maxArea, 'Area');
  }

  final String? search;
  final Set<PropertyType> types;
  final double? minPrice;
  final double? maxPrice;
  final int? minBedrooms;
  final int? minBathrooms;
  final double? minArea;
  final double? maxArea;
  final bool? featured;
  final PropertySortBy sortBy;
  final SortOrder sortOrder;
  final int page;
  final int limit;
}

String? _normalizeSearch(String? search) {
  final trimmed = search?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  if (trimmed.runes.length > 120) {
    throw ArgumentError('Search must be at most 120 Unicode code points.');
  }
  return trimmed;
}

void _validateRooms(int? count, String name) {
  if (count != null) {
    RangeError.checkValueInInterval(count, 0, 9007199254740991, name);
  }
}

void _validateRange(double? min, double? max, String name) {
  if ((min != null && (!min.isFinite || min < 0)) ||
      (max != null && (!max.isFinite || max < 0)) ||
      (min != null && max != null && min > max)) {
    throw ArgumentError(
      '$name bounds must be finite, nonnegative and ordered.',
    );
  }
}
