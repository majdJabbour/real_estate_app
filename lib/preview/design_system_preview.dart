import 'package:material_ui/material_ui.dart';

import '../core/design_system/app_theme.dart';
import '../core/design_system/design_controls.dart';
import '../core/design_system/design_tokens.dart';
import '../core/layout/responsive_layout.dart';
import '../core/localization/app_locale.dart';
import '../l10n/app_localizations.dart';
import 'responsive_preview.dart';

class DesignSystemPreview extends StatefulWidget {
  const DesignSystemPreview({
    required this.variant,
    required this.onVariantChanged,
    required this.language,
    required this.onLanguageChanged,
    super.key,
  });

  final AppThemeVariant variant;
  final ValueChanged<AppThemeVariant> onVariantChanged;
  final AppLanguage language;
  final Future<void> Function(AppLanguage) onLanguageChanged;

  @override
  State<DesignSystemPreview> createState() => _DesignSystemPreviewState();
}

class _DesignSystemPreviewState extends State<DesignSystemPreview> {
  bool _apartments = false;
  bool _favorite = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = AppThemeColors.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    void showMessage(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    Future<void> switchLanguage() async {
      try {
        await widget.onLanguageChanged(
          widget.language == AppLanguage.english
              ? AppLanguage.arabic
              : AppLanguage.english,
        );
      } catch (_) {
        if (context.mounted) showMessage(l10n.languageSaveError);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final layout = ResponsiveLayout.fromConstraints(constraints);
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: DesignSpacing.large),
                  sliver: SliverToBoxAdapter(
                    child: AdaptiveContent(
                      maxContentWidth: ResponsiveLayout.filtersMaxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: DesignSpacing.medium,
                        children: [
                          Text(l10n.designSystem, style: text.headlineLarge),
                          Text(l10n.previewIntro, style: text.bodyMedium),
                          Wrap(
                            spacing: DesignSpacing.small,
                            runSpacing: DesignSpacing.xSmall,
                            children: [
                              for (final variant in AppThemeVariant.values)
                                AppChoiceChip(
                                  label: switch (variant) {
                                    AppThemeVariant.blue => l10n.blue,
                                    AppThemeVariant.purple => l10n.purple,
                                    AppThemeVariant.orange => l10n.orange,
                                  },
                                  selected: widget.variant == variant,
                                  onSelected: (selected) {
                                    if (selected) {
                                      widget.onVariantChanged(variant);
                                    }
                                  },
                                ),
                              Tooltip(
                                message: l10n.switchLanguage,
                                child: TextButton(
                                  onPressed: switchLanguage,
                                  child: Text(
                                    widget.language == AppLanguage.english
                                        ? l10n.arabicName
                                        : l10n.englishName,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(l10n.previewHeading, style: text.titleLarge),
                          Text(l10n.previewDescription, style: text.bodyLarge),
                          AppSearchField(
                            hintText: l10n.searchProperties,
                            onSubmitted: (query) => showMessage(query),
                            filter: (
                              label: l10n.filters,
                              onPressed: () =>
                                  showMessage(l10n.previewFilterAction),
                            ),
                          ),
                          Wrap(
                            spacing: DesignSpacing.chipWrapGap,
                            runSpacing: DesignSpacing.xSmall,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              AppChoiceChip(
                                label: l10n.all,
                                compact: true,
                                selected: !_apartments,
                                onSelected: (selected) =>
                                    setState(() => _apartments = !selected),
                              ),
                              AppChoiceChip(
                                label: l10n.apartments,
                                compact: true,
                                selected: _apartments,
                                onSelected: (selected) =>
                                    setState(() => _apartments = selected),
                              ),
                              AppIconButton(
                                label: l10n.favorite,
                                isSelected: _favorite,
                                onPressed: () =>
                                    setState(() => _favorite = !_favorite),
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: colors.favoriteOutline,
                                ),
                                selectedIcon: Icon(
                                  Icons.favorite,
                                  color: colors.favoriteSelected,
                                ),
                              ),
                              AppIconButton(
                                label: l10n.notificationsUnavailable,
                                icon: const Icon(Icons.notifications_none),
                                onPressed: null,
                              ),
                            ],
                          ),
                          AppPrimaryButton(
                            label: l10n.applyFilters,
                            onPressed: () =>
                                showMessage(l10n.previewFiltersApplied),
                          ),
                          AppPrimaryButton(
                            label: l10n.unavailable,
                            onPressed: null,
                          ),
                          AppPrimaryButton(
                            label: l10n.applyFilters,
                            loadingLabel: l10n.applyingFilters,
                            onPressed: null,
                          ),
                          Wrap(
                            spacing: DesignSpacing.small,
                            runSpacing: DesignSpacing.small,
                            children: [
                              _SemanticSample(
                                label: l10n.unexpectedError,
                                icon: Icons.error_outline,
                                ink: scheme.onErrorContainer,
                                surface: scheme.errorContainer,
                              ),
                              _SemanticSample(
                                label: l10n.saved,
                                icon: Icons.check_circle_outline,
                                ink: colors.success,
                                surface: colors.successSurface,
                              ),
                              _SemanticSample(
                                label: l10n.imageUnavailable,
                                icon: Icons.image_not_supported_outlined,
                                ink: colors.placeholderInk,
                                surface: colors.placeholderSurface,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ResponsivePreview(
                  layout: layout,
                  viewportHeight: constraints.maxHeight,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SemanticSample extends StatelessWidget {
  const _SemanticSample({
    required this.label,
    required this.icon,
    required this.ink,
    required this.surface,
  });

  final String label;
  final IconData icon;
  final Color ink;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(DesignShape.searchRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignSpacing.small),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: DesignSize.searchIcon, color: ink),
            const SizedBox(width: DesignSpacing.small),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!
                    .copyWith(color: ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
