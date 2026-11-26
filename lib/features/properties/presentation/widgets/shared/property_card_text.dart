import 'package:material_ui/material_ui.dart';

import '../../../domain/property.dart';
import 'property_price_label.dart';

class PropertyCardText extends StatelessWidget {
  const PropertyCardText({
    required this.property,
    this.featured = false,
    super.key,
  });

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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: featured
              ? featuredTitle
              : TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: scheme.onSurface,
                ),
        ),
        Text(
          property.address,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: featured
              ? featuredAddress
              : TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 36),
          child: Text(
            propertyPriceLabel(context, property),
            style: featured
                ? featuredPrice
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

  static const featuredTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: Colors.white,
  );
  static const featuredAddress = TextStyle(
    fontSize: 16,
    height: 1.4,
    color: Colors.white,
  );
  static const featuredPrice = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.white,
  );
}
