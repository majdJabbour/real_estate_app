import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';

class HomeFeaturedRow extends StatelessWidget {
  const HomeFeaturedRow({
    required this.insets,
    required this.height,
    required this.width,
    required this.count,
    required this.item,
    super.key,
  });

  final EdgeInsetsGeometry insets;
  final double height;
  final double width;
  final int count;
  final Widget Function(int index) item;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: ListView.separated(
      key: const PageStorageKey('home-featured-scroll'),
      scrollDirection: Axis.horizontal,
      padding: insets,
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(width: DesignSpacing.page),
      itemBuilder: (context, index) =>
          SizedBox(width: width, child: item(index)),
    ),
  );
}
