import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/design_system/design_tokens.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/layout/responsive_layout.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/failure_message.dart';
import '../../../l10n/app_localizations.dart';
import '../../authentication/application/authentication_providers.dart';
import '../../authentication/presentation/account_sign_in.dart';
import '../../properties/presentation/widgets/property_cards.dart';
import '../application/favorites_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  static const path = '/favorites';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(activeFavoritesSessionProvider);
    final language = ref.watch(appLocaleProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myFavorites),
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/profile');
            }
          },
        ),
      ),
      body: SafeArea(
        top: false,
        child: session.accountId == null
            ? _FavoritesMessage(
                text: l10n.favoriteUnavailable,
                action: ref.watch(authenticationInitializerProvider) == null
                    ? null
                    : FilledButton(
                        onPressed: () => showAccountSignIn(context, ref),
                        child: Text(l10n.googleSignIn),
                      ),
              )
            : _FavoritesPages(key: ValueKey((session, language))),
      ),
    );
  }
}

class _FavoritesPages extends ConsumerStatefulWidget {
  const _FavoritesPages({super.key});

  @override
  ConsumerState<_FavoritesPages> createState() => _FavoritesPagesState();
}

class _FavoritesPagesState extends ConsumerState<_FavoritesPages> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = favoritePropertiesProvider(_page);
    final result = ref.watch(provider);
    final page = result.asData?.value;
    final error = result.error;
    final hasPreviousPage = page?.pagination.hasPreviousPage ?? _page > 1;
    final pendingRemovals = ref.watch(
      favoriteMembershipControllerProvider.select((value) {
        final current = value.asData?.value;
        return current == null
            ? const <String>[]
            : current.pending.where((id) => !current.ids.contains(id)).toList();
      }),
    );
    final properties = page?.items.where(
      (property) => !pendingRemovals.contains(property.id),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(provider);
        try {
          await ref.read(provider.future);
        } catch (_) {
          // The provider exposes the error to the retry state.
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = ResponsiveLayout.fromConstraints(
            constraints,
            maxContentWidth: ResponsiveLayout.detailsMaxWidth,
          );
          return ListView(
            key: ValueKey(_page),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: layout.centeredInsets.add(
              const EdgeInsetsDirectional.only(
                top: DesignSpacing.medium,
                bottom: DesignSpacing.large,
              ),
            ),
            children: [
              if (result.isLoading && page == null)
                Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: l10n.loading,
                  ),
                )
              else if (error != null)
                _FavoritesMessage(
                  text: error is AppFailure
                      ? failureMessage(l10n, error)
                      : l10n.unexpectedError,
                  action: FilledButton(
                    onPressed: () => ref.invalidate(provider),
                    child: Text(l10n.retry),
                  ),
                )
              else if (page != null && properties != null) ...[
                if (properties.isEmpty)
                  _FavoritesMessage(
                    text: page.items.isNotEmpty
                        ? l10n.favoriteUpdating
                        : page.pagination.total == 0
                        ? l10n.emptyFavorites
                        : l10n.emptyFavoritesPage,
                  ),
                for (final property in properties)
                  Padding(
                    key: ValueKey(property.id),
                    padding: const EdgeInsets.only(
                      bottom: DesignSpacing.medium,
                    ),
                    child: PropertyListCard(
                      property: property,
                      onOpen: () => context.pushNamed(
                        'propertyDetails',
                        pathParameters: {'propertyId': property.id},
                      ),
                    ),
                  ),
              ],
              if (!result.isLoading &&
                  (hasPreviousPage || page?.pagination.hasNextPage == true))
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    if (hasPreviousPage)
                      TextButton(
                        onPressed: () => setState(() => _page--),
                        child: Text(l10n.previousFavoritesPage),
                      ),
                    if (page?.pagination.hasNextPage == true)
                      TextButton(
                        onPressed: () => setState(() => _page++),
                        child: Text(l10n.nextFavoritesPage),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FavoritesMessage extends StatelessWidget {
  const _FavoritesMessage({required this.text, this.action});

  final String? text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(DesignSpacing.large),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: DesignSpacing.medium,
      children: [
        if (text case final message?)
          Semantics(
            liveRegion: true,
            child: Text(message, textAlign: TextAlign.center),
          ),
        ?action,
      ],
    ),
  );
}
