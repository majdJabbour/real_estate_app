import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_controls.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../application/explore_controller.dart';
import '../../../application/home_providers.dart';
import '../../../domain/property_filter_options.dart';
import '../../../domain/property_query.dart';
import '../../../domain/property_type.dart';
import 'explore_results_message.dart';

class ExploreCategories extends ConsumerWidget {
  const ExploreCategories({
    required this.options,
    required this.query,
    required this.insets,
    required this.onSelect,
    super.key,
  });

  final AsyncValue<PropertyFilterOptions> options;
  final PropertyQuery query;
  final EdgeInsetsGeometry insets;
  final ValueChanged<PropertyType?> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final types = options.isReloading ? null : options.value?.types;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          key: const PageStorageKey('explore-categories'),
          scrollDirection: Axis.horizontal,
          padding: insets,
          child: Row(
            spacing: DesignSpacing.chipGap,
            children: [
              AppChoiceChip(
                label: l10n.all,
                selected: query.types.isEmpty,
                onSelected: (_) => onSelect(null),
              ),
              for (final type in types ?? const <PropertyTypeOption>[])
                if (type.type case final id?)
                  AppChoiceChip(
                    label: type.label,
                    selected: query.types.contains(id),
                    onSelected: (_) => onSelect(id),
                  ),
            ],
          ),
        ),
        if (query.featured == true)
          Padding(
            padding: insets,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: InputChip(
                label: Text(l10n.featuredOnly),
                deleteButtonTooltipMessage: l10n.clearFeaturedFilter,
                onDeleted: () => unawaited(
                  ref
                      .read(exploreControllerProvider.notifier)
                      .setQuery(query.copyWith(featured: null)),
                ),
              ),
            ),
          ),
        if (!options.isLoading && options.hasError)
          Padding(
            padding: insets,
            child: ExploreResultsMessage(
              message: l10n.categoriesUnavailable,
              action: l10n.retry,
              retry: () => ref.invalidate(propertyFilterOptionsProvider),
            ),
          ),
      ],
    );
  }
}
