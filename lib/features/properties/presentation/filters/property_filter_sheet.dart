import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_icon.dart';
import '../../../../core/design_system/design_controls.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/localization/failure_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_providers.dart';
import '../../domain/property_query.dart';
import '../widgets/filters/property_filter_fields.dart';

Future<PropertyQuery?> openPropertyFilterSheet(
  BuildContext context,
  PropertyQuery applied,
) => showModalBottomSheet<PropertyQuery>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  useSafeArea: true,
  barrierColor: DesignColors.scrim,
  backgroundColor: Theme.of(context).colorScheme.surface,
  constraints: const BoxConstraints(maxWidth: ResponsiveLayout.filtersMaxWidth),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(DesignShape.sheetRadius),
    ),
  ),
  clipBehavior: Clip.antiAlias,
  builder: (context) => PropertyFilterSheet(applied: applied),
);

class PropertyFilterSheet extends ConsumerStatefulWidget {
  const PropertyFilterSheet({required this.applied, super.key});

  final PropertyQuery applied;

  @override
  ConsumerState<PropertyFilterSheet> createState() =>
      _PropertyFilterSheetState();
}

class _PropertyFilterSheetState extends ConsumerState<PropertyFilterSheet> {
  late PropertyQuery _draft = widget.applied;

  void _edit(PropertyQuery next) => setState(() => _draft = next);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = ref.watch(propertyFilterOptionsProvider);
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: FractionallySizedBox(
        heightFactor: media.size.height < 600 || media.textScaler.scale(16) > 21
            ? 0.96
            : 0.85,
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            children: [
              Row(
                children: [
                  AppIconButton(
                    label: l10n.cancel,
                    icon: const AppIcon(AppIcons.back, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      l10n.filterTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: TextButton(
                      onPressed: () => _edit(
                        widget.applied.copyWith(
                          types: {},
                          minPrice: null,
                          maxPrice: null,
                          minBedrooms: null,
                          minBathrooms: null,
                          minArea: null,
                          maxArea: null,
                        ),
                      ),
                      child: Text(l10n.resetFilters),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('property-filter-scroll'),
                  padding: const EdgeInsets.only(top: 24, bottom: 14),
                  child: options.when(
                    data: (options) => PropertyFilterFields(
                      options: options,
                      draft: _draft,
                      onChanged: (update) => _edit(update(_draft)),
                    ),
                    loading: () => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(
                          semanticsLabel: l10n.loading,
                        ),
                      ),
                    ),
                    error: (error, _) {
                      final text = error is AppFailure
                          ? failureMessage(l10n, error)
                          : l10n.unexpectedError;
                      return Column(
                        children: [
                          if (text != null) Text(text),
                          TextButton(
                            onPressed: () =>
                                ref.invalidate(propertyFilterOptionsProvider),
                            child: Text(l10n.retry),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  label: l10n.filterSet,
                  onPressed: options.hasValue && !options.isLoading
                      ? () => Navigator.of(context).pop(_draft)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
