import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../../domain/property.dart';
import 'property_favorite_button.dart';
import 'property_image.dart';
import 'property_rating_badge.dart';
import 'property_price_label.dart';

const _featuredRadius = 20.0;
const _gridRadius = 12.0;

class FeaturedPropertyCard extends StatelessWidget {
  const FeaturedPropertyCard({
    required this.property,
    required this.onOpen,
    required this.isFavorite,
    required this.onFavoritePressed,
    super.key,
  });

  static const referenceWidth = 250.0;
  static const referenceHeight = 340.0;

  final PropertySummary property;
  final VoidCallback onOpen;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;

  static double heightFor(
    BuildContext context,
    double width,
    Iterable<PropertySummary> items,
  ) {
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final language = Localizations.localeOf(context);
    final baseStyle = Theme.of(context).textTheme.bodyMedium!;
    final infoWidth = math.max(1.0, width - 40);

    double textHeight(
      String text,
      TextStyle style,
      double width, [
      int? lines,
    ]) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: baseStyle.merge(style)),
        textDirection: direction,
        textScaler: scaler,
        locale: language,
        maxLines: lines,
        ellipsis: lines == null ? null : '…',
      )..layout(maxWidth: width);
      final height = painter.height;
      painter.dispose();
      return height;
    }

    var height = referenceHeight;
    for (final item in items) {
      final labels =
          textHeight(item.title, _featuredTitle, infoWidth, 2) +
          textHeight(item.address, _featuredAddress, infoWidth, 2) +
          textHeight(
            propertyPriceLabel(context, item),
            _featuredPrice,
            math.max(1.0, infoWidth - 36),
          );
      // Leave room for padding, badge, text gaps and a visible area of photo.
      height = math.max(height, labels + scaler.scale(12) * 1.4 + 180);
    }
    return height.ceilToDouble();
  }

  @override
  Widget build(BuildContext context) => Material(
    borderRadius: BorderRadius.circular(_featuredRadius),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      fit: StackFit.expand,
      children: [
        PropertyImage(url: property.thumbnail),
        const Positioned.fill(
          top: referenceHeight * 0.535,
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: _featuredOverlay),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: PropertyRatingBadge(
                      rating: property.rating,
                      featured: true,
                    ),
                  ),
                  const Spacer(),
                  _PropertyText(property: property, featured: true),
                ],
              ),
            ),
          ),
        ),
        PositionedDirectional(
          end: 3,
          bottom: 8,
          child: PropertyFavoriteButton(
            selected: isFavorite,
            onPressed: onFavoritePressed,
            onPhoto: true,
          ),
        ),
      ],
    ),
  );
}

class PropertyGridCard extends StatelessWidget {
  const PropertyGridCard({
    required this.property,
    required this.onOpen,
    required this.isFavorite,
    required this.onFavoritePressed,
    super.key,
  });

  static const imageAspectRatio = 159 / 154;

  final PropertySummary property;
  final VoidCallback onOpen;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;

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
                    _PropertyText(property: property),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              end: 0,
              bottom: 4,
              child: PropertyFavoriteButton(
                selected: isFavorite,
                onPressed: onFavoritePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyText extends StatelessWidget {
  const _PropertyText({required this.property, this.featured = false});

  final PropertySummary property;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: featured ? 8 : 6,
      children: [
        Text(
          property.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: featured
              ? _featuredTitle
              : TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: scheme.onSurface,
                ),
        ),
        Text(
          property.address,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: featured
              ? _featuredAddress
              : TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 36),
          child: Text(
            propertyPriceLabel(context, property),
            style: featured
                ? _featuredPrice
                : TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: scheme.secondary,
                  ),
          ),
        ),
      ],
    );
  }
}

const _featuredTitle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  height: 1.1,
  color: Colors.white,
);
const _featuredAddress = TextStyle(
  fontSize: 16,
  height: 1.4,
  color: Colors.white,
);
const _featuredPrice = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  height: 1.2,
  color: Colors.white,
);

const _featuredOverlay = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color.fromRGBO(75, 75, 75, 0),
    Color.fromRGBO(68, 68, 68, 0.114),
    Color.fromRGBO(64, 64, 64, 0.18),
    Color.fromRGBO(58, 58, 58, 0.277),
    Color.fromRGBO(54, 54, 54, 0.35),
    Color.fromRGBO(47, 47, 47, 0.463),
    Color.fromRGBO(40, 40, 40, 0.561),
    Color.fromRGBO(32, 32, 32, 0.7),
  ],
  stops: [0, 0.17187, 0.27083, 0.41667, 0.52604, 0.66146, 0.80208, 1],
);

class PropertyListCard extends StatelessWidget {
  const PropertyListCard({
    required this.property,
    required this.onOpen,
    required this.isFavorite,
    required this.onFavoritePressed,
    super.key,
  });

  final PropertySummary property;
  final VoidCallback onOpen;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;

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
              child: PropertyFavoriteButton(
                selected: isFavorite,
                onPressed: onFavoritePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
