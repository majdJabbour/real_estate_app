import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

class PropertyImage extends StatelessWidget {
  const PropertyImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.useDisplayCacheSize = true,
    this.placeholderIcon,
    super.key,
  });

  final String? url;
  final BoxFit fit;
  final bool useDisplayCacheSize;
  final IconData? placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final source = url;
    final uri = source == null ? null : Uri.tryParse(source);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return _ImagePlaceholder(failed: true, icon: placeholderIcon);
    }

    return LayoutBuilder(
      builder: (context, constraints) => CachedNetworkImage(
        imageUrl: source!,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        fit: fit,
        memCacheWidth:
            useDisplayCacheSize &&
                constraints.hasBoundedWidth &&
                constraints.maxWidth > 0
            ? (constraints.maxWidth * MediaQuery.devicePixelRatioOf(context))
                  .ceil()
                  .clamp(1, 1800)
            : null,
        placeholder: (context, url) =>
            _ImagePlaceholder(failed: false, icon: placeholderIcon),
        errorWidget: (context, url, error) =>
            _ImagePlaceholder(failed: true, icon: placeholderIcon),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.failed, this.icon});

  final bool failed;
  final IconData? icon;

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
                    icon ?? Icons.broken_image_outlined,
                    color: colors.placeholderInk,
                  ),
                ),
              )
            : Icon(icon ?? Icons.image_outlined, color: colors.placeholderInk),
      ),
    );
  }
}
