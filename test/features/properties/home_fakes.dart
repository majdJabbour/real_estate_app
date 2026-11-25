import 'dart:async';

import 'package:real_estate_app/core/models/pagination.dart';
import 'package:real_estate_app/core/models/request_cancellation.dart';
import 'package:real_estate_app/features/properties/domain/property.dart';
import 'package:real_estate_app/features/properties/domain/property_filter_options.dart';
import 'package:real_estate_app/features/properties/domain/property_query.dart';
import 'package:real_estate_app/features/properties/domain/property_repository.dart';

typedef ListingLoader = FutureOr<PaginatedResult<PropertySummary>> Function(
  PropertyQuery query,
  RequestCancellation cancellation,
);

class FakeHomeRepository implements PropertyRepository {
  FakeHomeRepository({required this.loadListings, required this.loadOptions});

  final ListingLoader loadListings;
  final FutureOr<PropertyFilterOptions> Function() loadOptions;
  final queries = <PropertyQuery>[];
  final listingCancellations = <RequestCancellation>[];
  final filterCancellations = <RequestCancellation>[];

  @override
  Future<PaginatedResult<PropertySummary>> getProperties(
    PropertyQuery query, {
    RequestCancellation? cancellation,
  }) async {
    queries.add(query);
    listingCancellations.add(cancellation!);
    return loadListings(query, cancellation);
  }

  @override
  Future<PropertyFilterOptions> getFilterOptions({
    RequestCancellation? cancellation,
  }) async {
    filterCancellations.add(cancellation!);
    return loadOptions();
  }

  @override
  Future<PropertyDetails> getPropertyDetails(
    String propertyId, {
    RequestCancellation? cancellation,
  }) async => throw StateError(
    'Home must open details by ID without requesting details.',
  );
}

PropertySummary homeProperty(
  String id, {
  bool arabic = false,
  bool featured = false,
}) => PropertySummary(
  id: id,
  title: arabic ? 'دوبلكس مشرق بالقرب من الحديقة $id' : 'Sunlit Townhome $id',
  address: arabic
      ? 'شارع الحديقة، أوستن، تكساس'
      : 'Garden District, Austin, TX',
  typeId: 'townhome',
  price: 1275.5,
  currency: 'USD',
  pricingPeriod: 'month',
  rating: 4.8,
  thumbnail: '',
  isFeatured: featured,
);

PaginatedResult<PropertySummary> homePage(Iterable<PropertySummary> items) =>
    PaginatedResult(
      items: items,
      pagination: Pagination(
        page: 1,
        limit: 6,
        total: items.length,
        totalPages: items.isEmpty ? 0 : 1,
        hasNextPage: false,
        hasPreviousPage: false,
      ),
    );

PropertyFilterOptions homeTestOptions({bool arabic = false}) =>
    PropertyFilterOptions(
      price: PropertyPriceOptions(
        bounds: (min: 975, max: 4250),
        currency: 'USD',
        pricingPeriod: 'month',
        histogram: const [],
      ),
      area: (min: 26, max: 238),
      areaUnit: 'sqm',
      bedrooms: (min: 0, max: 5),
      bathrooms: (min: 1, max: 4),
      types: [
        PropertyTypeOption(
          id: 'townhome',
          label: arabic ? 'منزل متلاصق' : 'Townhome',
        ),
        PropertyTypeOption(id: 'condo', label: arabic ? 'شقة تمليك' : 'Condo'),
      ],
    );

PaginatedResult<PropertySummary> resultPage(
  int page,
  List<String> ids, {
  bool more = false,
}) => PaginatedResult(
  items: ids.map(homeProperty),
  pagination: Pagination(
    page: page,
    limit: 20,
    total: 30,
    totalPages: 2,
    hasNextPage: more,
    hasPreviousPage: page > 1,
  ),
);
