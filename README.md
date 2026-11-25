# Real Estate App

A Flutter recruitment assessment for Android and iOS. The intended app browses fictional rental properties from a REST API and supports English and Arabic.

Real Scout restores the saved language, appearance and Firebase session at startup. A fresh installation uses English and Original Blue. Home and Explore load fictional rental listings from the deployed API. Profile shows the active account and provides access to My Favorites, Language, Appearance and Sign out.

## Setup and verification

Use Flutter **3.50.1 stable**, which includes Dart **3.14.0**. The manifest specifies Dart `^3.14.0`. Use [pubspec.lock](pubspec.lock) to reproduce the baseline package versions.

On Android, install Android SDK Platform 36 and NDK 28.2.13676358 and configure a compatible JDK for the project's Gradle toolchain. The project uses Gradle 9.5.0, Android Gradle Plugin 9.3.1, and Java/Kotlin target 17. On iOS, use macOS with Xcode and an iOS simulator or a signed device. Runner is wired to Flutter's generated Swift package and this checkout has no Podfile. Use `flutter doctor -v` to check the local toolchain and `flutter devices` to find a run target.

```sh
flutter --version
flutter pub get
flutter gen-l10n
dart run build_runner build
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter test --coverage
flutter build apk --debug
flutter build ios --simulator
git diff --check
flutter run
```

[analysis_options.yaml](analysis_options.yaml) uses `flutter_lints` and excludes build output and platform directories. The test suite covers appearance, responsive layouts, locale startup and persistence, URL validation, request policy, property DTOs, query encoding, repository behavior, Explore search, pagination, filters and navigation, and Details request lifecycles, media and layout. Network tests use fake Dio adapters and Riverpod overrides. Phase 7.2 passed all 256 tests with 90.7% overall line coverage. The suite also covers Firebase repository behavior, profile authorization and session races, startup redirects, both languages, and Auth at compact and enlarged widths. Production smoke checks are separate. [Phase 7.2 verification](AI_USAGE.md#phase-72--firebase-authentication-and-session)

## Design system preview

Run `flutter run -t lib/preview/main.dart` to open the isolated development preview. The preview is separate from the app's routes and does not fetch property data. Use the chips to choose a theme and **العربية** or **English** to switch the app language and direction. Language survives a restart. Theme, filter, and favorite samples reset when the preview closes.

Flutter's Widget Previewer exposes standard, narrow with enlarged text, and landscape views through `flutter widget-preview start`. The preview lives in [lib/preview](lib/preview). The shared theme and components live in [lib/core/design_system](lib/core/design_system). [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) records the measurements, accessible color roles, and pinned, locally bundled Rubik fonts.

Scroll to **Adaptive layout** to see the local viewport size, side padding, capped content width, grid columns, and tile width. The placeholder tiles wrap with the available width and system text size. [Responsive layout policy](lib/core/layout/responsive_layout.dart) · [Design system width strategy](DESIGN_SYSTEM.md#implemented-width-strategy)

## Dependencies and architecture

| Packages | Role |
| --- | --- |
| `material_ui`, `cupertino_icons` | Material theme and controls used by the preview, with Cupertino icons available for later screens |
| `hooks_riverpod`, `riverpod_annotation`, `riverpod_generator`, `flutter_hooks` | Generated providers for dependency injection and state, with hooks for local widget state where useful |
| `dio`, `go_router` | REST transport and declarative navigation |
| `freezed`, `freezed_annotation`, `json_serializable`, `json_annotation`, `build_runner` | Immutable models, JSON DTOs, and their generation workflow |
| `flutter_localizations`, `intl`, `shared_preferences` | English and Arabic ARB strings via Flutter's localization generator, locale-aware formatting, and persisted language and theme selections |
| `firebase_core`, `firebase_auth`, `google_sign_in` | Firebase initialization, user sessions, and Google account sign-in |
| `cached_network_image`, `flutter_svg`, `skeletonizer` | Property image caching, SVG assets, and loading placeholders |
| `flutter_test`, `mocktail`, `flutter_lints` | Flutter tests, test doubles, and static analysis rules |

The app uses a feature-first structure. Presentation reads application state, application logic depends on domain contracts, and data adapters handle REST requests and DTO mapping. The properties feature groups Home, Explore, Filters, and Details. Core holds shared configuration, transport, errors, localization, and design tokens. English is the default, with Arabic layout direction and language switching at runtime. [Implementation plan](IMPLEMENTATION_PLAN.md)

## Bootstrap and infrastructure

`main.dart` initializes the Flutter bindings through `bootstrap.dart`, loads the saved language and theme through one `SharedPreferencesAsync` instance, and mounts the root app inside `ProviderScope`. Generated providers own app configuration, the locale controller, the token-source boundary, and one Dio client. Preference writes are serialized per setting. The root applies a locale after a successful write and applies a theme immediately. The theme uses the stable IDs `blue`, `purple`, and `orange`. Missing or unrecognized values fall back to English and Original Blue. Appearance changes reuse the existing router, providers, and palette-aware Details tint.

Add or update translations in `lib/l10n/app_en.arb` and `app_ar.arb`, then run `flutter gen-l10n`. The root uses the generated app delegate with the installed `material_ui` delegates for automatic RTL and LTR. When changing provider annotations, run `dart run build_runner build`. Generated Dart files are checked into the project alongside their inputs.

## API configuration and request policy

The default base is [`https://real-estate-api-gray.vercel.app/api/v1/`](https://real-estate-api-gray.vercel.app/api/v1/). `AppConfig` reads `API_BASE_URL`, retains the configured path, normalizes the trailing slash, and rejects malformed URLs, credentials, queries, and fragments. Use `flutter run --dart-define=API_BASE_URL=https://example.test/api/v1` to select a different HTTPS server. Non-release builds also permit HTTP for loopback and private development addresses. The target platform's cleartext policy still applies.

Dio uses 15-second connect and send timeouts and a 20-second receive timeout. It accepts and decodes JSON, applies the current `Accept-Language` per request, and rejects in-flight localized results from a prior language revision as cancellation. Favorites membership and mutation results are language independent. `requestApi` accepts a `CancelToken`, a typed decoder, and an explicit public or protected access policy. Public calls strip authorization. Protected calls use an injected token source, require the configured scheme, authority, and API path, and disable automatic redirects. Production bootstrap injects the current Firebase user’s ID-token source. Public and preview test entry points can supply fakes or use the default empty source.

The response parser validates the success envelope and optional pagination before returning a typed payload. HTTP and transport failures preserve status codes and safe backend error codes where available. User messages come from a separate localization mapper. Cancellation has no display message, and raw headers, payloads, and server diagnostics are excluded from failure text and application logging.

[API_CONTRACT.md](API_CONTRACT.md) is a byte-for-byte copy from the sibling `real-estate-api` checkout at revision `d92fdf0b84e76ac8977efc6c17ff67e59ab66c26`. The contract covers public listings, details and filter options, protected profile and favorite operations (including `GET /favorites/ids`), pagination, English and Arabic responses, and error envelopes. Phase 0 confirmed that the supplied deployment's health endpoint returned HTTP 200 with `data.status: "ok"`. The deployed Git revision remains unverified. [Public health endpoint](https://real-estate-api-gray.vercel.app/api/v1/health)

The backend uses fictional rental data and external property images. The developer confirmed a successful live Google sign-in and verified backend profile. Authenticated favorites persistence remains a manual check.

Phase 2 smoke checks returned HTTP 200 for `GET /health` and `GET /properties?limit=1` in English and Arabic. The listings returned the same property ID, localized titles, matching `Content-Language` headers, and contract-shaped pagination. On the iPhone 18 Pro Max simulator, the app switched from English/LTR to Arabic/RTL and restored Arabic after a full process restart.

## Property data layer

[Properties](lib/features/properties) provides a domain repository for paginated summaries, detail by ID, and global filter options. The [domain models](lib/features/properties/domain) are independent of Flutter and Dio. Freezed supplies value equality and copying where useful, and domain collections are snapshotted. Details include a summary and typed agent, location, and review values. [Data adapters](lib/features/properties/data) use generated JSON decoding for response DTOs and map straightforward nested values directly to their domain types. The agent object is required and its avatar may be null. Amounts, ratings, coordinates, and histogram edges accept integer or decimal JSON numbers. Counts stay integers. Unknown property type IDs and facility keys are preserved. Unknown property types have no known enum value and cannot be selected using the current typed query. Price and area units come from the response.

The default query encodes `sortBy=createdAt&sortOrder=desc&page=1&limit=20`. For example, a query with apartment and condo, a price cap, zero bedrooms, and non-featured results encodes the following decoded parameters:

```text
types=apartment,condo&maxPrice=1500.25&minBedrooms=0&featured=false&sortBy=price&sortOrder=asc&page=2&limit=10
```

The query trims search, omits blank search and empty type sets, and encodes type IDs in canonical order. Decimal bounds use plain decimal notation. The constructor and `copyWith` enforce the API's ranges, page and limit bounds, and 120-code-point search limit. Search, filtering, sorting, and pagination run on the server. Listing calls return summaries and shared pagination metadata. The filter endpoint supplies global bounds and localized type labels in server order. Null and equal bounds and empty or single-bucket histograms are supported.

The generated `propertyRemoteDataSourceProvider` and `propertyRepositoryProvider` use the shared Dio client and auto-dispose when unobserved. They hold dependencies only. All three requests are public and inherit request-time language headers and typed failures. A caller can pass `RequestCancellation`, which the data source bridges to a per-request Dio token and detaches when the request finishes. Future screen providers should watch `appLocaleProvider`, cancel their request scopes on invalidation or disposal, reset locale-sensitive state, and guard writes after each await against superseded queries or request generations. The shared client already rejects responses from obsolete locale revisions. Phase 3 adds no property cache or screen controllers.

### Production verification

Separate English and Arabic GETs for the listing, featured listing, details for `rental-022`, and filter options returned HTTP 200 with matching `Content-Language` and `Vary: Accept-Language`. The two-item listing returned 30 total results over 15 pages, and the featured query returned 10 over five. Both locales returned the same IDs, prices, units, and histogram counts. Titles, addresses, descriptions, review comments, and type labels were localized. The detail included a required agent with a null avatar, coordinates, image and review arrays, and UTC timestamps. Filter options returned 20 buckets, including decimal edges, and counts totaling 30. Local fixtures cover empty and equal-bound shapes. Production HTTP is outside the automated suite.

The Phase 3 test and coverage runs both passed all 146 tests. [Verification log](AI_USAGE.md#phase-3--property-data-layer)

## Production navigation and Home

`MaterialApp.router` uses a generated Riverpod `GoRouter`. Home, Explore, and Profile use an indexed tab shell, preserving Home's scroll position and category when switching tabs. Property cards push `/properties/:propertyId` on the root navigator. Explore handles Home intents and displays paginated property results. Details loads the selected property from the API on that root route. Profile provides a language switch, Google sign-in for guests, and verified account information and sign-out for authenticated users.

| Home action | Destination |
| --- | --- |
| Search field | Explore with the search intent |
| Filter icon | Explore with the filter-opening intent |
| Featured See All | Explore with the Featured intent |
| Recommendations See All | Explore with the current category ID |
| Featured or grid card | Full-screen property route with the returned ID |

Home starts three independent public requests. Featured uses `GET /properties?featured=true&limit=5`, Recommendations uses `GET /properties?limit=6`, and categories come from `GET /properties/filter-options`. Listings use the repository's page-one, newest-first defaults. Selecting a category adds its server ID to the recommendation query and leaves the other reads alone. All clears the type constraint. Language changes keep the selected type and refresh all localized data. The mounted tab retains its current section results in memory. Providers cancel obsolete requests, discard late results, and dispose when unobserved. Only the image cache persists property media.

Loading placeholders reserve carousel and grid geometry. Each section can show its own empty or error state and retry independently. Pull to refresh or use the Home accessibility refresh action to rerun all three requests while keeping the current sections visible during a same-query refresh. Cancellation has no error message, and image failures show a localized placeholder without hiding the listing.

Home uses a guest avatar, reusable featured and grid cards, image and rating widgets, and separate favorite controls. Favorites require sign-in and notifications are disabled. Prices use locale-aware USD monthly formatting. The layout takes its gutters and grid columns from the shared responsive policy, uses a horizontal featured carousel and category strip, and lazily builds variable-height grid rows in one vertical scroll view. The tab bar uses native safe areas and mirrors in Arabic. [Design comparison](DESIGN_SYSTEM.md#16-phase-41-icons-and-home-refinement) · [English Home](docs/screenshots/phase-4.1/home-en.png) · [Arabic Home](docs/screenshots/phase-4.1/home-ar.png) · [Compact Home](docs/screenshots/phase-4.1/home-compact.png)

Home and the tab shell use the original Iconly SVG paths, including distinct active and inactive navigation variants. The shared `AppIcon` chooses the asset, inherits semantic tint, and mirrors the directional back glyphs. The Explore accent and rating gradient retain their separate paints. [Icon provenance and license](assets/ASSET_LICENSES.md) · [Figma icon inventory](assets/FIGMA_ICON_INVENTORY.md)

## Explore and Advanced Filters

Explore owns one generated Riverpod listing controller. Its immutable state keeps the applied `PropertyQuery`, loaded summaries, server pagination, and operation-specific loading and failure states. The search field, focus, scroll, and grid/list selection live in the navigation branch. Grid is the default. Switching layout reuses the current results and page state. Both layouts open the root property route by ID.

Search waits 400 ms after typing and submits immediately from the keyboard action or clear button. Search and category changes preserve applicable filters and sort order, reset to page one, and cancel outdated requests. Results are server-owned. Explore requests 20 results per page and loads another page near the scroll end or when the first page leaves space. IDs are deduplicated in server order. Pagination stops at the last page or when a page adds no new IDs. A failed next page keeps the existing cards and has an explicit retry. Same-query pull-to-refresh retains visible results during the request. Locale changes preserve stable selected IDs, search and filters while reloading titles and labels.

The filter sheet shares the locale-aware filter-options provider with Home and Explore. It keeps draft types, price and area bounds, and minimum room counts until Set Filter. Reset affects the draft. Dismissing the sheet discards it. An unchanged draft produces no listing request. Applying edits preserves search, sorting and the featured flag, and encodes selected types through the existing query serializer. All and unrestricted ends of ranges omit those filters. Prices are displayed in USD per month and area in square meters. The histogram paints global API bucket boundaries and counts. It shares the native slider's direction and track insets. Null or equal bounds produce a read-only state. Reset and Apply stay reachable on compact and enlarged-text layouts.

Home Search focuses Explore's search field. Featured opens a featured-only query with a visible clear control. Recommendation See All applies its category. The Home filter action opens the sheet once per intent. Returning to Explore through its tab preserves ordinary state. [Explore visual comparison](DESIGN_SYSTEM.md#17-phase-5-explore-and-advanced-filters)

## Property Details

Home and Explore open `/properties/:propertyId` on the root navigator. Back restores the originating branch and its scroll position. A directly opened route can return to Home. The generated auto-dispose `propertyDetailsProvider` shares one request per observed ID, watches the current locale, cancels on invalidation or disposal, and rejects results from obsolete requests. A retry explicitly reloads the same ID. Details uses the existing repository, public API request policy, and localized failure messages.

The hero and thumbnails use the cached property image widget. The hero supports swiping and preserves a valid page index on language reloads. The first three photos appear in Gallery, with an optional count for the remaining photos. Tapping a photo opens the full-screen, swipeable viewer at that image. Pinch to zoom and drag to pan a zoomed photo. Missing images and agent avatars have shared fallbacks. The responsive layout caps Details content at 680 dp and wraps long English and Arabic text.

Stats and USD monthly rent use localized formatting. Facilities map the 21 keys in the current API fixture to localized labels and Flutter SDK icons. Unknown keys retain a readable label and a neutral icon. Location displays the localized API address and identifies it as a fictional listing location. Reviews display each returned entry's author, rating, comment, and localized date. The current review schema supplies no avatar, so reviewers use the shared person placeholder. [Facility label and icon mapping](lib/features/properties/presentation/details/property_facilities.dart)

The rounded price footer saves or removes the property via the same session-scoped favorite action as the hero heart. Guests can start contextual sign-in and return to the property. The address includes an Open in Maps action for valid API coordinates, using `url_launcher` and Google Maps URLs. The app loads no map tiles. Agent contact and sharing are omitted, and all returned reviews are displayed inline. [Design comparison](DESIGN_SYSTEM.md#18-phase-6-property-details) · [Icon inventory](assets/FIGMA_ICON_INVENTORY.md)

Profile, authentication, and favorite persistence remain future work.

## Mobile platform configuration

| Setting | Value |
| --- | --- |
| Android application ID and namespace | `com.majdjabbour.realestate` |
| Android minimum SDK | 24, inherited from Flutter |
| Android compile and target SDK | 36, inherited from Flutter |
| iOS Runner bundle identifier (Debug, Profile, Release) | `com.majdjabbour.realestate` |
| iOS RunnerTests bundle identifier | `com.majdjabbour.realestate.RunnerTests` |
| iOS deployment target | 15.0 |
| Native app display name | Real Scout |
| Dart package name | `real_estate_app` |

Real Scout is the proposed mobile display name, taken from the design reference's wordmark. Phase 7.0 applies it to the Android and iOS app labels. Both builds passed, and inspection of the APK and simulator app confirmed the packaged identifiers and display name. Dependency resolution preserved the lockfile, static analysis found no issues, and all 226 tests passed. [Phase 7.0 verification](AI_USAGE.md#phase-70--native-platform-preparation)

The Android debug variant uses the standard Gradle debug signing configuration with the local `AndroidDebugKey` certificate. The scaffold also uses debug signing for its release variant. Run `cd android && ./gradlew :app:signingReport` to obtain the fingerprints for your local debug certificate. Phase 7.0 cross-checked its report against the signed APK. [Local verification fingerprints](AI_USAGE.md#phase-70--native-platform-preparation)

### Firebase setup

The checkout uses the existing Firebase project `real-estate-app-91394` and the registered Android and iOS apps for `com.majdjabbour.realestate`. The generated `lib/firebase_options.dart`, `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` contain client configuration. Firebase Admin credentials are configured in the backend deployment. [FlutterFire setup](https://firebase.google.com/docs/flutter/setup)

- **Android.** The Google Services Gradle plugin supplies the web OAuth client as `default_web_client_id` for Google Sign-In. The refreshed config also contains the matching Android OAuth client. Firebase's read-only SHA listing confirmed both fingerprints for the local debug certificate. For another developer or distribution signing key, register the certificate fingerprints for the existing Firebase Android app and refresh its client file as needed. [Android plugin setup](https://pub.dev/packages/google_sign_in_android/versions/7.2.19)
- **iOS.** Runner bundles `GoogleService-Info.plist` as a target resource via the existing Xcode project. Runner's `Info.plist` copies its Apple OAuth client to `GIDClientID` and its reversed client ID to `CFBundleURLTypes`. Flutter registers the native plugins through its generated Swift package. Firebase Auth exchanges the Google ID token on the client, so an iOS `GIDServerClientID` is unnecessary for this flow. [iOS plugin setup](https://pub.dev/packages/google_sign_in_ios/versions/6.4.0)

### Session and profile

- The OS shows its existing native launch screen while Flutter starts. Flutter's `/splash` reflects Firebase setup and the first Firebase session event. A startup failure offers a retry. A stable GoRouter updates from those events, preserves valid public deep links, and keeps Home, Explore, and Profile in the existing indexed shell.
- The auth repository calls `GoogleSignIn.instance.initialize()` once, uses `authenticate()`, and exchanges the Google ID token for a Firebase credential. Firebase owns session persistence. A separate action provider handles in-flight requests and cancellation. Home shows the Firebase account's available name and avatar with fallbacks.
- On Profile, `GET /auth/me` uses the same Dio client with protected access and maps `id`, `email`, `name`, and `avatar`. UID changes or logout cancel obsolete profile requests. Backend outages leave the Firebase session active and offer retry. A 401 shows a verification failure with retry or reauthentication. This phase relies on Firebase SDK token renewal and performs zero automatic HTTP replays.
- Guests can browse, search, filter and view details and can open the existing Google sign-in flow from Profile or a protected favorite action. After confirmed sign-out the app clears verified profile and private favorites state and remains on the guest Profile. Locale and theme preferences remain available.

### Live account verification

Confirm the Google provider is enabled for the Firebase project and the OAuth consent configuration permits the test account. On the Android emulator or iOS simulator, select **Sign in with Google** and complete Google's prompts in the emulator or simulator. Open **Profile** and confirm the verified name/email and successful `GET /auth/me` in a debugger with authorization headers redacted. Quit and relaunch the app to confirm the account restores and Profile can verify again. Use **Sign out**, confirm the guest state and the loss of private profile access, then confirm Home, Explore and property details still work. Repeat on the other platform.

The developer confirmed live Google sign-in, the actual account name and avatar, and a verified backend profile. The developer resolved Vercel’s `ERR_REQUIRE_ESM` with `NODE_OPTIONS=--experimental-require-module`. A November 25, 2026 credential-free request to `GET /auth/me` returned HTTP 401 with `UNAUTHORIZED` and `Cache-Control: private, no-store`. Cold-start restoration, live sign-out, account switching and live sign-in on both platforms still require platform-specific confirmation. [Phase 7.2 verification](AI_USAGE.md#phase-72--firebase-authentication-and-session)

## Favorites and Profile

Phase 8 passes 281 tests with 90.70% overall line coverage. The tests cover the four favorites endpoints and response parsing, session isolation, optimistic updates and reconciliation, the Profile actions, and theme and locale behavior. [Verification details](AI_USAGE.md#phase-8--favorites-profile-and-preferences)

My Favorites is a root destination at `/favorites`, opened from Profile. The three bottom tabs remain Home, Explore and Profile. Favorites displays the API’s localized property summaries in server order in pages of 20. Previous and Next use the actual pagination metadata and pull-to-refresh reloads the current page. Orphaned references may be present in membership and are excluded from the list by the API.

The generated favorites controller loads `GET /favorites/ids` once per active session. Every heart derives its state from the same immutable ID set. The list uses its own localized `GET /favorites` request. Add and remove optimistically change the relevant heart and send one PUT or DELETE. Operations on different properties can proceed independently. A definite failure rolls back only its property. For a timeout, connection error or similarly uncertain outcome, the controller performs one bounded membership read and merges the affected ID only. If the read fails, that ID stays unknown and its retry reads the server before allowing another write. Successful changes refresh the open Favorites page. Flutter uses the existing Dio client with an account-bound Firebase ID token and cancels obsolete requests on sign-out or account changes.

A guest heart opens a localized sign-in explanation and offers Google sign-in or cancellation. Sign-in opens over the current browsing destination and returns to it on success or cancellation. Tap the heart again after signing in. Profile uses the verified backend name, email and avatar where available, with Firebase fields as per-field fallbacks. It shows a placeholder when the avatar is unavailable and offers a retry for verification failures. Language saves through the existing locale controller. Appearance offers the three existing palettes. See the design notes for supported actions and intentional visual deviations. [Profile and Favorites design](DESIGN_SYSTEM.md#phase-8--profile-favorites-and-appearance)

### Live favorites verification

Anonymous production GET requests for `/favorites` and `/favorites/ids`, and anonymous PUT and DELETE for `/favorites/rental-022`, all returned 401 with the contract’s `UNAUTHORIZED` error. The deployed default Firestore rules release was read with authorized Firebase CLI access and matched the checked-in deny-all rules.

Authenticated production verification remains with the developer. On each platform:

1. Sign in with the authorized test account and confirm the account shown in Profile. In a debugger with authorization headers redacted, confirm `GET /favorites/ids` returns 200. Record whether `rental-022` is initially saved.
2. Change the heart in Details and confirm Home and Explore reflect that change wherever the same property appears. Open Profile → My Favorites and confirm `GET /favorites` returns 200 and shows the expected list. Query the IDs again after a cold relaunch to confirm the change persisted.
3. Exercise both add and remove. Restore `rental-022` to its original state and confirm it on a fresh read. Confirm sign-out clears Profile and Favorites, guest controls offer sign-in, and another authorized account starts with its own membership. Keep tokens and personal account information out of logs and screenshots.

### Phase 8 screenshots

Captured on an Android emulator with a synthetic signed-in account and test favorites. Home uses the deployed public listings. Profile uses its missing-avatar state.

- Profile · [English](docs/screenshots/phase-8/profile-en.png) · [Arabic](docs/screenshots/phase-8/profile-ar.png) · [320 dp](docs/screenshots/phase-8/profile-compact.png)
- My Favorites · [Populated](docs/screenshots/phase-8/favorites.png) · [Empty](docs/screenshots/phase-8/favorites-empty.png)
- Preferences · [Language](docs/screenshots/phase-8/language.png) · [Appearance](docs/screenshots/phase-8/appearance.png)
- Home · [Original Blue](docs/screenshots/phase-8/home-blue.png) · [New Purple](docs/screenshots/phase-8/home-purple.png) · [New Orange](docs/screenshots/phase-8/home-orange.png)

### Phase 9.1 visual verification

The native Android and iOS launcher and launch screen use an original Blue house mark. Flutter Splash uses the same artwork with the persisted palette once Flutter starts. Native launch resources are static and cannot read the Dart preference. [Brand provenance](assets/ASSET_LICENSES.md#phase-91--splash-and-native-brand-mark)

The [Phase 9.1 captures](docs/screenshots/phase-9.1/) use synthetic account and property fixtures for public comparison, with Blue and Purple in English and Orange in Arabic. The iOS Auth image is from the simulator. [Comparison and known gaps](DESIGN_SYSTEM.md#phase-91--figma-fidelity-and-native-branding)

The address action opens a coordinate search only after a tap. No API key, map tile service, or billing is required in the app. Out-of-range coordinates leave the address visible, and a failed handoff shows a localized message. [Google Maps URLs](https://developers.google.com/maps/documentation/urls/get-started) · [url_launcher](https://pub.dev/packages/url_launcher)
