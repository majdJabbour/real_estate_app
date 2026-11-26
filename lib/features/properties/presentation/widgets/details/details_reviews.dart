import 'package:intl/intl.dart' show DateFormat;
import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/property.dart';
import 'details_named_person.dart';
import 'details_rating.dart';

class DetailsReviews extends StatelessWidget {
  const DetailsReviews({required this.reviews, super.key});

  final List<PropertyReview> reviews;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (reviews.isEmpty) return Text(l10n.detailsNoReviews);

    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd(l10n.localeName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: DesignSpacing.medium,
      children: [
        for (final review in reviews) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: DesignSpacing.chipGap,
            children: [
              DetailsNamedPerson(name: review.reviewerName, size: 40),
              Text(
                review.comment,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: DesignSpacing.medium,
                runSpacing: DesignSpacing.small,
                children: [
                  DetailsRating(review.rating, size: 16),
                  Text(
                    dateFormat.format(review.date),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (review != reviews.last) const Divider(height: 1),
        ],
      ],
    );
  }
}
