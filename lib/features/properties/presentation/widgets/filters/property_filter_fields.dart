import 'package:intl/intl.dart' show NumberFormat;
import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_controls.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/property_filter_options.dart';
import '../../../domain/property_query.dart';
import 'property_range_control.dart';

class PropertyFilterFields extends StatelessWidget {
  const PropertyFilterFields({
    required this.options,
    required this.draft,
    required this.onChanged,
    super.key,
  });

  final PropertyFilterOptions options;
  final PropertyQuery draft;
  final ValueChanged<PropertyQuery Function(PropertyQuery)> onChanged;

  @override
  Widget build(BuildContext context) {
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
          minimum: draft.minPrice,
          maximum: draft.maxPrice,
          formatValue: priceLabel,
          onChanged: (range) => onChanged(
            (current) =>
                current.copyWith(minPrice: range.min, maxPrice: range.max),
          ),
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
                      selected: draft.types.contains(type.type),
                      compact: true,
                      multiSelect: true,
                      onSelected: (on) => onChanged((current) {
                        final selected = {...current.types};
                        if (on) {
                          selected.add(type.type!);
                        } else {
                          selected.remove(type.type);
                        }
                        return current.copyWith(types: selected);
                      }),
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
              value: draft.minBedrooms ?? 0,
              onChanged: (value) => onChanged(
                (current) =>
                    current.copyWith(minBedrooms: value == 0 ? null : value),
              ),
            ),
            const Divider(height: 3),
            _RoomCounter(
              label: l10n.bathroomsLabel,
              semantics: l10n.minBathroomsLabel,
              bounds: options.bathrooms,
              value: draft.minBathrooms ?? 0,
              onChanged: (value) => onChanged(
                (current) =>
                    current.copyWith(minBathrooms: value == 0 ? null : value),
              ),
            ),
          ],
        ),
        PropertyRangeControl(
          label: l10n.buildingSize,
          bounds: options.area,
          minimum: draft.minArea,
          maximum: draft.maxArea,
          formatValue: (value) => options.areaUnit == 'sqm'
              ? l10n.areaSquareMeters(number.format(value))
              : '${number.format(value)} ${options.areaUnit}',
          onChanged: (range) => onChanged(
            (current) =>
                current.copyWith(minArea: range.min, maxArea: range.max),
          ),
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
