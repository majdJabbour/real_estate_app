import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../l10n/app_localizations.dart';

class PropertyLocationMap extends StatefulWidget {
  const PropertyLocationMap({
    required this.point,
    this.tileProvider,
    super.key,
  });

  final LatLng point;
  final TileProvider? tileProvider;

  @override
  State<PropertyLocationMap> createState() => _PropertyLocationMapState();
}

class _PropertyLocationMapState extends State<PropertyLocationMap>
    with AutomaticKeepAliveClientMixin {
  static const _tileUrl = String.fromEnvironment(
    'MAP_TILE_URL',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  late final _tiles =
      widget.tileProvider ??
      NetworkTileProvider(attemptDecodeOfHttpErrorResponses: false);
  bool _hasTiles = false;
  bool _hasFailure = false;

  @override
  bool get wantKeepAlive => true;

  void _reportTile({required bool failed}) {
    if (failed ? _hasFailure : _hasTiles) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || (failed ? _hasFailure : _hasTiles)) return;
      setState(() {
        if (failed) {
          _hasFailure = true;
        } else {
          _hasTiles = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    if (!_tileUrl.startsWith('https://')) {
      return Text(l10n.detailsMapUnavailable);
    }
    final status = _hasFailure
        ? l10n.detailsMapTilesFailed
        : _hasTiles
        ? null
        : l10n.detailsMapLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 200,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: widget.point,
                initialZoom: 15,
                backgroundColor: colors.surfaceContainer,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: _tileUrl,
                  userAgentPackageName: 'com.majdjabbour.realestate',
                  tileProvider: _tiles,
                  panBuffer: 0,
                  keepBuffer: 0,
                  errorTileCallback: (_, _, _) => _reportTile(failed: true),
                  tileBuilder: (_, child, tile) {
                    if (tile.imageInfo != null && !tile.loadError) {
                      _reportTile(failed: false);
                    }
                    return child;
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.point,
                      width: 48,
                      height: 48,
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.location_on,
                        color: colors.primary,
                        size: 46,
                        semanticLabel: l10n.detailsLocation,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () async {
                      final opened = await launchUrl(
                        Uri.https('www.openstreetmap.org', '/copyright'),
                        mode: LaunchMode.externalApplication,
                      ).onError((_, _) => false);
                      if (!opened && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.detailsMapOpenFailed)),
                        );
                      }
                    },
                    child: ColoredBox(
                      color: colors.surface,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        child: Text(
                          '© OpenStreetMap contributors',
                          style: TextStyle(fontSize: 11),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (status != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Semantics(
              liveRegion: true,
              child: Text(status, style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
      ],
    );
  }
}
