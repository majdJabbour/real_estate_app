import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/app_icon.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../authentication/application/authentication_providers.dart';
import '../shared/property_image.dart';

class HomeAccountHeader extends ConsumerWidget {
  const HomeAccountHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final user = ref.watch(authenticationSessionProvider).asData?.value;
    final name = user?.name?.trim();
    return Row(
      spacing: 12,
      children: [
        ExcludeSemantics(
          child: CircleAvatar(
            radius: 22,
            backgroundColor: scheme.primaryContainer,
            foregroundColor: scheme.secondary,
            child: user?.avatar == null
                ? const Icon(Icons.person_outline_rounded, size: 22)
                : ClipOval(
                    child: SizedBox.square(
                      dimension: 44,
                      child: PropertyImage(
                        url: user!.avatar,
                        placeholderIcon: Icons.person_outline_rounded,
                      ),
                    ),
                  ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeGreeting,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.8,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Text(
                user == null
                    ? l10n.guest
                    : name == null || name.isEmpty
                    ? l10n.signedIn
                    : name,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: null,
          tooltip: l10n.notificationsUnavailable,
          icon: const AppIcon(AppIcons.notification, size: 22),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(DesignSize.tapTarget),
            disabledForegroundColor: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
