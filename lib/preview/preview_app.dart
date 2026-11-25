import 'package:flutter/widget_previews.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../app/app.dart' show appLocalizationDelegates;
import '../core/design_system/app_theme.dart';
import '../core/localization/app_locale.dart';
import '../core/storage/locale_preferences.dart';
import '../l10n/app_localizations.dart';
import 'design_system_preview.dart';

Widget createPreviewApp(LocalePreferences preferences) => ProviderScope(
  overrides: [localePreferencesProvider.overrideWithValue(preferences)],
  child: const DesignPreviewApp(),
);

class DesignPreviewApp extends ConsumerStatefulWidget {
  const DesignPreviewApp({super.key});

  @override
  ConsumerState<DesignPreviewApp> createState() => _DesignPreviewAppState();
}

class _DesignPreviewAppState extends ConsumerState<DesignPreviewApp> {
  AppThemeVariant _variant = AppTheme.defaultVariant;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLocaleProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).designSystemPreview,
      theme: AppTheme.light(_variant),
      themeAnimationDuration: Duration.zero,
      locale: Locale(language.code),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: appLocalizationDelegates,
      home: DesignSystemPreview(
        variant: _variant,
        onVariantChanged: (variant) => setState(() => _variant = variant),
        language: language,
        onLanguageChanged: ref.read(appLocaleProvider.notifier).select,
      ),
    );
  }
}

@Preview(name: 'Design system', size: Size(430, 932))
@Preview(name: 'Compact and enlarged', size: Size(320, 568), textScaleFactor: 2)
@Preview(name: 'Landscape', size: Size(932, 430))
Widget designSystemPreview() => const _WidgetPreview();

class _WidgetPreview extends StatefulWidget {
  const _WidgetPreview();

  @override
  State<_WidgetPreview> createState() => _WidgetPreviewState();
}

class _WidgetPreviewState extends State<_WidgetPreview> {
  late final _preferences = SharedLocalePreferences.load();

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _preferences,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return ErrorWidget('Preview storage is unavailable.');
      }
      final preferences = snapshot.data;
      return preferences == null
          ? const SizedBox.shrink()
          : createPreviewApp(preferences);
    },
  );
}
