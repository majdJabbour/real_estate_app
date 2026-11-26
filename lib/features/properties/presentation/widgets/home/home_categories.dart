import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_controls.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/property_filter_options.dart';
import '../../../domain/property_type.dart';
import 'home_section_message.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({
    required this.insets,
    required this.category,
    required this.options,
    required this.onSelected,
    required this.onRetry,
    super.key,
  });

  final EdgeInsetsGeometry insets;
  final PropertyType? category;
  final AsyncValue<PropertyFilterOptions> options;
  final ValueChanged<PropertyType?> onSelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final types = options.when(
      data: (data) => data.types.where((type) => type.type != null),
      error: (_, _) => const <PropertyTypeOption>[],
      loading: () => const <PropertyTypeOption>[],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          key: const PageStorageKey('home-category-scroll'),
          padding: insets,
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: DesignSpacing.chipGap,
            children: [
              AppChoiceChip(
                label: l10n.all,
                selected: category == null,
                onSelected: (_) => onSelected(null),
              ),
              for (final option in types)
                AppChoiceChip(
                  label: option.label,
                  selected: category == option.type,
                  onSelected: (_) => onSelected(option.type),
                ),
            ],
          ),
        ),
        if (options.isLoading && !options.isRefreshing)
          Semantics(
            liveRegion: true,
            label: l10n.loading,
            child: const SizedBox.shrink(),
          ),
        if (!options.isLoading && options.hasError)
          Padding(
            padding: insets,
            child: homeSectionError(
              context,
              options.error!,
              onRetry,
              message: l10n.categoriesUnavailable,
            ),
          ),
      ],
    );
  }
}
