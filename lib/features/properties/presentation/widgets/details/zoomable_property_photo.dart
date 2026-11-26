import 'package:material_ui/material_ui.dart';

import '../shared/property_image.dart';

class ZoomablePropertyPhoto extends StatefulWidget {
  const ZoomablePropertyPhoto({
    required this.url,
    required this.onZoomChanged,
    super.key,
  });

  final String url;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<ZoomablePropertyPhoto> createState() => _ZoomablePropertyPhotoState();
}

class _ZoomablePropertyPhotoState extends State<ZoomablePropertyPhoto> {
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
