import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

class PropertyFacilities extends StatelessWidget {
  const PropertyFacilities({required this.facilities, super.key});

  final List<String> facilities;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (facilities.isEmpty) return Text(l10n.detailsNoFacilities);

    final colors = Theme.of(context).colorScheme;
    final tint = AppThemeColors.of(context).detailsTint;
    final textScaler = MediaQuery.textScalerOf(context);
    const gap = DesignSpacing.small;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final minimum = math.max(82.0, textScaler.scale(14) * 6);
        final columns = ((width + gap) / (minimum + gap)).floor().clamp(1, 4);
        final cellWidth = (width - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: DesignSpacing.page,
          children: [
            for (final key in facilities)
              SizedBox(
                width: cellWidth,
                child: Builder(
                  builder: (context) {
                    final (label, icon) = _facility(l10n, key);
                    return Column(
                      spacing: DesignSpacing.small,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: tint,
                          foregroundColor: colors.secondary,
                          child: Icon(icon, size: 28),
                        ),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colors.onSurface, height: 1.4),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

(String, IconData) _facility(
  AppLocalizations l10n,
  String key,
) => switch (key) {
  'air-conditioning' => (l10n.detailsFacilityAirConditioning, Icons.ac_unit),
  'balcony' => (l10n.detailsFacilityBalcony, Icons.balcony),
  'bike-storage' => (l10n.detailsFacilityBikeStorage, Icons.pedal_bike),
  'concierge' => (l10n.detailsFacilityConcierge, Icons.room_service_outlined),
  'covered-parking' => (
    l10n.detailsFacilityCoveredParking,
    Icons.local_parking,
  ),
  'deck' => (l10n.detailsFacilityDeck, Icons.deck),
  'elevator' => (l10n.detailsFacilityElevator, Icons.elevator_outlined),
  'ev-charging' => (l10n.detailsFacilityEvCharging, Icons.ev_station_outlined),
  'front-porch' => (l10n.detailsFacilityFrontPorch, Icons.door_front_door),
  'furnished' => (l10n.detailsFacilityFurnished, Icons.chair_outlined),
  'garage' => (l10n.detailsFacilityGarage, Icons.garage_outlined),
  'garden' => (l10n.detailsFacilityGarden, Icons.local_florist_outlined),
  'gym' => (l10n.detailsFacilityGym, Icons.fitness_center),
  'in-unit-laundry' => (
    l10n.detailsFacilityInUnitLaundry,
    Icons.local_laundry_service_outlined,
  ),
  'patio' => (l10n.detailsFacilityPatio, Icons.deck_outlined),
  'pet-friendly' => (l10n.detailsFacilityPetFriendly, Icons.pets),
  'pool' => (l10n.detailsFacilityPool, Icons.pool),
  'roof-terrace' => (l10n.detailsFacilityRoofTerrace, Icons.roofing),
  'secure-entry' => (l10n.detailsFacilitySecureEntry, Icons.lock_outline),
  'shared-laundry' => (
    l10n.detailsFacilitySharedLaundry,
    Icons.local_laundry_service_outlined,
  ),
  'storage' => (l10n.detailsFacilityStorage, Icons.inventory_2_outlined),
  _ => (key.replaceAll(RegExp(r'[-_]+'), ' ').trim(), Icons.category_outlined),
};
