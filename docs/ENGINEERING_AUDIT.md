# Phase 9.2 engineering audit

The approved Real Scout design and feature set were preserved. The audit tightened the Dart HTTP credential boundary and added adapter-level regression coverage. The audit originally identified missing Flutter assets and unresolved artwork redistribution rights. The required assets are now tracked. Redistribution rights remain unresolved.

## Environment and verification

| Check | Result |
| --- | --- |
| SDK | Flutter 3.50.1 stable (ae9b586f34), Dart 3.14.0, macOS arm64 |
| Android | Existing arm64 Android emulator, API 37. Installed debug app, min SDK 24 and target SDK 36. OpenJDK 21.0.13.1. Repository pins Gradle 9.5.0 and AGP 9.3.1 |
| Formatting | `dart format --output=none --set-exit-if-changed lib test` passed, 126 files, zero changes |
| Analysis | `flutter analyze` passed |
| Tests | `flutter test --coverage --reporter expanded` passed, 294 tests. Before the correction, 293 passed |
| Line coverage | 4,236 of 4,678 LCOV instrumented lines (90.55%), including generated code where instrumented |
| Generation | `dart run build_runner build` succeeded. The sole generated diff is the expected Dio provider hash. Localization inputs were unchanged |
| Android runtime | Installed debug app cold-launched on API 37. Flutter attach, hot reload and hot restart succeeded. The UI exposed Home navigation and Featured listings after restart. No new APK, profile, or release build |
| iOS | Static review only. Build and runtime deferred to Phase 9.3 |
| Backend | Local API contract matches sibling checkout d92fdf0 byte for byte. The historical backend suite was not rerun |

The developer approved visuals on a physical device and previously confirmed live Google sign-in and favorites persistence. Those checks and earlier iOS verification are historical. Automated tests cover Splash timing, routing, localization, responsive layouts, auth and token transport, property and filter behavior, map fallback, and favorites concurrency using deterministic doubles. This phase did not use a live Google account or mutate production.

## Findings

### P0

No confirmed P0 in the reviewed scope.

### P1

- **ENG-01 · Clean-checkout reproducibility · Resolved in Phase 9.3.1.** Commit `6d1cea1` restored the Auth collage and three theme logos at their registered paths. The clean GitHub main clone passed dependency resolution, analysis, tests and the Android debug build. APK inspection verified all four restored assets. Redistribution remains open under ENG-02.
- **ENG-02 · Original-art redistribution rights unresolved · Open delivery blocker.** The Auth collage carries a Freepik watermark, and redistribution grants for the supplied marks remain unverified. The verified GitHub revision includes the collage, theme logos and native derivatives in Android `mipmap-*` and the iOS `AppIcon.appiconset` and `LaunchImage.imageset` catalogs. Obtain clearance or approve licensed replacements before distributing builds or captures. Review any copies already shared. [Asset provenance](../assets/ASSET_LICENSES.md#phase-911--supplied-figma-exports)

### P2

- **ENG-03 · Protected traffic accepted any same-origin API path · Resolved.** [api_client.dart](../lib/core/network/api_client.dart#L46) formerly gated tokens on origin and the base-path prefix alone. A same-origin public or unrelated endpoint erroneously marked protected could receive a Firebase ID token. The current call sites were correctly classified and no credential disclosure was observed. The interceptor now checks method and endpoint before requesting credentials. [Adapter tests](../test/api_client_test.dart#L203) cover public destinations mislabeled as protected, method mismatches, unsafe favorite paths and valid favorite writes with redirects disabled.

### P3

No confirmed P3 requiring a change in the reviewed scope.

## Security and platform boundaries

One shared Dio client strips caller authorization, checks protected destinations, disables protected redirects and uses Firebase SDK tokens on demand. Firebase owns session persistence. The profile provider rejects mismatched IDs and cancels obsolete reads. Favorites binds reads and writes to the active account, tracks pending mutations per ID, and merges only the affected ID after an uncertain outcome. Current tests cover account switches, logout and re-entry with the same UID, rollback and locale independence. Automatic HTTP replay remains disabled; backend verification failures can be retried without signing out a valid Firebase session. No direct Cloud Firestore SDK is resolved by the app. Local backend rules deny all client reads and writes. Deployed-rule confirmation is historical and was not refreshed.

A targeted filename, tracked-content and Git history scan found no service-account document, PEM private-key marker or signing keystore. Firebase client configuration is present and intentionally shareable. This was a limited scan. App and bundle IDs are `com.majdjabbour.realestate`, with iOS deployment target 15.0. Android has Internet permission, and no location permission is needed for property maps. Android release uses debug signing by explicit Gradle configuration, which is suitable for assessment sideloading and unsuitable for store distribution.

Advisory review was targeted. The Dart Pub extraction advisory affects earlier SDKs. The reviewed Dio HTTP/2 adapter advisory concerns an adapter absent from this lockfile. `shared_preferences_android` resolves to 2.5.5, above the affected range of the reviewed advisory. A complete native and transitive advisory inventory remains unverified. [Dart advisory](https://github.com/dart-lang/sdk/security/advisories/GHSA-q739-79rh-vmvp) · [Dio advisory](https://github.com/advisories/GHSA-cr65-55v9-xhvv) · [Shared preferences advisory](https://github.com/flutter/packages/security/advisories/GHSA-3hpf-ff72-j67p)

## Performance and map

Source inspection found lazy Home and Explore builders, viewport-aware Explore paging with no-progress detection, selective heart subscriptions, bounded display-image decoding, owned controller cleanup, and cancelled obsolete requests. The fullscreen viewer retains image detail for zoom. No frame timing, memory, network-volume or startup benchmarks were collected. No performance changes were justified by the evidence.

Resolved map dependencies are flutter_map 8.3.2, latlong2 0.10.1 and url_launcher 6.3.3. Details uses property coordinates and zoom 15, a theme marker, HTTPS tiles, visible attribution, app identification, and zero tile buffers. Installed flutter_map uses its default native network cache and disposes the provider through TileLayer. The map uses separate tile transport without Firebase credentials. External Maps uses validated property coordinates and an external HTTPS launch. Provider uptime, cache behavior under real traffic and render timing were not remeasured. OSM tile capacity and usage terms still apply. [OSM tile policy](https://operations.osmfoundation.org/policies/tiles/)

## Read-only production checks

| Requests | Observed |
| --- | --- |
| Health | 200, JSON successful envelope, no-store |
| Listing pages 1 and 2, limit 2 | 200, 30 total, 15 pages, expected next and previous flags |
| Featured and apartment filters | 200, totals 10 and 5 |
| Search for modern and combined price, area and bedroom filter | 200, valid empty paginated envelopes |
| Filter options | 200, successful JSON envelope |
| Known detail in English and Arabic | 200 with different localized titles and matching Content-Language |
| Unknown detail | 404, PROPERTY_NOT_FOUND |
| Anonymous auth/me, favorites and favorites/ids | 401, UNAUTHORIZED, private, no-store |

Localized public responses returned `Vary: Accept-Language` and `Cache-Control: no-store`. The anonymous 401s establish current rejection behavior. Previous Vercel ESM mitigation is documented in README. Authenticated writes, deployed Firestore rules and live account switching were outside the checks performed.

## Remaining limitations and delivery decision

The standard static asset pipeline and native configuration are intact. Physical-device visual approval remains the design reference. Intentional contrast constraints include white on Purple at 4.11:1 and white on Orange at 2.52:1, with certain Orange indicators below 3:1. Unsupported Detail contact and Profile actions retain localized unavailable feedback. Properties are fictional. Debug signing and the use of public tile infrastructure limit distribution. Full iOS verification is deferred.

**Public delivery remains blocked by ENG-02.** Obtain redistribution permission or approve licensed replacements before packaging for distribution.

## Phase 9.3.1 final verification

GitHub main was cloned into a temporary checkout at `b547946ed8df941b5890a976586836a3ef71b0f7`. The clone contained the declared Flutter assets, Firebase client configuration, generated Dart sources, Dart and Swift package lockfiles, and Android and iOS native resources.

| Check | Result |
| --- | --- |
| `flutter pub get` | Passed with the tracked lockfiles unchanged |
| `flutter analyze` | Passed with no issues |
| `flutter test --coverage` | 294 passed, 4,238 of 4,682 instrumented lines covered (90.52%) |
| `flutter build apk --debug` | Passed. All 35 declared Flutter assets matched the APK byte for byte. The compiled APK also contained native launcher, launch and splash resources and the Firebase app ID resource |

The temporary checkout and APK were removed. iOS verification for this phase was limited to tracked files. Prior Android runtime and iOS results remain historical. The original assessment brief was unavailable in the checked repositories. Delivery screenshots or a short demo remain pending under the implementation plan.
