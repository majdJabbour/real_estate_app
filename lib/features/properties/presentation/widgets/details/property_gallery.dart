import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../details/property_gallery_viewer.dart';
import '../shared/property_image.dart';
import 'property_photo_button.dart';

class PropertyGallery extends StatelessWidget {
  const PropertyGallery({required this.images, super.key});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (images.isEmpty) return Text(l10n.detailsNoPhotos);

    const visibleCount = 3;
    final count = math.min(visibleCount, images.length);
    final remaining = images.length - count;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(
          118.0,
          (constraints.maxWidth - DesignSpacing.chipGap * 2) / visibleCount,
        );
        final gap = (constraints.maxWidth - size * visibleCount) / 2;
        return Wrap(
          spacing: gap,
          children: [
            for (var i = 0; i < count; i++)
              ClipRRect(
                borderRadius: BorderRadius.circular(DesignShape.photoRadius),
                child: SizedBox.square(
                  dimension: size,
                  child: PropertyPhotoButton(
                    label: i == count - 1 && remaining > 0
                        ? l10n.detailsOpenMorePhotos(remaining)
                        : l10n.detailsOpenPhoto(i + 1, images.length),
                    onTap: () => openPropertyGallery(context, images, i),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PropertyImage(url: images[i]),
                        if (i == count - 1 && remaining > 0)
                          ColoredBox(
                            color: DesignColors.scrim,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  l10n.detailsMorePhotos(remaining),
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
