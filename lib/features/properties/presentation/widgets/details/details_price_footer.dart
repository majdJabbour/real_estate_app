import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../core/layout/responsive_layout.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/property.dart';
import '../shared/property_favorite_button.dart';
import '../shared/property_price_label.dart';

class DetailsPriceFooter extends StatelessWidget {
  const DetailsPriceFooter({required this.property, super.key});

  final PropertySummary property;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final price = propertyPriceLabel(context, property, includePeriod: false);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: DesignColors.strongTintOpacity,
          ),
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(DesignShape.footerRadius),
        ),
      ),
      child: SafeArea(
        top: false,
        child: AdaptiveContent(
          maxContentWidth: ResponsiveLayout.detailsMaxWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
            child: LayoutBuilder(
              builder: (context, constraints) => Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: DesignSpacing.medium,
                runSpacing: DesignSpacing.small,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      Text(
                        l10n.detailsMonthlyRent,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 12,
                          letterSpacing: 2,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        price,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth * (236 / 380),
                    ),
                    child: FilledButtonTheme(
                      data: FilledButtonThemeData(
                        style: theme.filledButtonTheme.style?.copyWith(
                          minimumSize: const WidgetStatePropertyAll(
                            Size(DesignSize.tapTarget, 50),
                          ),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          textStyle: WidgetStatePropertyAll(
                            theme.textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              height: 22 / 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      child: PropertyFavoriteButton.filled(
                        propertyId: property.id,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
