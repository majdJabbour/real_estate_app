import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/localization/failure_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/property_details_provider.dart';
import '../widgets/details/details_content.dart';
import '../widgets/details/details_status.dart';

class PropertyDetailsScreen extends ConsumerStatefulWidget {
  const PropertyDetailsScreen({required this.propertyId, super.key});

  final String propertyId;

  @override
  ConsumerState<PropertyDetailsScreen> createState() =>
      _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends ConsumerState<PropertyDetailsScreen> {
  int _imageIndex = 0;

  @override
  void didUpdateWidget(covariant PropertyDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.propertyId != widget.propertyId) _imageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = propertyDetailsProvider(widget.propertyId);
    final result = ref.watch(provider);
    return result.when(
      skipLoadingOnRefresh: false,
      data: (details) => DetailsContent(
        key: ValueKey(widget.propertyId),
        details: details,
        initialImageIndex: _imageIndex,
        onImageChanged: (index) => _imageIndex = index,
      ),
      loading: () => const DetailsStatus(),
      error: (error, _) {
        final failure = error is AppFailure
            ? error
            : const AppFailure(FailureKind.unexpected);
        final message = failureMessage(l10n, failure);
        return DetailsStatus(
          message: message,
          onRetry: message == null ? null : () => ref.invalidate(provider),
        );
      },
    );
  }
}
