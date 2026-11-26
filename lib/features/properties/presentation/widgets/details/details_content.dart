import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../core/layout/responsive_layout.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/property.dart';
import '../shared/property_favorite_button.dart';
import 'agent_contact_actions.dart';
import 'details_back_button.dart';
import 'details_location.dart';
import 'details_named_person.dart';
import 'details_price_footer.dart';
import 'details_reviews.dart';
import 'details_section.dart';
import 'details_summary.dart';
import 'property_facilities.dart';
import 'property_gallery.dart';
import 'property_hero.dart';

const _sectionGap = 30.0;

class DetailsContent extends StatefulWidget {
  const DetailsContent({
    required this.details,
    required this.initialImageIndex,
    required this.onImageChanged,
    super.key,
  });

  final PropertyDetails details;
  final int initialImageIndex;
  final ValueChanged<int> onImageChanged;

  @override
  State<DetailsContent> createState() => _DetailsContentState();
}

class _DetailsContentState extends State<DetailsContent> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.details;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final statusBarHeight = MediaQuery.paddingOf(context).top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const cap = ResponsiveLayout.detailsMaxWidth;
              final heroWidth = math.min(constraints.maxWidth, cap);
              final imageInset = (constraints.maxWidth - heroWidth) / 2;
              final layout = ResponsiveLayout.fromConstraints(
                constraints,
                maxContentWidth: cap,
              );
              return Stack(
                children: [
                  CustomScrollView(
                    controller: _scroll,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: imageInset),
                        sliver: SliverToBoxAdapter(
                          child: PropertyHero(
                            key: ValueKey(Object.hashAll(details.images)),
                            images: details.images,
                            initialIndex: widget.initialImageIndex,
                            onPageChanged: widget.onImageChanged,
                            actions: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                14,
                                statusBarHeight + 16,
                                14,
                                0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Material(
                                    color: theme.colorScheme.surface,
                                    shape: const CircleBorder(),
                                    child: const DetailsBackButton(),
                                  ),
                                  Material(
                                    color: theme.colorScheme.surface,
                                    shape: const CircleBorder(),
                                    child: PropertyFavoriteButton(
                                      propertyId: details.summary.id,
                                      iconSize: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: layout.centeredInsets.add(
                          const EdgeInsets.only(
                            top: DesignSpacing.large,
                            bottom: _sectionGap,
                          ),
                        ),
                        sliver: SliverList.list(
                          children: [
                            DetailsSummary(details: details),
                            const SizedBox(height: _sectionGap),
                            const Divider(height: 1),
                            const SizedBox(height: _sectionGap),
                            DetailsSection(
                              title: l10n.detailsAgent,
                              gap: DesignSpacing.medium,
                              child: DetailsNamedPerson(
                                name: details.agent.name,
                                avatarUrl: details.agent.avatar,
                                size: 60,
                                trailing: const AgentContactActions(),
                              ),
                            ),
                            const SizedBox(height: _sectionGap),
                            DetailsSection(
                              title: l10n.detailsOverview,
                              gap: DesignSpacing.chipGap,
                              child: Text(
                                details.description,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(height: _sectionGap),
                            DetailsSection(
                              title: l10n.detailsFacilities,
                              child: PropertyFacilities(
                                facilities: details.facilities,
                              ),
                            ),
                            const SizedBox(height: _sectionGap),
                            DetailsSection(
                              title: l10n.detailsGallery,
                              child: PropertyGallery(images: details.images),
                            ),
                            const SizedBox(height: _sectionGap),
                            DetailsSection(
                              title: l10n.detailsLocation,
                              child: DetailsLocation(details: details),
                            ),
                            const SizedBox(height: _sectionGap),
                            DetailsSection(
                              title: l10n.detailsReviews,
                              gap: DesignSpacing.large,
                              child: DetailsReviews(reviews: details.reviews),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (statusBarHeight > 0)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: statusBarHeight,
                      child: IgnorePointer(
                        child: ListenableBuilder(
                          listenable: _scroll,
                          builder: (context, _) => ColoredBox(
                            color: theme.colorScheme.surface.withValues(
                              alpha: _scroll.hasClients
                                  ? (_scroll.offset / statusBarHeight).clamp(
                                      0.0,
                                      1.0,
                                    )
                                  : 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: DetailsPriceFooter(property: details.summary),
      ),
    );
  }
}
