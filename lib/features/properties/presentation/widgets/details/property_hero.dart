import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../details/property_gallery_viewer.dart';
import '../shared/property_image.dart';
import 'property_photo_button.dart';

class PropertyHero extends StatefulWidget {
  const PropertyHero({
    required this.images,
    required this.initialIndex,
    required this.onPageChanged,
    required this.actions,
    super.key,
  });

  final List<String> images;
  final int initialIndex;
  final ValueChanged<int> onPageChanged;
  final Widget actions;

  @override
  State<PropertyHero> createState() => _PropertyHeroState();
}

class _PropertyHeroState extends State<PropertyHero> {
  late int _index = widget.initialIndex.clamp(
    0,
    math.max(0, widget.images.length - 1),
  );
  late final _pages = PageController(initialPage: _index, keepPage: false);

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final images = widget.images;
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = math.min(
          460.0,
          math.min(
            constraints.maxWidth * 460 / 428,
            MediaQuery.sizeOf(context).height * 0.66,
          ),
        );
        return SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (images.isEmpty)
                Semantics(
                  label: l10n.detailsNoPhotos,
                  excludeSemantics: true,
                  child: const PropertyImage(url: null),
                )
              else
                PageView.builder(
                  controller: _pages,
                  itemCount: images.length,
                  allowImplicitScrolling: true,
                  physics: images.length == 1
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  onPageChanged: (index) {
                    setState(() => _index = index);
                    widget.onPageChanged(index);
                  },
                  itemBuilder: (context, index) => PropertyPhotoButton(
                    label: l10n.detailsOpenPhoto(index + 1, images.length),
                    onTap: () => openPropertyGallery(context, images, index),
                    child: PropertyImage(url: images[index]),
                  ),
                ),
              if (images.length > 1)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Semantics(
                      label: l10n.detailsPhotoPosition(
                        _index + 1,
                        images.length,
                      ),
                      liveRegion: true,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: images.length > 12 ? Colors.black54 : null,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: images.length <= 12
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 6,
                                  children: [
                                    for (var i = 0; i < images.length; i++)
                                      Container(
                                        width: i == _index ? 32 : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: i == _index
                                              ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : ExcludeSemantics(
                                  child: Text(
                                    l10n.detailsPhotoPosition(
                                      _index + 1,
                                      images.length,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              Align(alignment: Alignment.topCenter, child: widget.actions),
            ],
          ),
        );
      },
    );
  }
}
