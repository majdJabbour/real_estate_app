// Flutter 3.50 gen_l10n emits deprecated stock Material delegates.
// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @searchProperties.
  ///
  /// In en, this message translates to:
  /// **'Search properties'**
  String get searchProperties;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get applyFilters;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @emptyResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get emptyResults;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get unexpectedError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Could not connect. Check your connection and try again.'**
  String get networkError;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Try again.'**
  String get timeoutError;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Check the information and try again.'**
  String get validationError;

  /// No description provided for @unauthorizedError.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue.'**
  String get unauthorizedError;

  /// No description provided for @forbiddenError.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to this action.'**
  String get forbiddenError;

  /// No description provided for @notFoundError.
  ///
  /// In en, this message translates to:
  /// **'This item could not be found.'**
  String get notFoundError;

  /// No description provided for @rateLimitedError.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Try again later.'**
  String get rateLimitedError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'The server could not complete the request.'**
  String get serverError;

  /// No description provided for @serviceUnavailableError.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable.'**
  String get serviceUnavailableError;

  /// No description provided for @malformedResponseError.
  ///
  /// In en, this message translates to:
  /// **'The server returned an unreadable response.'**
  String get malformedResponseError;

  /// No description provided for @languageSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the app language.'**
  String get languageSaveError;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get switchLanguage;

  /// No description provided for @englishName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishName;

  /// No description provided for @arabicName.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicName;

  /// No description provided for @designSystemPreview.
  ///
  /// In en, this message translates to:
  /// **'Design system preview'**
  String get designSystemPreview;

  /// No description provided for @designSystem.
  ///
  /// In en, this message translates to:
  /// **'Design system'**
  String get designSystem;

  /// No description provided for @previewIntro.
  ///
  /// In en, this message translates to:
  /// **'Explore the shared controls in English and Arabic.'**
  String get previewIntro;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @previewHeading.
  ///
  /// In en, this message translates to:
  /// **'Find your next home'**
  String get previewHeading;

  /// No description provided for @previewDescription.
  ///
  /// In en, this message translates to:
  /// **'Modern apartments with room to grow.'**
  String get previewDescription;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @previewFilterAction.
  ///
  /// In en, this message translates to:
  /// **'Filter action'**
  String get previewFilterAction;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @apartments.
  ///
  /// In en, this message translates to:
  /// **'Apartments'**
  String get apartments;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @notificationsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Notifications unavailable'**
  String get notificationsUnavailable;

  /// No description provided for @previewFiltersApplied.
  ///
  /// In en, this message translates to:
  /// **'Filters applied in preview'**
  String get previewFiltersApplied;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @applyingFilters.
  ///
  /// In en, this message translates to:
  /// **'Applying filters…'**
  String get applyingFilters;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @imageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get imageUnavailable;

  /// No description provided for @adaptiveLayout.
  ///
  /// In en, this message translates to:
  /// **'Adaptive layout'**
  String get adaptiveLayout;

  /// No description provided for @previewViewport.
  ///
  /// In en, this message translates to:
  /// **'Viewport {width} × {height}'**
  String previewViewport(String width, String height);

  /// No description provided for @previewPadding.
  ///
  /// In en, this message translates to:
  /// **'Side padding {padding}  ·  Content {content}'**
  String previewPadding(String padding, String content);

  /// No description provided for @previewGrid.
  ///
  /// In en, this message translates to:
  /// **'Columns {columns}  ·  Tile width {tileWidth}'**
  String previewGrid(int columns, String tileWidth);

  /// No description provided for @sampleTile.
  ///
  /// In en, this message translates to:
  /// **'Sample tile'**
  String get sampleTile;

  /// No description provided for @sampleLongTile.
  ///
  /// In en, this message translates to:
  /// **'Sample with a longer label'**
  String get sampleLongTile;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Real Estate'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @exploreTab.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get homeGreeting;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @featuredProperties.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featuredProperties;

  /// No description provided for @recommendedProperties.
  ///
  /// In en, this message translates to:
  /// **'Our Recommendations'**
  String get recommendedProperties;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @seeAllFeatured.
  ///
  /// In en, this message translates to:
  /// **'See all featured properties'**
  String get seeAllFeatured;

  /// No description provided for @seeAllRecommendations.
  ///
  /// In en, this message translates to:
  /// **'See all recommendations'**
  String get seeAllRecommendations;

  /// No description provided for @emptyFeatured.
  ///
  /// In en, this message translates to:
  /// **'No featured properties are available.'**
  String get emptyFeatured;

  /// No description provided for @emptyRecommendations.
  ///
  /// In en, this message translates to:
  /// **'No properties in this category.'**
  String get emptyRecommendations;

  /// No description provided for @categoriesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Categories are unavailable. You can still view properties.'**
  String get categoriesUnavailable;

  /// No description provided for @openPropertyFilters.
  ///
  /// In en, this message translates to:
  /// **'Open property filters'**
  String get openPropertyFilters;

  /// No description provided for @refreshHome.
  ///
  /// In en, this message translates to:
  /// **'Refresh listings'**
  String get refreshHome;

  /// No description provided for @favoriteUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Favorites require sign-in.'**
  String get favoriteUnavailable;

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFavorite;

  /// No description provided for @addFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addFavorite;

  /// No description provided for @propertyMonthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'{price}/mo'**
  String propertyMonthlyPrice(String price);

  /// No description provided for @propertyRating.
  ///
  /// In en, this message translates to:
  /// **'Rating {rating} out of 5'**
  String propertyRating(String rating);

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @explorePending.
  ///
  /// In en, this message translates to:
  /// **'Explore is coming in a later phase.'**
  String get explorePending;

  /// No description provided for @profilePending.
  ///
  /// In en, this message translates to:
  /// **'Profile and sign-in are coming in a later phase.'**
  String get profilePending;

  /// No description provided for @exploreSearchIntent.
  ///
  /// In en, this message translates to:
  /// **'Search properties'**
  String get exploreSearchIntent;

  /// No description provided for @exploreFeaturedIntent.
  ///
  /// In en, this message translates to:
  /// **'Featured properties'**
  String get exploreFeaturedIntent;

  /// No description provided for @exploreRecommendationsIntent.
  ///
  /// In en, this message translates to:
  /// **'Recommended properties'**
  String get exploreRecommendationsIntent;

  /// No description provided for @exploreFiltersIntent.
  ///
  /// In en, this message translates to:
  /// **'Property filters'**
  String get exploreFiltersIntent;

  /// No description provided for @propertyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Property Details'**
  String get propertyDetailsTitle;

  /// No description provided for @propertyDetailsPending.
  ///
  /// In en, this message translates to:
  /// **'Property details are coming in a later phase.'**
  String get propertyDetailsPending;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
