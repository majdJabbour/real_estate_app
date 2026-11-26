import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../shared/property_grid_card.dart';

class HomeGridSkeleton extends StatelessWidget {
  const HomeGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsetsDirectional.fromSTEB(14, 16, 14, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        AspectRatio(
          aspectRatio: PropertyGridCard.imageAspectRatio,
          child: Bone(uniRadius: 10),
        ),
        Bone.text(fontSize: 16, words: 2),
        Bone.text(fontSize: 12, words: 2),
        Bone.text(fontSize: 16, words: 1),
      ],
    ),
  );
}
