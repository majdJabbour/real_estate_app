import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/localization/app_locale.dart';
import '../../core/layout/responsive_layout.dart';
import '../../l10n/app_localizations.dart';

class ProfileDestination extends ConsumerWidget {
  const ProfileDestination({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(appLocaleProvider);
    return _DestinationContent(
      title: l10n.profileTab,
      message: l10n.profilePending,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            for (final (language, label) in [
              (AppLanguage.english, l10n.englishName),
              (AppLanguage.arabic, l10n.arabicName),
            ])
              TextButton(
                onPressed: language == selected
                    ? null
                    : () async {
                        try {
                          await ref
                              .read(appLocaleProvider.notifier)
                              .select(language);
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.languageSaveError)),
                            );
                          }
                        }
                      },
                child: Text(label),
              ),
          ],
        ),
      ],
    );
  }
}

class _DestinationContent extends StatelessWidget {
  const _DestinationContent({
    this.title,
    required this.message,
    required this.children,
  });

  final String? title;
  final String message;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Center(
      child: SingleChildScrollView(
        child: AdaptiveContent(
          maxContentWidth: ResponsiveLayout.detailsMaxWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              if (title case final title?)
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              Text(message, textAlign: TextAlign.center),
              ...children,
            ],
          ),
        ),
      ),
    ),
  );
}
