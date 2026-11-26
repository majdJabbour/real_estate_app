import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/property.dart';
import 'property_card_text.dart';
import 'property_favorite_button.dart';
import 'property_image.dart';
import 'property_rating_badge.dart';

const _gridRadius = 12.0;

class PropertyGridCard extends StatelessWidget {
  const PropertyGridCard({
    required this.property,
    required this.onOpen,
    super.key,
  });

  static const imageAspectRatio = 159 / 154;

  final PropertySummary property;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = BorderRadius.all(Radius.circular(_gridRadius));
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: radius,
        boxShadow: [DesignShadows.card],
      ),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: radius,
        child: Stack(
          children: [
            InkWell(
              onTap: onOpen,
              borderRadius: radius,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(14, 16, 14, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 12,
                  children: [
                    AspectRatio(
                      aspectRatio: imageAspectRatio,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              DesignShape.photoRadius,
                            ),
                            child: PropertyImage(url: property.thumbnail),
                          ),
                          PositionedDirectional(
                            top: 10,
                            end: 12,
                            child: PropertyRatingBadge(rating: property.rating),
                          ),
                        ],
                      ),
                    ),
                    PropertyCardText(property: property),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              end: 0,
              bottom: 4,
              child: PropertyFavoriteButton(propertyId: property.id),
            ),
          ],
        ),
      ),
    );
  }
}
