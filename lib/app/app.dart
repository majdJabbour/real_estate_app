import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../core/design_system/app_theme.dart';
import '../core/localization/app_locale.dart';
import '../core/storage/locale_preferences.dart';
import '../l10n/app_localizations.dart';
import 'navigation/app_router.dart';

const appLocalizationDelegates = [
  AppLocalizations.delegate,
  // material_ui defines its own Material and Cupertino localization types.
  ...GlobalMaterialLocalizations.delegates,
];

Widget createApp(LocalePreferences preferences) => ProviderScope(
  overrides: [localePreferencesProvider.overrideWithValue(preferences)],
  child: const RealEstateApp(),
);

class RealEstateApp extends ConsumerWidget {
  const RealEstateApp({this.variant = AppTheme.defaultVariant, super.key});

  final AppThemeVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    theme: AppTheme.light(variant),
    themeAnimationDuration: Duration.zero,
    locale: Locale(ref.watch(appLocaleProvider).code),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: appLocalizationDelegates,
    routerConfig: ref.watch(appRouterProvider),
  );
}
