import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/design_system/app_icon.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/property.dart';
import 'property_location_map.dart';

class DetailsLocation extends StatelessWidget {
  const DetailsLocation({required this.details, super.key});

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
