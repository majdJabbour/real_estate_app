import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../l10n/app_localizations.dart';

class _PreferenceOption extends StatelessWidget {
  const _PreferenceOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.swatch,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? swatch;

  @override
  Widget build(BuildContext context) => Semantics(
    inMutuallyExclusiveGroup: true,
    child: ListTile(
      selected: selected,
      minTileHeight: DesignSize.tapTarget,
      title: Text(label),
      leading: swatch == null
          ? null
          : SizedBox.square(
              dimension: 24,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: swatch,
                  shape: BoxShape.circle,
                ),
              ),
            ),
      trailing: selected ? const Icon(Icons.check_rounded) : null,
      onTap: onTap,
    ),
  );
}

Future<AppLanguage?> showProfileLanguageDialog(
  BuildContext context,
  AppLanguage current,
) {
  final l10n = AppLocalizations.of(context);
  return showDialog<AppLanguage>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(l10n.profileLanguage),
      children: [
        for (final language in AppLanguage.values)
          _PreferenceOption(
            label: _languageName(l10n, language),
            selected: current == language,
            onTap: () => Navigator.pop(context, language),
          ),
      ],
    ),
  );
}

Future<AppThemeVariant?> showProfileThemeDialog(
  BuildContext context,
  AppThemeVariant current,
) {
  final l10n = AppLocalizations.of(context);
  return showDialog<AppThemeVariant>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(l10n.appearance),
      children: [
        for (final variant in AppThemeVariant.values)
          _PreferenceOption(
            label: profileThemeName(l10n, variant),
            selected: current == variant,
            swatch: AppTheme.light(variant).colorScheme.primary,
            onTap: () => Navigator.pop(context, variant),
          ),
      ],
    ),
  );
}

String _languageName(AppLocalizations l10n, AppLanguage language) =>
    switch (language) {
      AppLanguage.english => l10n.englishName,
      AppLanguage.arabic => l10n.arabicName,
    };

String profileThemeName(AppLocalizations l10n, AppThemeVariant variant) =>
    switch (variant) {
      AppThemeVariant.blue => l10n.originalBlue,
      AppThemeVariant.purple => l10n.newPurple,
      AppThemeVariant.orange => l10n.newOrange,
    };
