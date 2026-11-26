import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../l10n/app_localizations.dart';

class HomeLoadingRegion extends StatelessWidget {
  const HomeLoadingRegion({
    required this.child,
    this.announce = true,
    super.key,
  });

  final Widget child;
  final bool announce;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: announce,
    label: announce ? AppLocalizations.of(context).loading : null,
    excludeSemantics: true,
    child: Skeletonizer.zone(child: child),
  );
}
