import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/property_image.dart';

void openPropertyGallery(BuildContext context, List<String> images, int index) {
  Navigator.of(context, rootNavigator: true).push<void>(
    MaterialPageRoute<void>(
      builder: (context) =>
          _PropertyGalleryViewer(images: images, initialIndex: index),
    ),
  );
}

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
                  itemBuilder: (context, index) => _PhotoButton(
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
                  child: _PhotoButton(
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

class _PhotoButton extends StatelessWidget {
  const _PhotoButton({
    required this.label,
    required this.onTap,
    required this.child,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    explicitChildNodes: true,
    button: true,
    label: label,
    onTap: onTap,
    child: Stack(
      fit: StackFit.expand,
      children: [
        child,
        Material(
          type: MaterialType.transparency,
          child: InkWell(onTap: onTap, excludeFromSemantics: true),
        ),
      ],
    ),
  );
}

class _PropertyGalleryViewer extends StatefulWidget {
  const _PropertyGalleryViewer({
    required this.images,
    required this.initialIndex,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<_PropertyGalleryViewer> createState() => _PropertyGalleryViewerState();
}

class _PropertyGalleryViewerState extends State<_PropertyGalleryViewer> {
  late int _index = widget.initialIndex;
  late final _pages = PageController(initialPage: _index);
  final _pointers = <int>{};
  bool _zoomed = false;

  void _trackPointer(int pointer, {required bool down}) {
    final wasPinching = _pointers.length > 1;
    if (down) {
      _pointers.add(pointer);
    } else {
      _pointers.remove(pointer);
    }
    if (wasPinching != (_pointers.length > 1)) setState(() {});
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const CloseButton(),
        title: Semantics(
          liveRegion: true,
          child: Text(
            l10n.detailsPhotoPosition(_index + 1, widget.images.length),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Listener(
          onPointerDown: (event) => _trackPointer(event.pointer, down: true),
          onPointerUp: (event) => _trackPointer(event.pointer, down: false),
          onPointerCancel: (event) => _trackPointer(event.pointer, down: false),
          child: PageView.builder(
            controller: _pages,
            itemCount: widget.images.length,
            allowImplicitScrolling: !_zoomed,
            // Leave a two-pointer gesture and panning at zoom to InteractiveViewer.
            physics:
                _zoomed || _pointers.length > 1 || widget.images.length == 1
                ? const NeverScrollableScrollPhysics()
                : null,
            onPageChanged: (index) => setState(() {
              _index = index;
              _zoomed = false;
            }),
            itemBuilder: (context, index) => _ZoomablePhoto(
              url: widget.images[index],
              onZoomChanged: (zoomed) {
                if (index == _index && _zoomed != zoomed) {
                  setState(() => _zoomed = zoomed);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoomablePhoto extends StatefulWidget {
  const _ZoomablePhoto({required this.url, required this.onZoomChanged});

  final String url;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_ZoomablePhoto> createState() => _ZoomablePhotoState();
}

class _ZoomablePhotoState extends State<_ZoomablePhoto> {
  final _transformation = TransformationController();

  @override
  void dispose() {
    _transformation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _transformation,
    child: PropertyImage(
      url: widget.url,
      fit: BoxFit.contain,
      useDisplayCacheSize: false,
    ),
    builder: (context, transform, image) => InteractiveViewer(
      transformationController: _transformation,
      panEnabled: transform.getMaxScaleOnAxis() > 1.01,
      onInteractionEnd: (_) => widget.onZoomChanged(
        _transformation.value.getMaxScaleOnAxis() > 1.01,
      ),
      maxScale: 4,
      child: image!,
    ),
  );
}
