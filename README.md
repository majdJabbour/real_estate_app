# Real Scout

Real Scout is a bilingual Flutter recruitment assessment for Android and iOS. It lets users explore fictional rental properties from a deployed REST API and save listings to a Google-backed account.

## Development approach

I directed and reviewed the AI-assisted development of Real Scout, retaining ownership of the architecture, technical decisions, scope, quality standards, and final acceptance. ChatGPT supported planning and technical review, and Codex implemented and verified changes under my direction. [AI usage and developer decisions](AI_USAGE.md)

## Backend strategy

The assessment suggested a public mock API such as DummyJSON. I evaluated that option and chose to build a dedicated backend to support bilingual real estate data, property-specific queries, and account-scoped favorites.

The backend uses Next.js and TypeScript on Vercel. It serves bilingual property details and reviews, performs search, filtering, sorting, and pagination on the server, and exposes dynamic filter options and a price histogram. Firebase Admin SDK verifies Firebase ID tokens, and Firestore persists favorites per account. The API uses consistent response envelopes and error handling. [Backend repository](https://github.com/majdJabbour/real_estate_api)

The previously verified backend baseline was **288 passing tests** and **99.4% line coverage**.

## Main features

- **Home and Explore** feature rental recommendations, searchable grid and list views, and server-side filtering and pagination. Advanced Filters uses the API’s price histogram and ranges.
- **Property Details** includes a swipeable photo gallery with zoom, property facts, facilities, reviews, a live OpenStreetMap preview and an external map action.
- **Authentication and Profile** support guest browsing, Google sign-in, session restoration, My Favorites, language and appearance settings, and logout. Favorite changes update across screens and recover if a save fails.
- **Responsive layouts** adapt to narrower phones, larger system text, and both text directions.

## Technology stack

| Technology | Role |
| --- | --- |
| Flutter 3.50.1 stable, Dart 3.14.0, `material_ui` | Mobile UI and shared design components |
| Riverpod and `riverpod_generator`, `go_router` | State, dependency injection, and persistent tab navigation |
| Dio, Freezed, `json_serializable`, `build_runner` | REST transport, immutable models, and generated JSON decoding |
| Firebase Auth and Google Sign-In | Google authentication and Firebase session management |
| Flutter `gen_l10n`, `intl`, `shared_preferences` | Translations, locale-aware formatting, and persistent preferences |
| `cached_network_image`, `flutter_svg`, `skeletonizer` | Cached media, vector assets, and loading states |
| Flutter Map, `latlong2`, `url_launcher` | Embedded maps, geographic coordinates, and external map handoff |
| `flutter_test`, Mocktail, `flutter_lints` | Automated tests, test doubles, and static analysis |

## Architecture and project structure

The app is organized by feature. Presentation reads Riverpod application state. Application logic depends on domain contracts, and data adapters implement those contracts through Dio and Firebase. The indexed navigation shell retains the Home, Explore, and Profile tabs. Details and My Favorites open as dedicated routes.

At my direction, startup initialization was consolidated into `lib/main.dart` to remove an unnecessary layer of indirection. It loads saved locale preferences before mounting the app and supplies a deferred Firebase initialization callback. Startup order, authentication repository caching, retry behavior, and the two-second minimum cold splash were preserved.

| Path | Contents |
| --- | --- |
| [lib/main.dart](lib/main.dart) | App entry point, locale preference loading, and deferred Firebase initialization |
| [lib/app](lib/app) | Root app, navigation, and tab shell |
| [lib/core](lib/core) | Network policy, configuration, errors, responsive layout, and design system |
| [lib/features](lib/features) | Properties, authentication, favorites, and profile |
| [lib/l10n](lib/l10n) | English and Arabic translations |
| [android](android) and [ios](ios) | Native runners and client configuration |
| [test](test) | Unit, provider, and widget tests |

## Setup

Use Flutter **3.50.1 stable** with Dart **3.14.0** and the checked-in [package lockfile](pubspec.lock). For Android, install SDK Platform 36 and NDK 28.2.13676358, and use a JDK compatible with Gradle 9.5.0. Use a Google Play emulator image or a device with Google Play services for Google sign-in. For iOS, use macOS with Xcode and an iOS 15 or later target. The runner uses Flutter’s Swift Package Manager integration.

From the repository root, with a mobile target running or connected:

```sh
flutter doctor -v
flutter pub get
flutter devices
flutter run
```

Generated Dart sources are checked in. After editing translations, run `flutter gen-l10n`. After changing generated providers or models, run `dart run build_runner build`.

## Production API

The default base URL is `https://real-estate-api-gray.vercel.app/api/v1`. Public property reads work in guest mode. Localized requests send `Accept-Language`, while profile and favorites use Firebase ID tokens. To target another compatible HTTPS backend, use `flutter run --dart-define=API_BASE_URL=https://example.test/api/v1`. [API contract](API_CONTRACT.md)

## Firebase authentication

The checkout includes the Flutter, Android, and iOS client configuration for the existing Firebase project. The Android application ID and iOS bundle ID are both `com.majdjabbour.realestate`. Firebase Admin credentials stay on the backend.

For a different Android signing key, run `cd android && ./gradlew :app:signingReport`, register the SHA-1 and SHA-256 fingerprints in Firebase, and refresh `google-services.json` as needed. On iOS, keep the Google OAuth client and reversed-client callback scheme aligned with the Firebase configuration. A separate Firebase project requires a backend configured to accept its tokens. [FlutterFire setup](https://firebase.google.com/docs/flutter/setup)

### Live account verification

Open Profile, sign in with Google and confirm the backend-verified identity. Cold-relaunch the app to check session restoration. Sign out, confirm private data clears, then verify public browsing and account switching.

### Live favorites verification

With an authorized test account, save a property and confirm its heart state across Details, Home and Explore. Reopen My Favorites after a cold relaunch to confirm persistence. Remove the property and verify the list and hearts update. Restore the test account’s original favorites afterward.

## Localization and themes

English and Original Blue are the fresh-install defaults. Profile lets users switch between English and Arabic and choose Original Blue, New Purple, or New Orange. Changes apply immediately and persist across launches. Arabic mirrors the layout and loads Arabic property content from the API.

## Screenshot gallery

### Splash & Authentication

The native launch, in-app splash, and both Google sign-in captures remain private pending clearance for the supplied brand mark and collage.

### Home

| Featured rentals and recommendations |
| --- |
| <img src="docs/screenshots/en/home-blue.png" alt="Featured rentals and recommendations" width="220"> |

### Explore Grid & List

| Explore in grid view | Explore in list view |
| --- | --- |
| <img src="docs/screenshots/en/explore-grid-blue.png" alt="Explore in grid view" width="220"> | <img src="docs/screenshots/en/explore-list-blue.png" alt="Explore in list view" width="220"> |

### Advanced Filters

| Price histogram, property types, rooms, and area |
| --- |
| <img src="docs/screenshots/en/advanced-filters-blue.png" alt="Price histogram, property types, rooms, and area" width="220"> |

### Property Details

| Property overview and agent |
| --- |
| <img src="docs/screenshots/en/property-details-blue.png" alt="Property overview and agent" width="220"> |

### Gallery & Maps

| Facilities, photos, and map loading | Photo gallery, live map, and reviews |
| --- | --- |
| <img src="docs/screenshots/en/property-details-map-loading.png" alt="Facilities, photos, and map loading" width="220"> | <img src="docs/screenshots/en/property-details-map-and-reviews.png" alt="Photo gallery, live map, and reviews" width="220"> |

Map data © [OpenStreetMap contributors](https://www.openstreetmap.org/copyright).

### My Favorites

My Favorites is available from Profile. The capture set has no dedicated My Favorites screen.

### Profile & Preferences

| Signed-in profile | Profile menu and My Favorites entry | Language selection |
| --- | --- | --- |
| <img src="docs/screenshots/en/profile-identity.png" alt="Signed-in profile" width="220"> | <img src="docs/screenshots/en/profile-menu.png" alt="Profile menu and My Favorites entry" width="220"> | <img src="docs/screenshots/en/profile-language-dialog.png" alt="Language selection" width="220"> |

| Appearance selection |
| --- |
| <img src="docs/screenshots/en/profile-appearance-dialog.png" alt="Appearance selection" width="220"> |

### Arabic & RTL

| Arabic Explore list | Arabic advanced filters | Arabic property details |
| --- | --- | --- |
| <img src="docs/screenshots/ar/explore-list-blue-rtl.png" alt="Arabic Explore list" width="220"> | <img src="docs/screenshots/ar/advanced-filters-blue-rtl.png" alt="Arabic advanced filters" width="220"> | <img src="docs/screenshots/ar/property-details-blue-rtl.png" alt="Arabic property details" width="220"> |

### Blue, Purple & Orange Themes

| Arabic Home in Original Blue | Arabic Home in New Purple | Arabic Home in New Orange |
| --- | --- | --- |
| <img src="docs/screenshots/themes/home-blue-rtl.png" alt="Arabic Home in Original Blue" width="220"> | <img src="docs/screenshots/themes/home-purple-rtl.png" alt="Arabic Home in New Purple" width="220"> | <img src="docs/screenshots/themes/home-orange-rtl.png" alt="Arabic Home in New Orange" width="220"> |

Property photography in the gallery comes from the demo API. [Asset licenses and attribution](assets/ASSET_LICENSES.md)

## Testing and verification

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter test --coverage
flutter build apk --debug
```

The historical full-suite baseline comes from a clean GitHub clone of revision `b547946`. Dependency resolution, static analysis, **294 tests**, and the **Android debug build** passed. Line coverage was **90.52%** (4,238 of 4,682 instrumented lines). All 35 declared Flutter assets matched the packaged APK. [Verification evidence](docs/ENGINEERING_AUDIT.md#phase-931-final-verification)

After the startup consolidation, **35 focused startup and authentication tests** passed, along with Dart formatting and Flutter analysis. No runtime verification was performed after that change. Earlier Android runtime and iOS build and runtime checks are historical. The developer separately performed manual functional checks and approved the visuals on a physical device. [Verification history](AI_USAGE.md#verification-summary)

## Assumptions and limitations

- Listings, locations and prices are fictional. Rent is monthly in USD and area is in square meters. Photos and live map tiles depend on external services. The map displays OpenStreetMap attribution.
- Booking, payments, messaging, notifications, and other inactive Profile actions are outside the assessment scope.
- Live Google sign-in and backend profile verification were confirmed by the developer. Platform-by-platform confirmation of session restoration, logout, account switching and authenticated favorites persistence remains open.
- The supplied brand marks and sign-in collage have unresolved redistribution rights. Public distribution of the repository or builds containing those assets requires permission or licensed replacements. [Asset licenses and attribution](assets/ASSET_LICENSES.md)

## Documentation

- [Design system](DESIGN_SYSTEM.md)
- [API contract](API_CONTRACT.md)
- [Engineering verification](docs/ENGINEERING_AUDIT.md)
- [AI usage](AI_USAGE.md)
