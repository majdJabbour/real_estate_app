import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../domain/property.dart';
import '../shared/property_card_text.dart';
import '../shared/property_favorite_button.dart';
import '../shared/property_image.dart';
import '../shared/property_price_label.dart';
import '../shared/property_rating_badge.dart';

const _featuredRadius = 20.0;

class FeaturedPropertyCard extends StatelessWidget {
  const FeaturedPropertyCard({
    required this.property,
    required this.onOpen,
    super.key,
  });

  static const referenceWidth = 250.0;
  static const referenceHeight = 340.0;

  final PropertySummary property;
  final VoidCallback onOpen;

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
          textHeight(item.title, PropertyCardText.featuredTitle, infoWidth, 2) +
          textHeight(
            item.address,
            PropertyCardText.featuredAddress,
            infoWidth,
            2,
          ) +
          textHeight(
            propertyPriceLabel(context, item),
            PropertyCardText.featuredPrice,
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
                  PropertyCardText(property: property, featured: true),
                ],
              ),
            ),
          ),
        ),
        PositionedDirectional(
          end: 3,
          bottom: 8,
          child: PropertyFavoriteButton(propertyId: property.id, onPhoto: true),
        ),
      ],
    ),
  );
}

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
