import '../domain/property_query.dart';
import '../domain/property_type.dart';

Map<String, Object> propertyQueryParameters(PropertyQuery query) => {
  'search': ?query.search,
  if (query.types.isNotEmpty)
    'types': PropertyType.values
        .where(query.types.contains)
        .map((type) => type.id)
        .join(','),
  if (query.minPrice case final min?) 'minPrice': _unsignedDecimal(min),
  if (query.maxPrice case final max?) 'maxPrice': _unsignedDecimal(max),
  'minBedrooms': ?query.minBedrooms,
  'minBathrooms': ?query.minBathrooms,
  if (query.minArea case final min?) 'minArea': _unsignedDecimal(min),
  if (query.maxArea case final max?) 'maxArea': _unsignedDecimal(max),
  'featured': ?query.featured,
  'sortBy': query.sortBy.name,
  'sortOrder': query.sortOrder.name,
  'page': query.page,
  'limit': query.limit,
};

// Expand Dart's scientific notation because the API accepts plain decimals only.
String _unsignedDecimal(double value) {
  if (value == 0) return '0';
  final parts = value.toString().split('e');
  final mantissa = parts.first;
  if (parts.length == 1) {
    return mantissa.endsWith('.0')
        ? mantissa.substring(0, mantissa.length - 2)
        : mantissa;
  }
  final decimalPoint = mantissa.indexOf('.');
  final digits = mantissa.replaceAll('.', '');
  final offset =
      (decimalPoint == -1 ? mantissa.length : decimalPoint) +
      int.parse(parts.last);
  if (offset <= 0) return '0.${'0' * -offset}$digits';
  if (offset >= digits.length) return digits.padRight(offset, '0');
  return '${digits.substring(0, offset)}.${digits.substring(offset)}';
}
