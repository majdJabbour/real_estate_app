import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExploreLoadingCard extends StatelessWidget {
  const ExploreLoadingCard({required this.list, super.key});

  final bool list;

  @override
  Widget build(BuildContext context) => Skeletonizer.zone(
    child: LayoutBuilder(
      builder: (context, constraints) => list
          ? const Bone(height: 128, uniRadius: 28)
          : Bone(
              height: math.max(140, constraints.maxWidth * 1.38),
              uniRadius: 12,
            ),
    ),
  );
}
