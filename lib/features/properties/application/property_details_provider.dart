import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/models/request_cancellation.dart';
import '../domain/property.dart';
import 'property_providers.dart';

part 'property_details_provider.g.dart';

@Riverpod(retry: _manualRetry)
Future<PropertyDetails> propertyDetails(Ref ref, String propertyId) async {
  final language = ref.watch(appLocaleProvider);
  final repository = ref.watch(propertyRepositoryProvider);
  final cancellation = RequestCancellation();
  ref.onDispose(cancellation.cancel);

  final details = await repository.getPropertyDetails(
    propertyId,
    cancellation: cancellation,
  );
  if (cancellation.isCancelled ||
      !ref.mounted ||
      ref.read(appLocaleProvider) != language) {
    throw const AppFailure(FailureKind.cancelled);
  }
  if (details.summary.id != propertyId) {
    throw const AppFailure(FailureKind.malformedResponse);
  }
  return details;
}

Duration? _manualRetry(int _, Object _) => null;
