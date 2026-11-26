import 'package:material_ui/material_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../widgets/details/zoomable_property_photo.dart';

void openPropertyGallery(BuildContext context, List<String> images, int index) {
  Navigator.of(context, rootNavigator: true).push<void>(
    MaterialPageRoute<void>(
      builder: (context) =>
          PropertyGalleryViewer(images: images, initialIndex: index),
    ),
  );
}

class PropertyGalleryViewer extends StatefulWidget {
  const PropertyGalleryViewer({
    required this.images,
    required this.initialIndex,
    super.key,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<PropertyGalleryViewer> createState() => _PropertyGalleryViewerState();
}

class _PropertyGalleryViewerState extends State<PropertyGalleryViewer> {
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
            itemBuilder: (context, index) => ZoomablePropertyPhoto(
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
