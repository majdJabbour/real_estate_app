import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/design_system/app_icon.dart';
import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/localization/failure_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/property_details_provider.dart';
import '../../domain/property.dart';
import '../../domain/property_type.dart';
import '../widgets/property_favorite_button.dart';
import '../widgets/property_image.dart';
import '../widgets/property_price_label.dart';
import 'property_facilities.dart';
import 'property_gallery.dart';
import 'property_location_map.dart';

const _sectionGap = 30.0;

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
      data: (details) => _DetailsContent(
        key: ValueKey(widget.propertyId),
        details: details,
        initialImageIndex: _imageIndex,
        onImageChanged: (index) => _imageIndex = index,
      ),
      loading: () => const _DetailsStatus(),
      error: (error, _) {
        final failure = error is AppFailure
            ? error
            : const AppFailure(FailureKind.unexpected);
        final message = failureMessage(l10n, failure);
        return _DetailsStatus(
          message: message,
          onRetry: message == null ? null : () => ref.invalidate(provider),
        );
      },
    );
  }
}

class _DetailsBackButton extends StatelessWidget {
  const _DetailsBackButton();

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    icon: const AppIcon(AppIcons.detailsBack, size: 28),
    onPressed: () {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home');
      }
    },
  );
}

class _DetailsStatus extends StatelessWidget {
  const _DetailsStatus({this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final failure = message;
    return Scaffold(
      appBar: AppBar(
        leading: const _DetailsBackButton(),
        title: Text(l10n.propertyDetailsTitle),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: AdaptiveContent(
              maxContentWidth: ResponsiveLayout.detailsMaxWidth,
              child: Column(
                spacing: DesignSpacing.medium,
                children: [
                  if (failure == null)
                    CircularProgressIndicator(semanticsLabel: l10n.loading)
                  else
                    Semantics(
                      liveRegion: true,
                      child: Text(failure, textAlign: TextAlign.center),
                    ),
                  if (onRetry != null)
                    FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsContent extends StatefulWidget {
  const _DetailsContent({
    required this.details,
    required this.initialImageIndex,
    required this.onImageChanged,
    super.key,
  });

  final PropertyDetails details;
  final int initialImageIndex;
  final ValueChanged<int> onImageChanged;

  @override
  State<_DetailsContent> createState() => _DetailsContentState();
}

class _DetailsContentState extends State<_DetailsContent> {
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
                                    child: const _DetailsBackButton(),
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
                            _PropertySummary(details: details),
                            const SizedBox(height: _sectionGap),
                            const Divider(height: 1),
                            const SizedBox(height: _sectionGap),
                            _DetailsSection(
                              title: l10n.detailsAgent,
                              gap: DesignSpacing.medium,
                              child: _NamedPerson(
                                name: details.agent.name,
                                avatarUrl: details.agent.avatar,
                                size: 60,
                                trailing: const _AgentContactActions(),
                              ),
                            ),
                            const SizedBox(height: _sectionGap),
                            _DetailsSection(
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
                            _DetailsSection(
                              title: l10n.detailsFacilities,
                              child: PropertyFacilities(
                                facilities: details.facilities,
                              ),
                            ),
                            const SizedBox(height: _sectionGap),
                            _DetailsSection(
                              title: l10n.detailsGallery,
                              child: PropertyGallery(images: details.images),
                            ),
                            const SizedBox(height: _sectionGap),
                            _DetailsSection(
                              title: l10n.detailsLocation,
                              child: _Location(details: details),
                            ),
                            const SizedBox(height: _sectionGap),
                            _DetailsSection(
                              title: l10n.detailsReviews,
                              gap: DesignSpacing.large,
                              child: _Reviews(reviews: details.reviews),
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
        bottomNavigationBar: _PriceFooter(property: details.summary),
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.title,
    required this.child,
    this.gap = DesignSpacing.page,
  });

  final String title;
  final Widget child;
  final double gap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: gap,
    children: [
      Semantics(
        header: true,
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      child,
    ],
  );
}

class _PropertySummary extends StatelessWidget {
  const _PropertySummary({required this.details});

  final PropertyDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final summary = details.summary;
    final area = NumberFormat.decimalPattern(l10n.localeName)
        .format(details.area);
    final propertyType = switch (summary.type) {
      PropertyType.apartment => l10n.detailsTypeApartment,
      PropertyType.townhome => l10n.detailsTypeTownhome,
      PropertyType.house => l10n.detailsTypeHouse,
      PropertyType.condo => l10n.detailsTypeCondo,
      PropertyType.duplex => l10n.detailsTypeDuplex,
      PropertyType.studio => l10n.detailsTypeStudio,
      null => summary.typeId,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: DesignSpacing.medium,
      children: [
        Semantics(
          header: true,
          child: Text(summary.title, style: theme.textTheme.headlineMedium),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: DesignSpacing.small,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppThemeColors.of(context).detailsTint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Text(
                  propertyType,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            _Rating(summary.rating),
          ],
        ),
        Wrap(
          spacing: DesignSpacing.large,
          runSpacing: DesignSpacing.small,
          children: [
            _Stat(Icons.bed_outlined, l10n.detailsBedrooms(details.bedrooms)),
            _Stat(
              Icons.bathtub_outlined,
              l10n.detailsBathrooms(details.bathrooms),
            ),
            _Stat(
              Icons.open_in_full,
              details.areaUnit == 'sqm'
                  ? l10n.areaSquareMeters(area)
                  : '$area ${details.areaUnit}',
            ),
          ],
        ),
      ],
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating(this.rating, {this.size = 20});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final value = NumberFormat('0.0', l10n.localeName).format(rating);
    return Semantics(
      label: l10n.propertyRating(value),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          AppIcon(AppIcons.ratingStar, size: size),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: DesignSpacing.small,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppThemeColors.of(context).detailsTint,
          foregroundColor: theme.colorScheme.secondary,
          child: Icon(icon, size: 16),
        ),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _NamedPerson extends StatelessWidget {
  const _NamedPerson({
    required this.name,
    required this.size,
    this.avatarUrl,
    this.trailing,
  });

  final String name;
  final double size;
  final String? avatarUrl;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    spacing: DesignSpacing.small,
    children: [
      ExcludeSemantics(
        child: ClipOval(
          child: SizedBox.square(
            dimension: size,
            child: PropertyImage(
              url: avatarUrl,
              placeholderIcon: Icons.person_outline,
            ),
          ),
        ),
      ),
      if (size == 60) const SizedBox(width: 4),
      Expanded(
        child: Text(
          name,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: size == 60 ? 18 : 16,
            height: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      ?trailing,
    ],
  );
}

class _AgentContactActions extends StatelessWidget {
  const _AgentContactActions();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (icon, label) in [
          (AppIcons.detailsChat, l10n.detailsMessageAgent),
          (AppIcons.detailsCall, l10n.detailsCallAgent),
        ])
          IconButton(
            tooltip: label,
            icon: AppIcon(icon, size: 28, color: color),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.detailsContactUnavailable)),
              );
            },
          ),
      ],
    );
  }
}

class _Location extends StatelessWidget {
  const _Location({required this.details});

  final PropertyDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final location = details.location;
    final latitude = location?.latitude;
    final longitude = location?.longitude;
    final valid =
        latitude != null &&
        longitude != null &&
        latitude.isFinite &&
        latitude.abs() <= 90 &&
        longitude.isFinite &&
        longitude.abs() <= 180;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: DesignSpacing.page,
      children: [
        Row(
          spacing: DesignSpacing.small,
          children: [
            AppIcon(
              AppIcons.location,
              size: 20,
              color: theme.colorScheme.secondary,
            ),
            Expanded(
              child: Text(
                details.summary.address,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        if (valid && latitude.abs() <= 85.05112878)
          PropertyLocationMap(
            key: ValueKey((latitude, longitude)),
            point: LatLng(latitude, longitude),
          )
        else
          Text(l10n.detailsMapUnavailable, style: theme.textTheme.bodySmall),
        Text(l10n.detailsDemoLocation, style: theme.textTheme.bodySmall),
        if (valid)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () async {
                final uri = Uri.https('www.google.com', '/maps/search/', {
                  'api': '1',
                  'query': '$latitude,$longitude',
                });
                var opened = false;
                try {
                  opened = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                } on PlatformException {
                  opened = false;
                }
                if (!opened && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.detailsMapOpenFailed)),
                  );
                }
              },
              child: Text(l10n.detailsOpenMap),
            ),
          ),
      ],
    );
  }
}

class _Reviews extends StatelessWidget {
  const _Reviews({required this.reviews});

  final List<PropertyReview> reviews;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (reviews.isEmpty) return Text(l10n.detailsNoReviews);

    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd(l10n.localeName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: DesignSpacing.medium,
      children: [
        for (final review in reviews) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: DesignSpacing.chipGap,
            children: [
              _NamedPerson(name: review.reviewerName, size: 40),
              Text(
                review.comment,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: DesignSpacing.medium,
                runSpacing: DesignSpacing.small,
                children: [
                  _Rating(review.rating, size: 16),
                  Text(
                    dateFormat.format(review.date),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (review != reviews.last) const Divider(height: 1),
        ],
      ],
    );
  }
}

class _PriceFooter extends StatelessWidget {
  const _PriceFooter({required this.property});

  final PropertySummary property;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final price = propertyPriceLabel(context, property, includePeriod: false);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: DesignColors.strongTintOpacity,
          ),
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(DesignShape.footerRadius),
        ),
      ),
      child: SafeArea(
        top: false,
        child: AdaptiveContent(
          maxContentWidth: ResponsiveLayout.detailsMaxWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
            child: LayoutBuilder(
              builder: (context, constraints) => Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: DesignSpacing.medium,
                runSpacing: DesignSpacing.small,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      Text(
                        l10n.detailsMonthlyRent,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 12,
                          letterSpacing: 2,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        price,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth * (236 / 380),
                    ),
                    child: FilledButtonTheme(
                      data: FilledButtonThemeData(
                        style: theme.filledButtonTheme.style?.copyWith(
                          minimumSize: const WidgetStatePropertyAll(
                            Size(DesignSize.tapTarget, 50),
                          ),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          textStyle: WidgetStatePropertyAll(
                            theme.textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              height: 22 / 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      child: PropertyFavoriteButton.filled(
                        propertyId: property.id,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
