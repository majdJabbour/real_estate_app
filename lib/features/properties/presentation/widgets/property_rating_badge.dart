import 'package:intl/intl.dart' show NumberFormat;
import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_icon.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

class PropertyRatingBadge extends StatelessWidget {
  const PropertyRatingBadge({
    required this.rating,
    this.featured = false,
    super.key,
  });

  final double rating;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final value = NumberFormat('0.0', l10n.localeName).format(rating);
    return Semantics(
      label: l10n.propertyRating(value),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: DesignColors.ratingSurface,
          borderRadius: BorderRadius.all(Radius.circular(100)),
          boxShadow: [DesignShadows.rating],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: featured ? 10 : 6,
            vertical: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              AppIcon(AppIcons.ratingStar, size: featured ? 14 : 10),
              Text(
                value,
                style: TextStyle(
                  color: DesignColors.ratingInk,
                  fontSize: featured ? 12 : 10,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
