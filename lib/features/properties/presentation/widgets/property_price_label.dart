import 'package:intl/intl.dart' show NumberFormat;
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/property.dart';

String propertyPriceLabel(BuildContext context, PropertySummary property) {
  final l10n = AppLocalizations.of(context);
  final price = NumberFormat.simpleCurrency(
    locale: l10n.localeName,
    name: property.currency,
    decimalDigits: property.price.truncateToDouble() == property.price
        ? 0
        : null,
  ).format(property.price);
  return property.pricingPeriod == 'month'
      ? l10n.propertyMonthlyPrice(price)
      : price;
}
