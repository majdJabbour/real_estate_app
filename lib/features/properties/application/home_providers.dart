import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/localization/app_locale.dart';
import '../../../core/models/request_cancellation.dart';
import '../domain/property.dart';
import '../domain/property_filter_options.dart';
import '../domain/property_query.dart';
import '../domain/property_type.dart';
import 'property_providers.dart';

part 'home_providers.g.dart';

@riverpod
class HomeCategory extends _$HomeCategory {
  @override
  PropertyType? build() => null;

  void select(PropertyType? type) => state = type;
}

@Riverpod(retry: _manualRetry)
Future<List<PropertySummary>> homeFeatured(Ref ref) =>
    _fetchListings(ref, PropertyQuery(featured: true, limit: 5));

@Riverpod(retry: _manualRetry)
Future<List<PropertySummary>> homeRecommendations(Ref ref) {
  final category = ref.watch(homeCategoryProvider);
  return _fetchListings(ref, PropertyQuery(types: {?category}, limit: 6));
}

@Riverpod(retry: _manualRetry)
Future<PropertyFilterOptions> propertyFilterOptions(Ref ref) {
  ref.watch(appLocaleProvider);
  return ref
      .watch(propertyRepositoryProvider)
      .getFilterOptions(cancellation: _cancellation(ref));
}

Future<List<PropertySummary>> _fetchListings(
  Ref ref,
  PropertyQuery query,
) async {
  ref.watch(appLocaleProvider);
  final page = await ref
      .watch(propertyRepositoryProvider)
      .getProperties(query, cancellation: _cancellation(ref));
  return page.items;
}

RequestCancellation _cancellation(Ref ref) {
  final cancellation = RequestCancellation();
  ref.onDispose(cancellation.cancel);
  return cancellation;
}

Duration? _manualRetry(int _, Object _) => null;
