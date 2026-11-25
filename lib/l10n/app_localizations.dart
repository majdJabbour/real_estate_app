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

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Search for Your Ideal Home'**
  String get exploreTitle;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @showGrid.
  ///
  /// In en, this message translates to:
  /// **'Show grid'**
  String get showGrid;

  /// No description provided for @showList.
  ///
  /// In en, this message translates to:
  /// **'Show list'**
  String get showList;

  /// No description provided for @propertyResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No properties found} =1{Found 1 property} other{Found {count} properties}}'**
  String propertyResultCount(int count);

  /// No description provided for @featuredOnly.
  ///
  /// In en, this message translates to:
  /// **'Featured only'**
  String get featuredOnly;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetFilters;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @propertyTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get propertyTypeLabel;

  /// No description provided for @homeDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Home Details'**
  String get homeDetailsLabel;

  /// No description provided for @minBedroomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum bedrooms'**
  String get minBedroomsLabel;

  /// No description provided for @minBathroomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum bathrooms'**
  String get minBathroomsLabel;

  /// No description provided for @bedroomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get bedroomsLabel;

  /// No description provided for @bathroomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathroomsLabel;

  /// No description provided for @buildingSize.
  ///
  /// In en, this message translates to:
  /// **'Building Size'**
  String get buildingSize;

  /// No description provided for @areaSquareMeters.
  ///
  /// In en, this message translates to:
  /// **'{area} m²'**
  String areaSquareMeters(String area);

  /// No description provided for @noRangeAvailable.
  ///
  /// In en, this message translates to:
  /// **'Range unavailable'**
  String get noRangeAvailable;

  /// No description provided for @decreaseValue.
  ///
  /// In en, this message translates to:
  /// **'Decrease {label}'**
  String decreaseValue(String label);

  /// No description provided for @increaseValue.
  ///
  /// In en, this message translates to:
  /// **'Increase {label}'**
  String increaseValue(String label);

  /// No description provided for @minimumValue.
  ///
  /// In en, this message translates to:
  /// **'Minimum {value}'**
  String minimumValue(String value);

  /// No description provided for @maximumValue.
  ///
  /// In en, this message translates to:
  /// **'Maximum {value}'**
  String maximumValue(String value);

  /// No description provided for @filterSet.
  ///
  /// In en, this message translates to:
  /// **'Set Filter'**
  String get filterSet;

  /// No description provided for @morePropertiesLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading more properties…'**
  String get morePropertiesLoading;

  /// No description provided for @retryMoreProperties.
  ///
  /// In en, this message translates to:
  /// **'Retry next page'**
  String get retryMoreProperties;

  /// No description provided for @clearFeaturedFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear featured filter'**
  String get clearFeaturedFilter;

  /// No description provided for @detailsAgent.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get detailsAgent;

  /// No description provided for @detailsOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get detailsOverview;

  /// No description provided for @detailsFacilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get detailsFacilities;

  /// No description provided for @detailsNoFacilities.
  ///
  /// In en, this message translates to:
  /// **'No facilities listed.'**
  String get detailsNoFacilities;

  /// No description provided for @detailsGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get detailsGallery;

  /// No description provided for @detailsNoPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos available.'**
  String get detailsNoPhotos;

  /// No description provided for @detailsLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get detailsLocation;

  /// No description provided for @detailsLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get detailsLatitude;

  /// No description provided for @detailsLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get detailsLongitude;

  /// No description provided for @detailsReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get detailsReviews;

  /// No description provided for @detailsNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews available.'**
  String get detailsNoReviews;

  /// No description provided for @detailsMonthlyRent.
  ///
  /// In en, this message translates to:
  /// **'Monthly rent'**
  String get detailsMonthlyRent;

  /// No description provided for @detailsBookingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Booking unavailable'**
  String get detailsBookingUnavailable;

  /// No description provided for @detailsPhotoPosition.
  ///
  /// In en, this message translates to:
  /// **'Photo {position} of {total}'**
  String detailsPhotoPosition(int position, int total);

  /// No description provided for @detailsOpenPhoto.
  ///
  /// In en, this message translates to:
  /// **'Open photo {position} of {total}'**
  String detailsOpenPhoto(int position, int total);

  /// No description provided for @detailsMorePhotos.
  ///
  /// In en, this message translates to:
  /// **'+{count}'**
  String detailsMorePhotos(int count);

  /// No description provided for @detailsOpenMorePhotos.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Open gallery, {count} more photo} other{Open gallery, {count} more photos}}'**
  String detailsOpenMorePhotos(int count);

  /// No description provided for @detailsBedrooms.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} bedroom} other{{count} bedrooms}}'**
  String detailsBedrooms(int count);

  /// No description provided for @detailsBathrooms.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} bathroom} other{{count} bathrooms}}'**
  String detailsBathrooms(int count);

  /// No description provided for @detailsTypeApartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get detailsTypeApartment;

  /// No description provided for @detailsTypeTownhome.
  ///
  /// In en, this message translates to:
  /// **'Townhome'**
  String get detailsTypeTownhome;

  /// No description provided for @detailsTypeHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get detailsTypeHouse;

  /// No description provided for @detailsTypeCondo.
  ///
  /// In en, this message translates to:
  /// **'Condo'**
  String get detailsTypeCondo;

  /// No description provided for @detailsTypeDuplex.
  ///
  /// In en, this message translates to:
  /// **'Duplex'**
  String get detailsTypeDuplex;

  /// No description provided for @detailsTypeStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get detailsTypeStudio;

  /// No description provided for @detailsFacilityAirConditioning.
  ///
  /// In en, this message translates to:
  /// **'Air conditioning'**
  String get detailsFacilityAirConditioning;

  /// No description provided for @detailsFacilityBalcony.
  ///
  /// In en, this message translates to:
  /// **'Balcony'**
  String get detailsFacilityBalcony;

  /// No description provided for @detailsFacilityBikeStorage.
  ///
  /// In en, this message translates to:
  /// **'Bike storage'**
  String get detailsFacilityBikeStorage;

  /// No description provided for @detailsFacilityConcierge.
  ///
  /// In en, this message translates to:
  /// **'Concierge'**
  String get detailsFacilityConcierge;

  /// No description provided for @detailsFacilityCoveredParking.
  ///
  /// In en, this message translates to:
  /// **'Covered parking'**
  String get detailsFacilityCoveredParking;

  /// No description provided for @detailsFacilityDeck.
  ///
  /// In en, this message translates to:
  /// **'Outdoor deck'**
  String get detailsFacilityDeck;

  /// No description provided for @detailsFacilityElevator.
  ///
  /// In en, this message translates to:
  /// **'Elevator'**
  String get detailsFacilityElevator;

  /// No description provided for @detailsFacilityEvCharging.
  ///
  /// In en, this message translates to:
  /// **'EV charging'**
  String get detailsFacilityEvCharging;

  /// No description provided for @detailsFacilityFrontPorch.
  ///
  /// In en, this message translates to:
  /// **'Front porch'**
  String get detailsFacilityFrontPorch;

  /// No description provided for @detailsFacilityFurnished.
  ///
  /// In en, this message translates to:
  /// **'Furnished'**
  String get detailsFacilityFurnished;

  /// No description provided for @detailsFacilityGarage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get detailsFacilityGarage;

  /// No description provided for @detailsFacilityGarden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get detailsFacilityGarden;

  /// No description provided for @detailsFacilityGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get detailsFacilityGym;

  /// No description provided for @detailsFacilityInUnitLaundry.
  ///
  /// In en, this message translates to:
  /// **'In-unit laundry'**
  String get detailsFacilityInUnitLaundry;

  /// No description provided for @detailsFacilityPatio.
  ///
  /// In en, this message translates to:
  /// **'Patio'**
  String get detailsFacilityPatio;

  /// No description provided for @detailsFacilityPetFriendly.
  ///
  /// In en, this message translates to:
  /// **'Pet friendly'**
  String get detailsFacilityPetFriendly;

  /// No description provided for @detailsFacilityPool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get detailsFacilityPool;

  /// No description provided for @detailsFacilityRoofTerrace.
  ///
  /// In en, this message translates to:
  /// **'Roof terrace'**
  String get detailsFacilityRoofTerrace;

  /// No description provided for @detailsFacilitySecureEntry.
  ///
  /// In en, this message translates to:
  /// **'Secure entry'**
  String get detailsFacilitySecureEntry;

  /// No description provided for @detailsFacilitySharedLaundry.
  ///
  /// In en, this message translates to:
  /// **'Shared laundry'**
  String get detailsFacilitySharedLaundry;

  /// No description provided for @detailsFacilityStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get detailsFacilityStorage;

  /// No description provided for @splashBrand.
  ///
  /// In en, this message translates to:
  /// **'REAL SCOUT'**
  String get splashBrand;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Connecting you to your ideal home.'**
  String get splashTagline;

  /// No description provided for @restoringSession.
  ///
  /// In en, this message translates to:
  /// **'Restoring your session'**
  String get restoringSession;

  /// No description provided for @startupError.
  ///
  /// In en, this message translates to:
  /// **'Real Scout couldn’t restore your session. Please try again.'**
  String get startupError;

  /// No description provided for @authWelcome.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO REAL SCOUT'**
  String get authWelcome;

  /// No description provided for @authHeading.
  ///
  /// In en, this message translates to:
  /// **'Let’s Get You Closer\nTo {emphasis}'**
  String authHeading(String emphasis);

  /// No description provided for @authHeadingEmphasis.
  ///
  /// In en, this message translates to:
  /// **'Your Ideal Home'**
  String get authHeadingEmphasis;

  /// No description provided for @authDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Real Scout with Google'**
  String get authDescription;

  /// No description provided for @googleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get googleSignIn;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get signingIn;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @signInConfigurationError.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in is unavailable on this build. You can continue as a guest.'**
  String get signInConfigurationError;

  /// No description provided for @authenticationError.
  ///
  /// In en, this message translates to:
  /// **'The authentication request couldn’t be completed. Please try again.'**
  String get authenticationError;

  /// No description provided for @signedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get signedIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signingOut.
  ///
  /// In en, this message translates to:
  /// **'Signing out…'**
  String get signingOut;

  /// No description provided for @verifyingProfile.
  ///
  /// In en, this message translates to:
  /// **'Verifying your profile…'**
  String get verifyingProfile;

  /// No description provided for @verifiedProfile.
  ///
  /// In en, this message translates to:
  /// **'Verified profile'**
  String get verifiedProfile;

  /// No description provided for @profileUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session could not be verified. Try again or sign out and sign back in.'**
  String get profileUnauthorized;

  /// No description provided for @signInToSave.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save properties'**
  String get signInToSave;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @emptyFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorite properties yet.'**
  String get emptyFavorites;

  /// No description provided for @emptyFavoritesPage.
  ///
  /// In en, this message translates to:
  /// **'There are no favorites on this page.'**
  String get emptyFavoritesPage;

  /// No description provided for @favoriteLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading favorites…'**
  String get favoriteLoading;

  /// No description provided for @favoriteUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating favorites…'**
  String get favoriteUpdating;

  /// No description provided for @favoriteRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry loading favorite status'**
  String get favoriteRetry;

  /// No description provided for @previousFavoritesPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousFavoritesPage;

  /// No description provided for @nextFavoritesPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextFavoritesPage;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @originalBlue.
  ///
  /// In en, this message translates to:
  /// **'Original Blue'**
  String get originalBlue;

  /// No description provided for @newPurple.
  ///
  /// In en, this message translates to:
  /// **'New Purple'**
  String get newPurple;

  /// No description provided for @newOrange.
  ///
  /// In en, this message translates to:
  /// **'New Orange'**
  String get newOrange;

  /// No description provided for @themeSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the app appearance.'**
  String get themeSaveError;

  /// No description provided for @accountNameUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Name unavailable'**
  String get accountNameUnavailable;

  /// No description provided for @confirmSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account?'**
  String get confirmSignOut;

  /// No description provided for @detailsMapLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading map…'**
  String get detailsMapLoading;

  /// No description provided for @detailsMapTilesFailed.
  ///
  /// In en, this message translates to:
  /// **'Some map tiles could not load.'**
  String get detailsMapTilesFailed;

  /// No description provided for @detailsMapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'An embedded map is unavailable for this location.'**
  String get detailsMapUnavailable;

  /// No description provided for @detailsOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get detailsOpenMap;

  /// No description provided for @detailsMapOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open Maps.'**
  String get detailsMapOpenFailed;

  /// No description provided for @detailsDemoLocation.
  ///
  /// In en, this message translates to:
  /// **'Demo location for a fictional listing.'**
  String get detailsDemoLocation;

  /// No description provided for @openAppliedPropertyFilters.
  ///
  /// In en, this message translates to:
  /// **'Open property filters, filters applied'**
  String get openAppliedPropertyFilters;
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
