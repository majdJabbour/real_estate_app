import 'package:intl/intl.dart' show NumberFormat;
import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/app_icon.dart';
import '../../../../../l10n/app_localizations.dart';

class DetailsRating extends StatelessWidget {
  const DetailsRating(this.rating, {this.size = 20, super.key});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final value = NumberFormat('0.0', l10n.localeName).format(rating);
    return Semantics(
      label: l10n.propertyRating(value),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          AppIcon(AppIcons.ratingStar, size: size),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
