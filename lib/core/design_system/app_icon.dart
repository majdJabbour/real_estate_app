import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

enum AppIcons {
  homeOutline('navigation/home-outline'),
  homeSelected('navigation/home-selected'),
  exploreOutline('navigation/explore-outline'),
  exploreSelected('navigation/explore-selected'),
  profileOutline('navigation/profile-outline'),
  profileSelected('navigation/profile-selected'),
  notification('actions/notification'),
  filter('actions/filter'),
  back('actions/back'),
  detailsBack('actions/details-back'),
  profileLanguage('actions/profile-language'),
  profileLogout('actions/profile-logout'),
  profileChevron('actions/profile-chevron'),
  location('property/location'),
  heartOutline('property/heart-outline'),
  ratingStar('property/rating-star'),
  google('auth/google');

  const AppIcons(this._path);

  final String _path;

  String get asset => 'assets/icons/$_path.${this == google ? 'png' : 'svg'}';
}

/// A visual glyph. Its surrounding control owns interaction and action labels.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    this.size,
    this.color,
    this.semanticLabel,
    super.key,
  });

  final AppIcons icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final dimension = size ?? theme.size ?? 24;
    final tint = color ?? theme.color;
    if (icon == AppIcons.google) {
      return Image.asset(
        icon.asset,
        width: dimension,
        height: dimension,
        semanticLabel: semanticLabel,
        excludeFromSemantics: semanticLabel == null,
      );
    }
    final solid =
        icon != AppIcons.ratingStar && icon != AppIcons.exploreSelected;

    final (width, height) = switch (icon) {
      AppIcons.profileLanguage => (23.0833, 23.0833),
      AppIcons.profileLogout => (24.2891, 23.0833),
      AppIcons.profileChevron => (13.1667, 7.33333),
      _ => (dimension, dimension),
    };
    final picture = SvgPicture.asset(
      icon.asset,
      width: width,
      height: height,
      colorFilter: solid && tint != null
          ? ColorFilter.mode(tint, BlendMode.srcIn)
          : null,
      colorMapper: icon == AppIcons.exploreSelected && tint != null
          ? _ExploreColorMapper(tint)
          : null,
      matchTextDirection:
          icon == AppIcons.back ||
          icon == AppIcons.detailsBack ||
          icon == AppIcons.profileLogout,
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
    if (icon == AppIcons.profileChevron ||
        icon == AppIcons.profileLanguage ||
        icon == AppIcons.profileLogout) {
      return SizedBox.square(
        dimension: dimension,
        child: Center(
          child: icon == AppIcons.profileChevron
              ? RotatedBox(
                  quarterTurns: Directionality.of(context) == TextDirection.rtl
                      ? 1
                      : 3,
                  child: picture,
                )
              : picture,
        ),
      );
    }
    return picture;
  }
}

final class _ExploreColorMapper extends ColorMapper {
  const _ExploreColorMapper(this.accent);

  final Color accent;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) =>
      elementName == 'path' &&
          (attributeName == 'fill' || attributeName == 'stroke') &&
          color == const Color(0xFF0061FF)
      ? accent
      : color;

  @override
  bool operator ==(Object other) =>
      other is _ExploreColorMapper && other.accent == accent;

  @override
  int get hashCode => accent.hashCode;
}
