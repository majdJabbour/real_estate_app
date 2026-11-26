import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/app/app.dart';
import 'package:real_estate_app/app/navigation/app_router.dart';
import 'package:real_estate_app/core/design_system/app_theme.dart';
import 'package:real_estate_app/core/design_system/app_theme_preference.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/core/models/pagination.dart';
import 'package:real_estate_app/core/models/request_cancellation.dart';
import 'package:real_estate_app/core/storage/locale_preferences.dart';
import 'package:real_estate_app/features/authentication/application/authentication_providers.dart';
import 'package:real_estate_app/features/authentication/domain/authentication_repository.dart';
import 'package:real_estate_app/features/authentication/presentation/auth_screen.dart';
import 'package:real_estate_app/features/favorites/application/favorites_providers.dart';
import 'package:real_estate_app/features/favorites/presentation/favorites_screen.dart';
import 'package:real_estate_app/features/profile/presentation/profile_screen.dart';
import 'package:real_estate_app/features/properties/application/explore_controller.dart';
import 'package:real_estate_app/features/properties/application/property_providers.dart';
import 'package:real_estate_app/features/properties/domain/property.dart';
import 'package:real_estate_app/features/properties/domain/property_repository.dart';
import 'package:real_estate_app/features/properties/presentation/details/property_details_screen.dart';
import 'package:real_estate_app/l10n/app_localizations.dart';

import '../../support/memory_locale_preferences.dart';
import '../authentication/fake_authentication.dart';
import '../properties/home_fakes.dart';
import 'fake_favorites.dart';

class _Preferences implements ThemePreferences {
  _Preferences([this.theme]);

  String? theme;
  bool fails = false;

  @override
  String? readThemeId() => theme;

  @override
  Future<void> writeThemeId(String value) async {
    if (fails) throw StateError('Fixture write failure');
    theme = value;
  }
}

class _Profile implements ProfileRepository {
  _Profile(this.auth, this.reject);

  final FakeAuthentication auth;
  final bool reject;

  @override
  Future<AuthenticatedUser> load(RequestCancellation cancellation) async {
    if (reject) throw const AppFailure(FailureKind.unauthorized);
    return AuthenticatedUser(
      id: auth.user!.id,
      name: 'Verified fixture',
      email: 'fixture@example.test',
    );
  }
}

class _AppFixture {
  _AppFixture({
    AuthenticatedUser? user = firstUser,
    this.language = 'en',
    this.rejectProfile = false,
    String? theme,
  }) : auth = FakeAuthentication(user: user),
       preferences = _Preferences(theme);

  final FakeAuthentication auth;
  final FakeFavorites favorites = FakeFavorites();
  final FakeHomeRepository properties = FakeHomeRepository(
    loadListings: (_, _) => homePage([homeProperty('one')]),
    loadOptions: () => homeTestOptions(),
  );
  final _Preferences preferences;
  final String language;
  final bool rejectProfile;

  Future<ProviderContainer> pump(WidgetTester tester) async {
    addTearDown(auth.close);
    final container = ProviderContainer.test(
      overrides: [
        authenticationInitializerProvider.overrideWithValue(() async => auth),
        favoritesRepositoryProvider.overrideWithValue(favorites),
        propertyRepositoryProvider.overrideWithValue(properties),
        profileRepositoryProvider.overrideWithValue(
          _Profile(auth, rejectProfile),
        ),
        localePreferencesProvider.overrideWithValue(
          MemoryLocalePreferences(language),
        ),
        themePreferencesProvider.overrideWithValue(preferences),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const RealEstateApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'Profile opens Favorites, which loads, retries, navigates and removes',
    (tester) async {
      final fixture = _AppFixture();
      fixture.favorites.idsByAccount['first'] = {'one', 'orphan'};
      final firstRead = Completer<PaginatedResult<PropertySummary>>();
      fixture.favorites.loadPage = (_, _) => firstRead.future;
      final container = await fixture.pump(tester);

      await _tap(tester, find.text('Profile').last);
      expect(find.text('Verified fixture'), findsOneWidget);
      expect(find.text('fixture@example.test'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
      await tester.ensureVisible(find.text('My Favorites'));
      await tester.tap(find.text('My Favorites'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(FavoritesScreen), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      firstRead.completeError(const AppFailure(FailureKind.connection));
      await tester.pumpAndSettle();

      fixture.favorites.loadPage = (_, _) => homePage([
        if (fixture.favorites.idsByAccount['first']!.contains('one'))
          homeProperty('one'),
      ]);
      await _tap(tester, find.text('Retry'));
      expect(find.textContaining('Sunlit Townhome one'), findsOneWidget);
      expect(find.textContaining('orphan'), findsNothing);

      await _tap(tester, find.textContaining('Sunlit Townhome one'));
      expect(find.byType(PropertyDetailsScreen), findsOneWidget);
      expect(find.byTooltip('Remove from favorites'), findsOneWidget);
      container.read(appRouterProvider).pop();
      await tester.pumpAndSettle();

      await _tap(tester, find.byTooltip('Remove from favorites'));
      expect(find.text('No favorite properties yet.'), findsOneWidget);
      expect(fixture.favorites.idReads, hasLength(1));
      expect(fixture.favorites.writes.single.$2, 'one');
      expect(fixture.favorites.idsByAccount['first'], {'orphan'});
      await tester.drag(find.byType(ListView), const Offset(0, 350));
      await tester.pumpAndSettle();
      expect(fixture.favorites.pageReads, hasLength(4));
    },
  );

  testWidgets(
    'membership is shared across Home, Explore and Details without public refetch',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final fixture = _AppFixture();
      final container = await fixture.pump(tester);
      final router = container.read(appRouterProvider);
      final initialReads = fixture.properties.queries.length;
      await _tap(tester, find.byTooltip('Add to favorites').first);
      expect(find.byTooltip('Remove from favorites'), findsWidgets);
      expect(fixture.properties.queries, hasLength(initialReads));

      await _tap(tester, find.text('Explore').last);
      expect(find.byTooltip('Remove from favorites'), findsOneWidget);
      await _tap(tester, find.text('Sunlit Townhome one'));
      expect(find.byType(PropertyDetailsScreen), findsOneWidget);
      final exploreReads = fixture.properties.queries.length;
      await _tap(
        tester,
        find.widgetWithText(FilledButton, 'Remove from favorites'),
      );
      expect(find.byTooltip('Add to favorites'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Add to favorites'),
        findsOneWidget,
      );
      router.pop();
      await tester.pumpAndSettle();
      expect(find.byTooltip('Add to favorites'), findsOneWidget);
      expect(fixture.properties.queries, hasLength(exploreReads));
      expect(fixture.favorites.idReads, hasLength(1));
    },
  );

  testWidgets('guest Details footer opens contextual sign-in without writing', (
    tester,
  ) async {
    final fixture = _AppFixture(user: null);
    final container = await fixture.pump(tester);
    container.read(appRouterProvider).go('/properties/one');
    await tester.pumpAndSettle();
    final signIn = find.byType(PropertyDetailsScreen);
    expect(signIn, findsOneWidget);
    await _tap(
      tester,
      find.widgetWithText(FilledButton, 'Sign in to save properties'),
    );
    await _tap(
      tester,
      find.widgetWithText(FilledButton, 'Sign in with Google'),
    );
    expect(find.byType(AuthScreen), findsOneWidget);
    await _tap(tester, find.text('Cancel'));
    expect(signIn, findsOneWidget);
    expect(fixture.favorites.writes, isEmpty);
  });

  testWidgets(
    'guest Favorites preserves its origin and makes no protected calls until sign-in',
    (tester) async {
      final fixture = _AppFixture(user: null);
      final container = await fixture.pump(tester);
      final router = container.read(appRouterProvider);
      router.go('/profile');
      await tester.pumpAndSettle();
      expect(find.text('Guest'), findsOneWidget);
      await _tap(tester, find.text('My Favorites'));
      expect(fixture.favorites.pageReads, isEmpty);
      expect(find.text('Favorites require sign-in.'), findsOneWidget);
      await _tap(tester, find.text('Sign in with Google'));
      expect(find.byType(AuthScreen), findsOneWidget);
      await _tap(tester, find.text('Cancel'));
      expect(find.byType(FavoritesScreen), findsOneWidget);
      expect(fixture.favorites.idReads, isEmpty);

      await _tap(tester, find.text('Sign in with Google'));
      await _tap(tester, find.text('Sign in with Google'));
      expect(find.byType(AuthScreen), findsNothing);
      expect(find.byType(FavoritesScreen), findsOneWidget);
      expect(find.text('No favorite properties yet.'), findsOneWidget);
      expect(fixture.favorites.writes, isEmpty);
    },
  );

  testWidgets(
    'Favorites offers only server pagination and keeps result order',
    (tester) async {
      final fixture = _AppFixture();
      fixture.favorites.idsByAccount['first'] = {'z', 'a', 'b'};
      fixture.favorites.loadPage = (account, page) {
        final hasSecondPage = fixture.favorites.idsByAccount[account]!.contains(
          'b',
        );
        return PaginatedResult(
          items: [
            if (page == 1) ...[
              homeProperty('z'),
              homeProperty('a'),
            ] else if (hasSecondPage)
              homeProperty('b'),
          ],
          pagination: Pagination(
            page: page,
            limit: 2,
            total: hasSecondPage ? 3 : 2,
            totalPages: hasSecondPage ? 2 : 1,
            hasNextPage: page == 1 && hasSecondPage,
            hasPreviousPage: page == 2,
          ),
        );
      };
      final container = await fixture.pump(tester);
      container.read(appRouterProvider).go('/favorites');
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Sunlit Townhome z')).dy,
        lessThan(tester.getTopLeft(find.text('Sunlit Townhome a')).dy),
      );
      await _tap(tester, find.text('Next page'));
      expect(find.text('Sunlit Townhome b'), findsOneWidget);
      expect(find.text('Next page'), findsNothing);
      await _tap(tester, find.byTooltip('Remove from favorites'));
      expect(find.text('There are no favorites on this page.'), findsOneWidget);
      await _tap(tester, find.text('Previous page'));
      expect(find.text('Sunlit Townhome z'), findsOneWidget);
      expect(fixture.favorites.pageReads.map((entry) => entry.$2), [
        1,
        2,
        2,
        1,
      ]);
    },
  );

  testWidgets(
    'runtime palette change preserves router, active Explore query and session',
    (tester) async {
      final fixture = _AppFixture();
      fixture.favorites.idsByAccount['first'] = {'one'};
      final container = await fixture.pump(tester);
      final router = container.read(appRouterProvider);
      await _tap(tester, find.text('Explore').last);
      final field = find.byType(TextField).first;
      await tester.enterText(field, 'garden');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Profile').last);
      final reads = fixture.properties.queries.length;
      await _tap(tester, find.text('Appearance'));
      await _tap(tester, find.text('New Purple'));
      expect(fixture.preferences.theme, 'purple');
      expect(
        Theme.of(tester.element(find.byType(ProfileScreen)))
            .colorScheme
            .primary,
        AppTheme.light(AppThemeVariant.purple).colorScheme.primary,
      );
      expect(identical(router, container.read(appRouterProvider)), isTrue);
      expect(container.read(exploreControllerProvider).query.search, 'garden');
      expect(
        container.read(authenticationSessionProvider).requireValue,
        firstUser,
      );
      expect(
        container.read(favoriteMembershipControllerProvider).requireValue?.ids,
        {'one'},
      );
      await _tap(tester, find.text('Explore').last);
      expect(tester.widget<TextField>(field).controller?.text, 'garden');
      expect(fixture.properties.queries, hasLength(reads));
      expect(fixture.favorites.idReads, hasLength(1));
    },
  );

  testWidgets(
    'preference save failure remains visible and selecting again can persist',
    (tester) async {
      final fixture = _AppFixture();
      fixture.preferences.fails = true;
      final container = await fixture.pump(tester);
      container.read(appRouterProvider).go('/profile');
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Appearance'));
      await _tap(tester, find.text('New Orange'));
      expect(find.text('Could not save the app appearance.'), findsOneWidget);
      expect(
        container.read(appThemePreferenceProvider),
        AppThemeVariant.orange,
      );
      expect(fixture.preferences.theme, isNull);
      fixture.preferences.fails = false;
      await _tap(tester, find.text('Appearance'));
      await _tap(tester, find.text('New Orange').last);
      expect(fixture.preferences.theme, 'orange');
    },
  );

  for (final (size, language, palette) in [
    (const Size(320, 620), 'ar', 'blue'),
    (const Size(390, 780), 'en', 'purple'),
    (const Size(852, 390), 'ar', 'orange'),
    (const Size(768, 900), 'en', 'blue'),
  ]) {
    testWidgets(
      'Profile fits ${size.width} × ${size.height}, $language, $palette at 2×',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(() async {
          tester.platformDispatcher.clearTextScaleFactorTestValue();
          await tester.binding.setSurfaceSize(null);
        });
        final fixture = _AppFixture(
          rejectProfile: true,
          language: language,
          theme: palette,
          user: const AuthenticatedUser(id: 'first', name: 'Firebase fixture'),
        );
        final container = await fixture.pump(tester);
        container.read(appRouterProvider).go('/profile');
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(ProfileScreen));
        final l10n = AppLocalizations.of(context);
        expect(
          Directionality.of(tester.element(find.text(l10n.myFavorites))),
          language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        );
        expect(find.text('Firebase fixture'), findsOneWidget);
        expect(find.text(l10n.profileUnauthorized), findsOneWidget);
        await _tap(tester, find.text(l10n.appearance));
        expect(find.text(l10n.newOrange), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final (locale, labels, message) in [
    (
      'en',
      [
        'My Booking',
        'Payments',
        'Profile',
        'Notification',
        'Security',
        'Language',
        'Help Center',
        'Invite Friends',
        'Logout',
      ],
      'This feature is currently unavailable.',
    ),
    (
      'ar',
      [
        'حجوزاتي',
        'المدفوعات',
        'الملف الشخصي',
        'الإشعارات',
        'الأمان',
        'اللغة',
        'مركز المساعدة',
        'دعوة الأصدقاء',
        'تسجيل الخروج',
      ],
      'هذه الميزة غير متاحة حالياً.',
    ),
  ]) {
    testWidgets(
      'Profile keeps the original menu order and feedback in $locale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 560));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final container = await _AppFixture(language: locale).pump(tester);
        final router = container.read(appRouterProvider);
        router.go('/profile');
        await tester.pumpAndSettle();

        final rows = find.descendant(
          of: find.byType(ProfileScreen),
          matching: find.byType(ListTile),
        );
        expect(
          tester
              .widgetList<ListTile>(rows)
              .take(9)
              .map((row) => (row.title! as Text).data),
          labels,
        );
        final invite = find.widgetWithText(ListTile, labels[7]);
        expect(invite.hitTestable(), findsNothing);
        await _tap(tester, invite);
        final row = tester.widget<ListTile>(invite);
        final leadingX = tester.getCenter(find.byWidget(row.leading!)).dx;
        final trailingX = tester
            .getCenter(
              find.descendant(
                of: invite,
                matching: find.byWidget(row.trailing!),
              ),
            )
            .dx;
        expect(leadingX < trailingX, locale == 'en');
        expect(find.text(message), findsOneWidget);
        expect(router.routerDelegate.currentConfiguration.uri.path, '/profile');
        expect(tester.takeException(), isNull);
      },
    );
  }

  test(
    'theme restoration uses stable IDs and defaults for unknown values',
    () async {
      final preferences = _Preferences('malformed');
      ProviderContainer fresh() => ProviderContainer.test(
        overrides: [themePreferencesProvider.overrideWithValue(preferences)],
      );
      final first = fresh();
      expect(first.read(appThemePreferenceProvider), AppThemeVariant.blue);
      await first
          .read(appThemePreferenceProvider.notifier)
          .select(AppThemeVariant.purple);
      expect(preferences.theme, 'purple');
      expect(fresh().read(appThemePreferenceProvider), AppThemeVariant.purple);
      preferences.theme = null;
      expect(fresh().read(appThemePreferenceProvider), AppThemeVariant.blue);
    },
  );
}
