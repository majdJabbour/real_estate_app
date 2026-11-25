import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

class PropertyImage extends StatelessWidget {
  const PropertyImage({required this.url, super.key});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final source = url;
    final uri = source == null ? null : Uri.tryParse(source);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return const _ImagePlaceholder(failed: true);
    }

    return LayoutBuilder(
      builder: (context, constraints) => CachedNetworkImage(
        imageUrl: source!,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        fit: BoxFit.cover,
        memCacheWidth: constraints.hasBoundedWidth && constraints.maxWidth > 0
            ? (constraints.maxWidth * MediaQuery.devicePixelRatioOf(context))
                  .ceil()
                  .clamp(1, 1800)
            : null,
        placeholder: (context, url) => const _ImagePlaceholder(failed: false),
        errorWidget: (context, url, error) =>
            const _ImagePlaceholder(failed: true),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.failed});

  final bool failed;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return ColoredBox(
      color: colors.placeholderSurface,
      child: Center(
        child: failed
            ? Semantics(
                label: AppLocalizations.of(context).imageUnavailable,
                child: ExcludeSemantics(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: colors.placeholderInk,
                  ),
                ),
              )
            : Icon(Icons.image_outlined, color: colors.placeholderInk),
      ),
    );
  }
}
