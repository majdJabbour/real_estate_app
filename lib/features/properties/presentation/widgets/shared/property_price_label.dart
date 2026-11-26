import 'package:intl/intl.dart' show NumberFormat;
import 'package:material_ui/material_ui.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../domain/property.dart';

String propertyPriceLabel(
  BuildContext context,
  PropertySummary property, {
  bool includePeriod = true,
}) {
  final l10n = AppLocalizations.of(context);
  final price = NumberFormat.simpleCurrency(
    locale: l10n.localeName,
    name: property.currency,
    decimalDigits: property.price.truncateToDouble() == property.price
        ? 0
        : null,
  ).format(property.price);
  // Keep the currency amount together before adding the Arabic period label.
  final amount = Localizations.localeOf(context).languageCode == 'ar'
      ? '\u2068$price\u2069'
      : price;
  return includePeriod && property.pricingPeriod == 'month'
      ? l10n.propertyMonthlyPrice(amount)
      : amount;
}
