# Real Estate App

A Flutter recruitment assessment for Android and iOS. The intended app browses fictional rental properties from a REST API and supports English and Arabic.

The app currently opens a temporary design system preview. It uses a shared `material_ui` light theme with Blue as the default, plus Purple and Orange. The preview runs without backend or Firebase setup. Property screens, routing, production localization, API integration, sign-in, and favorites are planned.

## Setup and verification

Use Flutter **3.50.1 stable**, which includes Dart **3.14.0**. The manifest specifies Dart `^3.14.0`. Use [pubspec.lock](pubspec.lock) to reproduce the baseline package versions.

On Android, install Android SDK Platform 36 and NDK 28.2.13676358 and configure a compatible JDK for the project's Gradle toolchain. The project uses Gradle 9.5.0, Android Gradle Plugin 9.3.1, and Java/Kotlin target 17. On iOS, use macOS with Xcode and an iOS simulator or a signed device. Runner is wired to Flutter's generated Swift package and this checkout has no Podfile. Use `flutter doctor -v` to check the local toolchain and `flutter devices` to find a run target.

```sh
flutter --version
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter test --coverage
flutter build apk --debug
flutter build ios --simulator
git diff --check
flutter run
```

[analysis_options.yaml](analysis_options.yaml) uses `flutter_lints` and excludes generated build output and platform directories. The tests exercise theme roles, contrast, control interactions, RTL, and compact layouts with enlarged text.

## Design system preview

Run `flutter run` to open the preview. Use the chips to choose a theme and **العربية** or **English** to switch the sample language and direction. Try the search field, filter chips, and favorite icon. The preview also shows disabled and loading buttons and labeled feedback colors. These selections exist only while the preview is running.

Flutter's Widget Previewer exposes standard and narrow, enlarged-text views through `flutter widget-preview start`. The preview lives in [lib/preview](lib/preview). The shared theme and components live in [lib/core/design_system](lib/core/design_system). [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) records the measurements, accessible color roles, and pinned, locally bundled Rubik fonts.

## Dependencies and planned architecture

| Packages | Role |
| --- | --- |
| `material_ui`, `cupertino_icons` | Material theme and controls used by the preview, with Cupertino icons available for later screens |
| `hooks_riverpod`, `riverpod_annotation`, `riverpod_generator`, `flutter_hooks` | Generated providers for dependency injection and state, with hooks for local widget state where useful |
| `dio`, `go_router` | REST transport and declarative navigation |
| `freezed`, `freezed_annotation`, `json_serializable`, `json_annotation`, `build_runner` | Immutable models, JSON DTOs, and their generation workflow |
| `flutter_localizations`, `intl`, `shared_preferences` | English and Arabic ARB strings via Flutter's localization generator, locale-aware formatting, and persisted language selection |
| `firebase_core`, `firebase_auth`, `google_sign_in` | Firebase initialization, user sessions, and Google account sign-in |
| `cached_network_image`, `flutter_svg`, `skeletonizer` | Property image caching, SVG assets, and loading placeholders |
| `flutter_test`, `mocktail`, `flutter_lints` | Flutter tests, test doubles, and static analysis rules |

The planned structure is feature-first. Presentation reads application state, application logic depends on domain contracts, and data adapters handle REST requests and DTO mapping. The properties feature will group home, explore, filters, and details. Core will hold shared configuration, transport, errors, localization, and design tokens. English is the planned default, with Arabic layout direction and language switching at runtime. See the [implementation plan](IMPLEMENTATION_PLAN.md).

## Backend reference and future configuration

The planned production default is [`https://real-estate-api-gray.vercel.app/api/v1`](https://real-estate-api-gray.vercel.app/api/v1). The future typed configuration will read `API_BASE_URL` with `String.fromEnvironment`, preserve the `/api/v1` prefix, and require HTTPS in production. Once implemented, developers can pass an override with `flutter run --dart-define=API_BASE_URL=https://real-estate-api-gray.vercel.app/api/v1`. Local overrides are for development.

[API_CONTRACT.md](API_CONTRACT.md) is a byte-for-byte copy from the sibling `real-estate-api` checkout at revision `d92fdf0b84e76ac8977efc6c17ff67e59ab66c26`. The contract covers public listings, details and filter options, protected profile and favorite operations (including `GET /favorites/ids`), pagination, English and Arabic responses, and error envelopes. The source documents describe deployment verification as pending. Phase 0 confirmed that the supplied deployment's health endpoint returned HTTP 200 with `data.status: "ok"`. The deployed Git revision and endpoint behavior beyond liveness remain unverified. [Public health endpoint](https://real-estate-api-gray.vercel.app/api/v1/health)

The backend uses fictional rental data and external property images. Google Sign-In, Firebase ID-token verification, and authenticated favorites persistence still require live testing.

## Mobile platform configuration

| Setting | Value |
| --- | --- |
| Android application ID and namespace | `com.example.real_estate_app` |
| Android minimum SDK | 24, inherited from Flutter |
| Android compile and target SDK | 36, inherited from Flutter |
| iOS Runner bundle identifier | `com.example.realEstateApp` |
| iOS deployment target | 15.0 |

The platform minimums match the installed Firebase and Google Sign-In plugins. This checkout has no Firebase client configuration, Google Services Gradle plugin, iOS Google Sign-In URL scheme, or Firebase initialization.

During the approved authentication phase, register the confirmed Android and iOS IDs in the same Firebase project as the backend, enable the Google provider, and generate client options with FlutterFire CLI. Configure Android signing fingerprints for the builds that will sign in. The Android plugin supports Google Services Gradle configuration with a web OAuth client entry or an explicit web client ID via `serverClientId`. On iOS, configure the client ID and reversed-client-ID URL scheme in Runner. The locked `google_sign_in` 7.2.0 uses `GoogleSignIn.instance.initialize()` before mobile `authenticate()`. The signed-in Firebase user supplies the ID token for protected REST requests. Firebase Admin credentials stay on the backend.

Android's source manifests declare internet access for debug and profile. Verify that the merged release manifest declares `INTERNET` when integrating networking. The release build currently uses debug signing.
