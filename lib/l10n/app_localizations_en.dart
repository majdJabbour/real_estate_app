// Flutter 3.50 gen_l10n emits deprecated stock Material delegates.
// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get searchProperties => 'Search properties';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get loading => 'Loading…';

  @override
  String get emptyResults => 'No results';

  @override
  String get unexpectedError => 'Something went wrong';

  @override
  String get networkError =>
      'Could not connect. Check your connection and try again.';

  @override
  String get timeoutError => 'The request timed out. Try again.';

  @override
  String get validationError => 'Check the information and try again.';

  @override
  String get unauthorizedError => 'Sign in to continue.';

  @override
  String get forbiddenError => 'You don\'t have access to this action.';

  @override
  String get notFoundError => 'This item could not be found.';

  @override
  String get rateLimitedError => 'Too many requests. Try again later.';

  @override
  String get serverError => 'The server could not complete the request.';

  @override
  String get serviceUnavailableError =>
      'The service is temporarily unavailable.';

  @override
  String get malformedResponseError =>
      'The server returned an unreadable response.';

  @override
  String get languageSaveError => 'Could not save the app language.';

  @override
  String get switchLanguage => 'Change language';

  @override
  String get englishName => 'English';

  @override
  String get arabicName => 'العربية';

  @override
  String get designSystemPreview => 'Design system preview';

  @override
  String get designSystem => 'Design system';

  @override
  String get previewIntro =>
      'Explore the shared controls in English and Arabic.';

  @override
  String get blue => 'Blue';

  @override
  String get purple => 'Purple';

  @override
  String get orange => 'Orange';

  @override
  String get previewHeading => 'Find your next home';

  @override
  String get previewDescription => 'Modern apartments with room to grow.';

  @override
  String get filters => 'Filters';

  @override
  String get previewFilterAction => 'Filter action';

  @override
  String get all => 'All';

  @override
  String get apartments => 'Apartments';

  @override
  String get favorite => 'Favorite';

  @override
  String get notificationsUnavailable => 'Notifications unavailable';

  @override
  String get previewFiltersApplied => 'Filters applied in preview';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get applyingFilters => 'Applying filters…';

  @override
  String get saved => 'Saved';

  @override
  String get imageUnavailable => 'Image unavailable';

  @override
  String get adaptiveLayout => 'Adaptive layout';

  @override
  String previewViewport(String width, String height) {
    return 'Viewport $width × $height';
  }

  @override
  String previewPadding(String padding, String content) {
    return 'Side padding $padding  ·  Content $content';
  }

  @override
  String previewGrid(int columns, String tileWidth) {
    return 'Columns $columns  ·  Tile width $tileWidth';
  }

  @override
  String get sampleTile => 'Sample tile';

  @override
  String get sampleLongTile => 'Sample with a longer label';

  @override
  String get appTitle => 'Real Estate';

  @override
  String get homeTab => 'Home';

  @override
  String get exploreTab => 'Explore';

  @override
  String get profileTab => 'Profile';

  @override
  String get homeGreeting => 'Welcome';

  @override
  String get guest => 'Guest';

  @override
  String get featuredProperties => 'Featured';

  @override
  String get recommendedProperties => 'Our Recommendations';

  @override
  String get seeAll => 'See All';

  @override
  String get seeAllFeatured => 'See all featured properties';

  @override
  String get seeAllRecommendations => 'See all recommendations';

  @override
  String get emptyFeatured => 'No featured properties are available.';

  @override
  String get emptyRecommendations => 'No properties in this category.';

  @override
  String get categoriesUnavailable =>
      'Categories are unavailable. You can still view properties.';

  @override
  String get openPropertyFilters => 'Open property filters';

  @override
  String get refreshHome => 'Refresh listings';

  @override
  String get favoriteUnavailable => 'Favorites require sign-in.';

  @override
  String get removeFavorite => 'Remove from favorites';

  @override
  String get addFavorite => 'Add to favorites';

  @override
  String propertyMonthlyPrice(String price) {
    return '$price/mo';
  }

  @override
  String propertyRating(String rating) {
    return 'Rating $rating out of 5';
  }

  @override
  String get backToHome => 'Back to Home';

  @override
  String get explorePending => 'Explore is coming in a later phase.';

  @override
  String get profilePending =>
      'Profile and sign-in are coming in a later phase.';

  @override
  String get exploreSearchIntent => 'Search properties';

  @override
  String get exploreFeaturedIntent => 'Featured properties';

  @override
  String get exploreRecommendationsIntent => 'Recommended properties';

  @override
  String get exploreFiltersIntent => 'Property filters';

  @override
  String get propertyDetailsTitle => 'Property Details';

  @override
  String get exploreTitle => 'Search for Your Ideal Home';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get showGrid => 'Show grid';

  @override
  String get showList => 'Show list';

  @override
  String propertyResultCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Found $countString properties',
      one: 'Found 1 property',
      zero: 'No properties found',
    );
    return '$_temp0';
  }

  @override
  String get featuredOnly => 'Featured only';

  @override
  String get filterTitle => 'Filter';

  @override
  String get resetFilters => 'Reset';

  @override
  String get priceRange => 'Price Range';

  @override
  String get propertyTypeLabel => 'Property Type';

  @override
  String get homeDetailsLabel => 'Home Details';

  @override
  String get minBedroomsLabel => 'Minimum bedrooms';

  @override
  String get minBathroomsLabel => 'Minimum bathrooms';

  @override
  String get bedroomsLabel => 'Bedrooms';

  @override
  String get bathroomsLabel => 'Bathrooms';

  @override
  String get buildingSize => 'Building Size';

  @override
  String areaSquareMeters(String area) {
    return '$area m²';
  }

  @override
  String get noRangeAvailable => 'Range unavailable';

  @override
  String decreaseValue(String label) {
    return 'Decrease $label';
  }

  @override
  String increaseValue(String label) {
    return 'Increase $label';
  }

  @override
  String minimumValue(String value) {
    return 'Minimum $value';
  }

  @override
  String maximumValue(String value) {
    return 'Maximum $value';
  }

  @override
  String get filterSet => 'Set Filter';

  @override
  String get morePropertiesLoading => 'Loading more properties…';

  @override
  String get retryMoreProperties => 'Retry next page';

  @override
  String get clearFeaturedFilter => 'Clear featured filter';

  @override
  String get detailsAgent => 'Agent';

  @override
  String get detailsOverview => 'Overview';

  @override
  String get detailsFacilities => 'Facilities';

  @override
  String get detailsNoFacilities => 'No facilities listed.';

  @override
  String get detailsGallery => 'Gallery';

  @override
  String get detailsNoPhotos => 'No photos available.';

  @override
  String get detailsLocation => 'Location';

  @override
  String get detailsLatitude => 'Latitude';

  @override
  String get detailsLongitude => 'Longitude';

  @override
  String get detailsReviews => 'Reviews';

  @override
  String get detailsNoReviews => 'No reviews available.';

  @override
  String get detailsMonthlyRent => 'Monthly rent';

  @override
  String get detailsBookingUnavailable => 'Booking unavailable';

  @override
  String detailsPhotoPosition(int position, int total) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Photo $positionString of $totalString';
  }

  @override
  String detailsOpenPhoto(int position, int total) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Open photo $positionString of $totalString';
  }

  @override
  String detailsMorePhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '+$countString';
  }

  @override
  String detailsOpenMorePhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Open gallery, $countString more photos',
      one: 'Open gallery, $countString more photo',
    );
    return '$_temp0';
  }

  @override
  String detailsBedrooms(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString bedrooms',
      one: '$countString bedroom',
    );
    return '$_temp0';
  }

  @override
  String detailsBathrooms(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString bathrooms',
      one: '$countString bathroom',
    );
    return '$_temp0';
  }

  @override
  String get detailsTypeApartment => 'Apartment';

  @override
  String get detailsTypeTownhome => 'Townhome';

  @override
  String get detailsTypeHouse => 'House';

  @override
  String get detailsTypeCondo => 'Condo';

  @override
  String get detailsTypeDuplex => 'Duplex';

  @override
  String get detailsTypeStudio => 'Studio';

  @override
  String get detailsFacilityAirConditioning => 'Air conditioning';

  @override
  String get detailsFacilityBalcony => 'Balcony';

  @override
  String get detailsFacilityBikeStorage => 'Bike storage';

  @override
  String get detailsFacilityConcierge => 'Concierge';

  @override
  String get detailsFacilityCoveredParking => 'Covered parking';

  @override
  String get detailsFacilityDeck => 'Outdoor deck';

  @override
  String get detailsFacilityElevator => 'Elevator';

  @override
  String get detailsFacilityEvCharging => 'EV charging';

  @override
  String get detailsFacilityFrontPorch => 'Front porch';

  @override
  String get detailsFacilityFurnished => 'Furnished';

  @override
  String get detailsFacilityGarage => 'Garage';

  @override
  String get detailsFacilityGarden => 'Garden';

  @override
  String get detailsFacilityGym => 'Gym';

  @override
  String get detailsFacilityInUnitLaundry => 'In-unit laundry';

  @override
  String get detailsFacilityPatio => 'Patio';

  @override
  String get detailsFacilityPetFriendly => 'Pet friendly';

  @override
  String get detailsFacilityPool => 'Pool';

  @override
  String get detailsFacilityRoofTerrace => 'Roof terrace';

  @override
  String get detailsFacilitySecureEntry => 'Secure entry';

  @override
  String get detailsFacilitySharedLaundry => 'Shared laundry';

  @override
  String get detailsFacilityStorage => 'Storage';

  @override
  String get splashBrand => 'REAL SCOUT';

  @override
  String get splashTagline => 'Connecting you to your ideal home.';

  @override
  String get restoringSession => 'Restoring your session';

  @override
  String get startupError =>
      'Real Scout couldn’t restore your session. Please try again.';

  @override
  String get authWelcome => 'WELCOME TO REAL SCOUT';

  @override
  String authHeading(String emphasis) {
    return 'Let’s Get You Closer\nTo $emphasis';
  }

  @override
  String get authHeadingEmphasis => 'Your Ideal Home';

  @override
  String get authDescription => 'Sign in to Real Scout with Google';

  @override
  String get googleSignIn => 'Sign in with Google';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get signInConfigurationError =>
      'Google sign-in is unavailable on this build. You can continue as a guest.';

  @override
  String get authenticationError =>
      'The authentication request couldn’t be completed. Please try again.';

  @override
  String get signedIn => 'Signed in';

  @override
  String get signOut => 'Sign out';

  @override
  String get signingOut => 'Signing out…';

  @override
  String get verifyingProfile => 'Verifying your profile…';

  @override
  String get verifiedProfile => 'Verified profile';

  @override
  String get profileUnauthorized =>
      'Your session could not be verified. Try again or sign out and sign back in.';

  @override
  String get signInToSave => 'Sign in to save properties';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get emptyFavorites => 'No favorite properties yet.';

  @override
  String get emptyFavoritesPage => 'There are no favorites on this page.';

  @override
  String get favoriteLoading => 'Loading favorites…';

  @override
  String get favoriteUpdating => 'Updating favorites…';

  @override
  String get favoriteRetry => 'Retry loading favorite status';

  @override
  String get previousFavoritesPage => 'Previous page';

  @override
  String get nextFavoritesPage => 'Next page';

  @override
  String get profileLanguage => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get originalBlue => 'Original Blue';

  @override
  String get newPurple => 'New Purple';

  @override
  String get newOrange => 'New Orange';

  @override
  String get themeSaveError => 'Could not save the app appearance.';

  @override
  String get accountNameUnavailable => 'Name unavailable';

  @override
  String get confirmSignOut => 'Sign out of your account?';

  @override
  String get detailsOpenMap => 'Open in Maps';

  @override
  String get detailsMapOpenFailed => 'Could not open Maps.';

  @override
  String get detailsDemoLocation => 'Demo location for a fictional listing.';

  @override
  String get openAppliedPropertyFilters =>
      'Open property filters, filters applied';
}
