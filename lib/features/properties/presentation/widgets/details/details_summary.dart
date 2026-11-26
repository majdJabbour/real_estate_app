import 'package:intl/intl.dart' show NumberFormat;
import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/app_theme.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/property.dart';
import '../../../domain/property_type.dart';
import 'details_rating.dart';

class DetailsSummary extends StatelessWidget {
  const DetailsSummary({required this.details, super.key});

  final PropertyDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final summary = details.summary;
    final area = NumberFormat.decimalPattern(l10n.localeName)
        .format(details.area);
    final propertyType = switch (summary.type) {
      PropertyType.apartment => l10n.detailsTypeApartment,
      PropertyType.townhome => l10n.detailsTypeTownhome,
      PropertyType.house => l10n.detailsTypeHouse,
      PropertyType.condo => l10n.detailsTypeCondo,
      PropertyType.duplex => l10n.detailsTypeDuplex,
      PropertyType.studio => l10n.detailsTypeStudio,
      null => summary.typeId,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: DesignSpacing.medium,
      children: [
        Semantics(
          header: true,
          child: Text(summary.title, style: theme.textTheme.headlineMedium),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: DesignSpacing.small,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppThemeColors.of(context).detailsTint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Text(
                  propertyType,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            DetailsRating(summary.rating),
          ],
        ),
        Wrap(
          spacing: DesignSpacing.large,
          runSpacing: DesignSpacing.small,
          children: [
            _Stat(Icons.bed_outlined, l10n.detailsBedrooms(details.bedrooms)),
            _Stat(
              Icons.bathtub_outlined,
              l10n.detailsBathrooms(details.bathrooms),
            ),
            _Stat(
              Icons.open_in_full,
              details.areaUnit == 'sqm'
                  ? l10n.areaSquareMeters(area)
                  : '$area ${details.areaUnit}',
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: DesignSpacing.small,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppThemeColors.of(context).detailsTint,
          foregroundColor: theme.colorScheme.secondary,
          child: Icon(icon, size: 16),
        ),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
