import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_icon.dart';
import '../../../../core/design_system/design_controls.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/localization/failure_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_providers.dart';
import '../../domain/property_filter_options.dart';
import '../../domain/property_query.dart';
import 'property_range_control.dart';

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
                    data: _fields,
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

  Widget _fields(PropertyFilterOptions options) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final types = options.types.where((option) => option.type != null);
    final number = NumberFormat.decimalPattern(l10n.localeName);
    final price = NumberFormat.simpleCurrency(
      locale: l10n.localeName,
      name: options.price.currency,
    );
    String priceLabel(double value) {
      final amount = value == value.roundToDouble()
          ? (NumberFormat.simpleCurrency(
              locale: l10n.localeName,
              name: options.price.currency,
              decimalDigits: 0,
            )).format(value)
          : price.format(value);
      return options.price.pricingPeriod == 'month'
          ? l10n.propertyMonthlyPrice(amount)
          : amount;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 30,
      children: [
        PropertyRangeControl(
          label: l10n.priceRange,
          bounds: options.price.bounds,
          minimum: _draft.minPrice,
          maximum: _draft.maxPrice,
          formatValue: priceLabel,
          onChanged: (range) =>
              _edit(_draft.copyWith(minPrice: range.min, maxPrice: range.max)),
          buckets: options.price.histogram,
        ),
        if (types.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(l10n.propertyTypeLabel, style: theme.textTheme.labelLarge),
              Wrap(
                spacing: 8,
                children: [
                  for (final type in types)
                    AppChoiceChip(
                      label: type.label,
                      selected: _draft.types.contains(type.type),
                      compact: true,
                      multiSelect: true,
                      onSelected: (on) {
                        final selected = {..._draft.types};
                        if (on) {
                          selected.add(type.type!);
                        } else {
                          selected.remove(type.type);
                        }
                        _edit(_draft.copyWith(types: selected));
                      },
                    ),
                ],
              ),
            ],
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.homeDetailsLabel, style: theme.textTheme.labelLarge),
            const SizedBox(height: 6),
            _RoomCounter(
              label: l10n.bedroomsLabel,
              semantics: l10n.minBedroomsLabel,
              bounds: options.bedrooms,
              value: _draft.minBedrooms ?? 0,
              onChanged: (value) => _edit(
                _draft.copyWith(minBedrooms: value == 0 ? null : value),
              ),
            ),
            const Divider(height: 3),
            _RoomCounter(
              label: l10n.bathroomsLabel,
              semantics: l10n.minBathroomsLabel,
              bounds: options.bathrooms,
              value: _draft.minBathrooms ?? 0,
              onChanged: (value) => _edit(
                _draft.copyWith(minBathrooms: value == 0 ? null : value),
              ),
            ),
          ],
        ),
        PropertyRangeControl(
          label: l10n.buildingSize,
          bounds: options.area,
          minimum: _draft.minArea,
          maximum: _draft.maxArea,
          formatValue: (value) => options.areaUnit == 'sqm'
              ? l10n.areaSquareMeters(number.format(value))
              : '${number.format(value)} ${options.areaUnit}',
          onChanged: (range) =>
              _edit(_draft.copyWith(minArea: range.min, maxArea: range.max)),
        ),
      ],
    );
  }
}

class _RoomCounter extends StatelessWidget {
  const _RoomCounter({
    required this.label,
    required this.semantics,
    required this.bounds,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String semantics;
  final PropertyBounds<int> bounds;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final max = bounds.max;
    final min = bounds.min;
    final increment = value == 0 && min != null && min > 0 ? min : value + 1;
    final decrement = min != null && value <= min ? 0 : value - 1;
    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        _counterButton(
          context,
          l10n.decreaseValue(semantics),
          Icons.remove_rounded,
          value <= 0 ? null : () => onChanged(decrement),
        ),
        Semantics(
          label: semantics,
          value: NumberFormat.decimalPattern(l10n.localeName).format(value),
          excludeSemantics: true,
          child: Text(
            NumberFormat.decimalPattern(l10n.localeName).format(value),
          ),
        ),
        _counterButton(
          context,
          l10n.increaseValue(semantics),
          Icons.add_rounded,
          max == null || increment > max ? null : () => onChanged(increment),
        ),
      ],
    );
  }

  Widget _counterButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback? action,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      onPressed: action,
      tooltip: label,
      icon: CircleAvatar(
        radius: 12,
        backgroundColor: scheme.primaryContainer,
        foregroundColor: action == null
            ? scheme.onSurfaceVariant
            : scheme.secondary,
        child: Icon(icon, size: 16),
      ),
    );
  }
}
