import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/property.dart';
import 'property_favorite_button.dart';
import 'property_image.dart';
import 'property_price_label.dart';
import 'property_rating_badge.dart';

class PropertyListCard extends StatelessWidget {
  const PropertyListCard({
    required this.property,
    required this.onOpen,
    super.key,
  });

  final PropertySummary property;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const radius = BorderRadius.all(
      Radius.circular(DesignShape.listCardRadius),
    );
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: radius,
        boxShadow: [DesignShadows.card],
      ),
      child: Material(
        color: scheme.surface,
        borderRadius: radius,
        child: Stack(
          children: [
            InkWell(
              borderRadius: radius,
              onTap: onOpen,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(14, 14, 18, 14),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final large =
                        MediaQuery.textScalerOf(context).scale(18) > 24 ||
                        constraints.maxWidth < 320;
                    final photo = SizedBox.square(
                      dimension: 100,
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
                            top: 6,
                            end: 6,
                            child: PropertyRatingBadge(
                              rating: property.rating,
                              compact: true,
                            ),
                          ),
                        ],
                      ),
                    );
                    final description = Padding(
                      padding: const EdgeInsetsDirectional.only(end: 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text(
                            property.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface,
                            ),
                          ),
                          Text(
                            property.address,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          if (large)
                            Text(
                              propertyPriceLabel(context, property),
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                                color: scheme.secondary,
                              ),
                            ),
                        ],
                      ),
                    );
                    if (large) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          photo,
                          Expanded(child: description),
                        ],
                      );
                    }
                    return Row(
                      spacing: 14,
                      children: [
                        photo,
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 100),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    bottom: 23,
                                  ),
                                  child: description,
                                ),
                                PositionedDirectional(
                                  end: 0,
                                  bottom: 8,
                                  child: Text(
                                    propertyPriceLabel(context, property),
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.2,
                                      fontWeight: FontWeight.w600,
                                      color: scheme.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            PositionedDirectional(
              top: 10,
              end: 4,
              child: PropertyFavoriteButton(propertyId: property.id),
            ),
          ],
        ),
      ),
    );
  }
}
