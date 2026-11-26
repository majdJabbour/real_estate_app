import 'package:material_ui/material_ui.dart';

class ExploreResultsMessage extends StatelessWidget {
  const ExploreResultsMessage({
    required this.message,
    required this.action,
    required this.retry,
    super.key,
  });

  final String? message;
  final String? action;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(liveRegion: true, child: Text(message!)),
          if (action case final label?)
            TextButton(onPressed: retry, child: Text(label)),
        ],
      ),
    );
  }
}
