import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/core/models/request_cancellation.dart';
import 'package:real_estate_app/features/properties/application/property_details_provider.dart';
import 'package:real_estate_app/features/properties/application/property_providers.dart';
import 'package:real_estate_app/features/properties/domain/property.dart';

import '../../support/memory_locale_preferences.dart';
import 'home_fakes.dart';

void main() {
  late FakeHomeRepository repository;
  late ProviderContainer container;
  late List<Completer<PropertyDetails>> requests;
  late List<RequestCancellation> cancellations;
  final details = propertyDetailsProvider('rental-001');

  setUp(() {
    requests = [];
    cancellations = [];
    repository = FakeHomeRepository(
      loadListings: (_, _) => homePage([]),
      loadOptions: homeTestOptions,
      loadDetails: (id, cancellation) {
        cancellations.add(cancellation);
        final request = Completer<PropertyDetails>();
        requests.add(request);
        return request.future;
      },
    );
    container = ProviderContainer.test(
      overrides: [
        localePreferencesProvider.overrideWithValue(
          MemoryLocalePreferences('en'),
        ),
        propertyRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  test(
    'shares one ID request across listeners and disposes when unused',
    () async {
      final first = container.listen(details, (_, _) {});
      final second = container.listen(details, (_, _) {});
      expect(first.read().isLoading, isTrue);
      expect(repository.detailIds, ['rental-001']);

      requests.single.complete(homeDetails('rental-001'));
      expect((await container.read(details.future)).summary.id, 'rental-001');
      first.close();
      await container.pump();
      expect(cancellations.single.isCancelled, isFalse);
      second.close();
      await container.pump();
      expect(cancellations.single.isCancelled, isTrue);
    },
  );

  test('cancels an in-flight property when its last listener leaves', () async {
    final listener = container.listen(details, (_, _) {});
    listener.close();
    await container.pump();
    expect(cancellations.single.isCancelled, isTrue);
    final next = container.listen(details, (_, _) {});
    expect(requests, hasLength(2));
    requests.first.complete(homeDetails('rental-001'));
    await container.pump();
    expect(next.read().isLoading, isTrue);
    requests.last.complete(homeDetails('rental-001'));
    await container.read(details.future);
  });

  test(
    'reloads on locale change and ignores obsolete success and error',
    () async {
      final listener = container.listen(details, (_, _) {});
      await container
          .read(appLocaleProvider.notifier)
          .select(AppLanguage.arabic);
      await container.pump();
      expect(cancellations.first.isCancelled, isTrue);
      expect(repository.detailIds, ['rental-001', 'rental-001']);
      requests[0].complete(homeDetails('rental-001'));
      await container.pump();
      expect(listener.read().isLoading, isTrue);

      await container
          .read(appLocaleProvider.notifier)
          .select(AppLanguage.english);
      await container.pump();
      await container
          .read(appLocaleProvider.notifier)
          .select(AppLanguage.arabic);
      await container.pump();
      final current = homeDetails('rental-001', arabic: true);
      requests[3].complete(current);
      expect(await container.read(details.future), current);
      requests[1].completeError(const AppFailure(FailureKind.server));
      requests[2].complete(homeDetails('rental-001'));
      await container.pump();
      expect(listener.read().requireValue, current);
    },
  );

  test('rejects a response for a different property', () async {
    final listener = container.listen(details, (_, _) {});
    requests.single.complete(homeDetails('wrong-id'));
    await expectLater(
      container.read(details.future),
      throwsA(
        isA<AppFailure>().having(
          (failure) => failure.kind,
          'kind',
          FailureKind.malformedResponse,
        ),
      ),
    );
    expect(listener.read().hasError, isTrue);
    expect(requests, hasLength(1));
  });
}
