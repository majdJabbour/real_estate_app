import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/features/properties/data/property_query_parameters.dart';
import 'package:real_estate_app/features/properties/domain/property_query.dart';
import 'package:real_estate_app/features/properties/domain/property_type.dart';

void main() {
  const defaults = {
    'sortBy': 'createdAt',
    'sortOrder': 'desc',
    'page': 1,
    'limit': 20,
  };

  test('default query and blank search omit unset filters', () {
    expect(propertyQueryParameters(PropertyQuery()), defaults);
    expect(propertyQueryParameters(PropertyQuery(search: ' \n\t ')), defaults);
    expect(PropertyQuery(search: '   '), PropertyQuery());
  });

  test('encodes all API keys in canonical order, retaining false and zero', () {
    final query = PropertyQuery(
      search: '  شقة modern  ',
      types: {PropertyType.condo, PropertyType.apartment},
      minPrice: 0,
      maxPrice: 1500.25,
      minBedrooms: 0,
      minBathrooms: 0,
      minArea: 25.5,
      maxArea: 120,
      featured: false,
      sortBy: PropertySortBy.price,
      sortOrder: SortOrder.asc,
      page: 2,
      limit: 10,
    );
    expect(propertyQueryParameters(query), {
      'search': 'شقة modern',
      'types': 'apartment,condo',
      'minPrice': '0',
      'maxPrice': '1500.25',
      'minBedrooms': 0,
      'minBathrooms': 0,
      'minArea': '25.5',
      'maxArea': '120',
      'featured': false,
      'sortBy': 'price',
      'sortOrder': 'asc',
      'page': 2,
      'limit': 10,
    });
    expect(
      propertyQueryParameters(query.copyWith(featured: null))
          .containsKey('featured'),
      isFalse,
    );
  });

  test('query equality and encoding ignore type insertion order', () {
    final types = {PropertyType.studio, PropertyType.duplex};
    final first = PropertyQuery(
      search: '  home ',
      types: types,
      featured: false,
    );
    final second = PropertyQuery(
      search: 'home',
      types: {PropertyType.duplex, PropertyType.studio},
      featured: false,
    );

    types.clear();
    expect(first, second);
    expect(first.hashCode, second.hashCode);
    expect(
      propertyQueryParameters(first).entries
          .toList()
          .map((entry) => (entry.key, entry.value)),
      propertyQueryParameters(second).entries
          .map((entry) => (entry.key, entry.value)),
    );
    expect(propertyQueryParameters(first)['types'], 'duplex,studio');
    expect(
      first.copyWith(search: ' ', featured: null, page: 3),
      second.copyWith(search: null, featured: null, page: 3),
    );
    expect(first.copyWith(page: 2), isNot(first));
    expect(() => first.types.clear(), throwsUnsupportedError);
  });

  test('uses plain unsigned decimal notation across supported magnitudes', () {
    final encoded = propertyQueryParameters(
      PropertyQuery(minArea: -0.0, minPrice: 1.25e-8, maxPrice: 1.25e21),
    );

    expect(encoded['minArea'], '0');
    expect(encoded['minPrice'], '0.0000000125');
    expect(encoded['maxPrice'], '1250000000000000000000');
  });

  test('accepts maximum pagination and search code points after trimming', () {
    final query = PropertyQuery(
      search: ' ${'🏠' * 120} ',
      page: 1000000,
      limit: 100,
    );
    expect(query.search!.runes.length, 120);
    expect(query.page, 1000000);
    expect(query.limit, 100);
  });

  for (final (reason, create) in <(String, PropertyQuery Function())>[
    ('long search', () => PropertyQuery(search: '🏠' * 121)),
    ('page below minimum', () => PropertyQuery(page: 0)),
    ('page above maximum', () => PropertyQuery(page: 1000001)),
    ('limit below minimum', () => PropertyQuery(limit: 0)),
    ('limit above maximum', () => PropertyQuery(limit: 101)),
    ('negative room count', () => PropertyQuery(minBedrooms: -1)),
    (
      'unsafe integer room count',
      () => PropertyQuery(minBathrooms: 9007199254740992),
    ),
    ('negative price', () => PropertyQuery(minPrice: -1)),
    ('non-finite area', () => PropertyQuery(maxArea: double.infinity)),
    ('reversed prices', () => PropertyQuery(minPrice: 10, maxPrice: 5)),
    (
      'reversed areas via copyWith',
      () => PropertyQuery(minArea: 10).copyWith(maxArea: 5),
    ),
  ]) {
    test('rejects $reason', () => expect(create, throwsArgumentError));
  }
}
