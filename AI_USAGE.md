# AI usage

## Phase 0 — Baseline and documentation

The developer asked Codex to inspect the Flutter scaffold, platform settings, and installed dependencies, copy the current backend contract with its source revision, document the baseline, and run the requested checks. The developer limited the task to Phase 0 and reserved implementation, Firebase setup, and Git commits for later approval.

Codex used Git, shell inspection, cached SDK and package sources, Flutter CLI, and an HTTP GET to inspect the workspace and verify the baseline. Codex updated [README.md](README.md), copied [API_CONTRACT.md](API_CONTRACT.md) byte-for-byte from backend revision `d92fdf0b84e76ac8977efc6c17ff67e59ab66c26`, and wrote this log. The Dart static analysis skill informed the analyzer check.

| Check | Result |
| --- | --- |
| `flutter pub get` | Succeeded with six newer-version notices. The manifest and lockfile match the baseline. |
| `flutter pub outdated` | Succeeded. Newer versions appeared for `cupertino_icons`, `vector_math`, `material_color_utilities`, `test_api`, `xml`, and `built_collection`. The direct dev dependencies were current. |
| `flutter analyze` | Passed with no issues. |
| `flutter test` | Passed the single existing counter smoke test. |
| `git diff --check` and whitespace checks for new files | Passed. |
| Contract snapshot | Matched the sibling file and the source revision's Git blob. |
| Production health | HTTP 200 with `data.status: "ok"`. [Health endpoint](https://real-estate-api-gray.vercel.app/api/v1/health) |

Android and iOS builds, device runs, full deployed API behavior, live sign-in, authenticated Firestore persistence, and the deployed Git revision remain unverified. The two existing commits and the developer's untracked `AGENTS.md` and `IMPLEMENTATION_PLAN.md` were present at the start of the task. Developer review is pending.

## Phase 1.1 — Figma design analysis and theme planning

The developer approved Phase 0 and requested a read-only comparison of Original Blue, New Purple and New Orange, with Blue as the proposed default. The request covered all eight screens per variant, exact source measurements, asset and font provenance, and a shared Flutter theme proposal.

Codex read the engineering guidelines, implementation plan, API contract, README, and existing Flutter scaffold. With the Figma inspection skill and Figma MCP, Codex inventoried 24 frames, compared layer geometry, styled text, fills, effects, vector paths and image references, and captured 27 renders. Read-only SVG export checks and image-size queries established asset availability for the sampled nodes. The design file received no edits. Upstream font metadata and license documentation informed the Arabic font review. The Community copy and embedded third-party artwork still require provenance verification.

Codex created [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) with node references, variant differences, component and asset inventories, contract mapping, and proposed theme, width and RTL behavior. `git diff --check`, a whitespace check for the new Markdown file, and the source and dependency diff checks passed. This was documentation work, so no Flutter build, rendering, or test run was performed. Arabic shaping, responsive layouts, and exact runtime assets remain unverified. Phase 1.1 is pending developer review.

## Phase 1.2 — Shared multi-theme design system

The developer approved continuation from Phase 1.1 and specified the source palette, the Blue layout and tint decisions, Rubik weights, accessibility thresholds, and four shared primitives. The requested app entry point is a temporary preview for Blue, Purple and Orange with English and Arabic.

Codex inspected the installed Flutter and `material_ui` APIs and used the widget preview, responsive layout, widget test, unit test and static analysis skills. Codex implemented the shared theme, four controls and preview, and replaced the counter test. Four static Rubik files and their original SIL OFL 1.1 license came from a pinned upstream revision, with no package changes. Fontconfig and HarfBuzz verified sample coverage and shaping. The accessible foregrounds, focus and disabled styles, selected indicators and temporary preview controls are documented in [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md).

| Check | Result |
| --- | --- |
| `flutter pub get` | Passed. Dependency versions and lockfile match the baseline. |
| `dart format --output=none --set-exit-if-changed lib test` | Passed across 8 files. |
| `flutter analyze` | Passed with no issues. |
| `flutter test` and `flutter test --coverage` | Both passed with 23 tests. LCOV recorded 303 of 326 instrumented lines. |
| `flutter build apk --debug` | Passed. |
| `flutter build ios --simulator` | Passed without signing. |
| Native preview | Ran and hot reloaded on an iPhone 18 Pro simulator on iOS 27.2. Used Flutter's debug service to activate the preview controls and captured all three variants with CoreSimulator. Visually checked the Orange RTL layout. |
| `git diff --check` | Passed. |

Android device execution, Figma pixel parity, and artwork provenance remain unverified. Phase 1.2 is pending developer review.

## Phase 1.3 — Responsive and adaptive layout foundation

The developer approved Phase 1.2 and requested a local-constraint width and grid policy, a temporary adaptive preview, and responsive verification. Codex used the Flutter responsive layout, widget preview, widget testing, Dart unit testing, and static analysis skills. Codex added the geometry calculator, centered content helper, and lazy placeholder rows. The existing controls passed the narrow RTL and enlarged-text tests as implemented.

| Check | Result |
| --- | --- |
| `flutter pub get` | Passed. The dependency manifests match the baseline. |
| `dart format --output=none --set-exit-if-changed lib test` | Passed across 12 files. |
| `flutter analyze` | Passed with no issues. |
| `flutter test` and `flutter test --coverage` | Both passed with 50 tests. LCOV recorded 405 of 428 instrumented lines. |
| Simulator preview | Ran and hot reloaded on an iPhone 18 Pro Max with iOS 27.2. Flutter's debug service constrained the preview to 320 and 430 dp and rotated the full-screen app for the 832 dp landscape case. Codex inspected all three simulator screenshots. |
| `git diff --check` | Passed. |

The simulator run compiled the app for verification. Standalone platform builds were skipped for this Flutter-only phase. Real property cards and their localized data are future verification work. Phase 1.3 is pending developer review.

## Phase 2 — Core infrastructure

The developer approved Phase 1.3 and requested the bootstrap, configurable API client, token-source boundary, typed contract handling, and persisted English/Arabic localization. Codex used the localization, pattern matching, unit testing, widget testing, and static analysis skills, verified the installed APIs, and implemented the infrastructure and tests. The app-level theme moved to the root, and the preview uses generated translations and the app locale controller.

| Check | Result |
| --- | --- |
| `flutter pub get` | Passed with the existing dependency versions and lockfile. |
| `flutter gen-l10n` and `dart run build_runner build` | Passed. Three localization files and three provider files matched byte-for-byte across consecutive runs. |
| Formatting and `flutter analyze` | Passed. The analyzer reported no issues. |
| `flutter test` and `flutter test --coverage` | Both passed with 93 tests, including all 50 existing cases. LCOV recorded 711 of 827 instrumented lines. |
| Public production smoke check | Health and the English and Arabic one-item property listings returned HTTP 200. Both listings returned `rental-022` with different localized titles, language headers and valid pagination. |
| iPhone 18 Pro Max simulator | Ran and hot reloaded on iOS 27.2. Flutter's debug service activated the preview language button and confirmed Arabic/RTL. CoreSimulator showed the saved `ar` preference and the restored Arabic preview after process termination and launch. |
| `git diff --check` | Passed. |

Property repositories, authenticated traffic, and Android runtime verification remain future checks. Phase 2 is pending developer review.

## Phase 3 — Property data layer

The developer approved Phase 2 for continuation and requested the public property repository, contract verification, domain and transport models, query encoding, cancellation, generated providers, and deterministic tests. Codex read the project and sibling backend references, inspected the installed generators and Riverpod APIs, and used the Dart unit-testing and static-analysis skills. Codex implemented the data layer and extracted the existing fake Dio adapter for reuse in tests. The existing pagination data moved into a shared model, with JSON validation staying in the API response parser. Freezed formatting is enabled through the generator configuration. No generated files were edited by hand.

| Check | Result |
| --- | --- |
| Public production smoke checks | Separate English and Arabic GETs for listing, featured listing, details for `rental-022`, and global filter options all returned HTTP 200 with matching `Content-Language` and `Vary: Accept-Language`. The payloads matched the copied contract. The normal and featured listings had 30 and 10 results respectively. The detail returned a required agent with a null avatar. The filter response returned 20 price buckets with integer and decimal edges and counts totaling 30. |
| `flutter pub get` | Passed with six newer-version notices. The manifest and lockfile match the Phase 2 commit. |
| `flutter gen-l10n` and `dart run build_runner build` | Passed. All 12 generated source files matched byte-for-byte across runs, including the six new Phase 3 outputs. |
| `dart format --output=none --set-exit-if-changed lib test` and `flutter analyze` | Passed across 56 Dart files. The analyzer reported no issues. |
| `flutter test` and `flutter test --coverage` | Both passed all 146 tests, including the 93 prior tests and 53 new cases. LCOV recorded 1,026 of 1,144 instrumented lines overall (89.7%) and 302 of 303 in the properties feature (99.7%). |
| Existing preview | Flutter attached to the running iPhone 18 Pro simulator on iOS 27.2 and hot reloaded. A simulator capture showed the Orange preview rendered in Arabic RTL. Existing widget tests exercised preview controls, themes, locale, and responsive layouts. Native builds were skipped for this data-only phase. |
| `git diff --check` | Passed. The new untracked source, fixture, and configuration files also pass whitespace checks. |

The production deployment revision, live authenticated behavior, and property UI integration remain unverified. Phase 3 is pending developer review.

## Phase 4 — Production navigation and Home

The developer approved Phase 3 and requested production navigation, the Home screen, live public API data, reusable cards, and visual verification. Codex used the Figma design-to-code and inspection skills to review the three Home variants, the selected tab states, and the underlying vector geometry. Codex used the Flutter routing, localization, responsive layout and widget-testing skills and the Dart unit-testing and static-analysis skills. Work included the indexed tab shell and root details route, an isolated preview entry point, generated Home providers, localized Home widgets, and deterministic tests. The Figma reference was read only. No source artwork was bundled.

| Check | Result |
| --- | --- |
| `flutter pub get` | Passed with six informational update notices. The manifest and lockfile match Phase 3. |
| `flutter gen-l10n` and `dart run build_runner build` | Passed. All 14 generated Dart files matched byte-for-byte on the second pass. |
| Formatting and `flutter analyze` | Passed across 73 Dart files. The analyzer reported no issues. |
| `flutter test` and `flutter test --coverage` | Both passed all 178 tests, including the 146 existing tests and 32 Phase 4 cases. LCOV recorded 1,665 of 1,831 instrumented lines overall (90.9%) and 532 of 566 for Home and navigation (94.0%). |
| iOS simulator and production API | Xcode built and Flutter ran the app on iPhone 18 Pro Max with iOS 27.2. Home displayed the deployed API's featured and recommended listings, photos, and localized category labels. The Flutter debug service selected each language and scrolled the live grid. One Flutter engine frame-timestamp diagnostic was logged during debug work. The app continued rendering and hot reloaded after the changes. |
| Figma visual comparison | Compared the final 440 × 956 dp English captures to Blue `1:4426`. Also inspected Arabic RTL and a temporary 320 dp constraint on the same simulator with live data. The constraint was removed after capture and the original simulator locale and scroll position were restored. The comparison and screenshots are in [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md#15-phase-4-home-and-navigation). |
| `git diff --check` | Passed. |

Explore, Filters, full Details, Profile data, authentication, and persistent favorites remain pending. Android runtime was outside this verification pass. Phase 4 is pending developer review.

## Phase 4.1 — Original Figma icons and Home refinement

The developer approved Phase 4 functionally and requested source icon fidelity, provenance, Home refinements, and a new live visual comparison. Codex used the Figma design-to-code and inspection skills to read the eight Blue frames, inspect matching vector paths, paint roles, and selected states across palettes, and export the eleven Iconly assets used by the app. Codex checked Piqo Studio's free release, Figma's Community licensing, and Iconsax's distinct redistribution terms. The asset docs record attribution, export changes, the measurement inventory, and outstanding artwork origins. No Figma frames were edited. [Provenance](assets/ASSET_LICENSES.md) · [Inventory](assets/FIGMA_ICON_INVENTORY.md)

Codex added the shared Flutter SVG renderer, retained the independent control semantics, and compared the running Home with its Phase 4 captures and Blue Figma node `1:4426`. The clipped Explore handle edge was added after the Arabic simulator review showed the pale handle had low visibility on white. The label and themed icon tints, native insets, guest avatar, accessible search border, and selected-chip checkmark are documented differences. [Design comparison](DESIGN_SYSTEM.md#16-phase-41-icons-and-home-refinement)

| Check | Result |
| --- | --- |
| `flutter pub get` | Passed with six informational update notices. The lockfile matches Phase 4. The manifest diff registers three SVG asset directories. |
| Formatting and `flutter analyze` | Passed over 75 Dart files with no analyzer issues. |
| `flutter test` and `flutter test --coverage` | Both passed all 185 tests, including the original 178, six icon cases, and a tap-driven locale and tab regression case. LCOV recorded 1,691 of 1,856 instrumented lines (91.1%). Tests parsed and rasterized all registered SVGs and checked sizing, semantic ownership, theme paint isolation, and pixel-level RTL behavior. |
| iOS simulator | Built and ran on the same iPhone 18 Pro Max at 440 × 956 dp with live property data. Captured English Home, the recommendation grid, Arabic Home, and a temporary 320 dp viewport. The Arabic tab states were exercised through the running shell. Flutter hot reloaded and hot restarted the final changes. One direct debugger-driven restore call reached the router during a frame and triggered a build-phase assertion. The tap-driven regression test switched tabs while a locale save was pending and completed without an exception. |
| SwiftPM files | Both files are tracked in the Phase 4 commit and byte-identical. They pin 16 native transitive packages for the Flutter-generated Swift package. They were left in place for reproducible Xcode resolution. Apple recommends checking an app's package-resolution lockfile into Git. [Apple Xcode package documentation](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app?language=swift) |
| `git diff --check` | Passed. |

The selected favorite, guest avatar, and image placeholders retain Material glyphs. The Google mark, Iconsax variants, Real Scout branding, and unnamed facility, stat and map artwork remain inventoried for later review. Phase 4.1 is pending developer review.

## Phase 5 — Explore and Advanced Filters

The developer approved Phase 4.1 and requested Explore, server search and pagination, and the advanced filter sheet. Codex read the repository and backend references, inspected all nine Explore and Filters references with the Figma design-to-code skill, and used the Dart and Flutter testing and static analysis skills. Codex implemented the shared Explore controller and both layouts, localized and accessible filter controls, Home route intents, and deterministic tests. An enlarged-text widget test exposed an Arabic Reset label overflow at 320 dp. Constraining its width resolved the overflow while keeping Reset and Set Filter reachable.

The Blue Figma references guided card geometry, search and category controls, modal shape, and histogram and slider alignment. Explore adds a layout toggle. The modal uses backend units and localized labels. Phase 5 reuses licensed Iconly assets and uses documented fallbacks for the filter and counter glyphs. [Design review and screenshots](DESIGN_SYSTEM.md#17-phase-5-explore-and-advanced-filters) · [Icon inventory](assets/FIGMA_ICON_INVENTORY.md)

Production read-only checks returned 30 listings across two pages with distinct IDs, two matches for the combined English search and filters, and six for the Arabic search. Both languages returned the same 20 global price buckets with localized option labels. On the iPhone 18 Pro Max simulator, a compact Arabic filter draft was applied and returned five apartments. The captures exercised the real app with live data. A temporary debug entry point sent pointer events outside frame build and constrained the compact viewport. The entry point is excluded from delivery. The tap-based widget regressions exercised repeated Home intents and localization without triggering the earlier build-phase router assertion.

| Check | Result |
| --- | --- |
| `flutter pub get` | Passed with six informational package notices. The manifest and lockfile match Phase 4.1. |
| `flutter gen-l10n` and `dart run build_runner build` | Passed. All 16 generated Dart files matched byte-for-byte across consecutive runs. |
| Formatting and `flutter analyze` | Passed over 83 Dart files with no analyzer issues. |
| `flutter test` and `flutter test --coverage` | Both passed all 207 tests, including the 185 existing cases. LCOV recorded 2,482 of 2,701 instrumented lines overall (91.9%) and 647 of 692 in the Explore controller, screen and filter controls (93.5%). |
| iOS simulator | The standard `lib/main.dart` entry point built, launched, and hot reloaded on the iPhone 18 Pro Max. The visual captures are linked in the design review. |
| `git diff --check` | Passed. |

Android runtime and full Details, Profile, authentication, and favorite persistence remained outside Phase 5. The developer approved Phase 5 for continuation.

## Phase 6 — Property Details

The developer approved Phase 5 and requested the Details route, gallery, localized API data, responsive layouts, and verification. Codex inspected the sibling API contract and fixture and used Figma MCP with the Figma design-to-code and Figma Plugin API skills to inspect the three Details variants. The Flutter responsive layout, static analysis, and Dart and Flutter testing skills guided the implementation. Codex added one generated request provider, presentation widgets, English and Arabic strings, two licensed Iconly exports, and 19 deterministic tests. The gallery pinch test exposed a conflict with horizontal paging. Codex adjusted paging while multiple pointers are active or the photo is zoomed and verified both paging and pinch interaction.

The existing public repository supplies the route data and cancellation bridge. Codex reused the property image and favorites controls, extracted the existing monthly price formatter for both cards and Details, and kept carousel selection local. The returned address and coordinates replace the sample map, all returned reviews appear inline, the price footer marks booking unavailable, and agent contact and share are omitted. The approved backend contract reference and dependency versions are unchanged. [Figma comparison and simulator screenshots](DESIGN_SYSTEM.md#18-phase-6-property-details) · [Asset provenance](assets/ASSET_LICENSES.md#phase-6-property-details)

Public production requests for `rental-001` returned HTTP 200 in English and Arabic with matching `Content-Language` headers. A valid unknown ID returned HTTP 404 with `PROPERTY_NOT_FOUND`. On the iPhone 18 Pro Max, a Home tap opened Brick Row Townhome and an Explore tap opened Eastside Staircase Duplex. Captures used a temporary debug entry point with the real app and production configuration, pointer events, and a 320 dp constraint for the compact image. The capture helper is excluded from delivery.

| Check | Result |
| --- | --- |
| `flutter pub get` | Passed on Flutter 3.50.1 and Dart 3.14.0. The lockfile is unchanged. |
| `flutter gen-l10n` and `dart run build_runner build` | Passed. All 17 generated Dart files matched byte-for-byte after rerunning both generators. |
| Formatting, `flutter analyze` and `git diff --check` | Passed. Formatting verified 91 Dart files and analysis reported no issues. |
| `flutter test` and `flutter test --coverage` | Passed all 226 tests, including the 207 existing cases. LCOV recorded 3,075 of 3,359 instrumented lines overall (91.5%) and 480 of 497 in the Details provider and presentation (96.6%). |
| iOS simulator | The standard `lib/main.dart` entry point built, launched and hot reloaded. The live Details and gallery captures are linked in the design review. |
| Android debug build | `flutter build apk --debug` passed. Android runtime remains unverified in Phase 6. |

The developer approved Phase 6 functionally and authorized Phase 7.0.

## Phase 7.0 — Native platform preparation

The developer requested the shared mobile identifier `com.majdjabbour.realestate`, the proposed Real Scout display name, and build and signing verification before Firebase setup. Codex inspected the Android Gradle and manifest configuration, the iOS Runner and RunnerTests targets, the locked sign-in plugin documentation, and the Firebase setup guides. The app contract matches the sibling backend reference at `d92fdf0b84e76ac8977efc6c17ff67e59ab66c26` byte for byte. Codex used the Dart static-analysis skill for verification.

Codex updated the Android application ID and namespace, moved `MainActivity` into the matching package, and set the launcher label. In Xcode, Codex updated the Runner and RunnerTests IDs in Debug, Profile and Release and set the display and bundle names to Real Scout. The test target still loads `Runner.app`. The Dart package is `real_estate_app`. Android SDK levels, iOS 15.0 deployment target, SwiftPM project references and resolution files, dependencies, and lockfile were preserved. Firebase registration, initialization, and authentication remain pending developer approval.

| Check | Result |
| --- | --- |
| `flutter pub get` | Passed on Flutter 3.50.1 stable and Dart 3.14.0. Six informational package update notices. The dependency manifest and lockfile were unchanged. |
| `flutter analyze` | Passed with no issues. |
| `flutter test` | All 226 existing tests passed. |
| `flutter build apk --debug` | Passed. `aapt` confirmed the application ID, launcher label, and `com.majdjabbour.realestate.MainActivity`. The APK installed and the activity reached the foreground on the Pixel 10 Pro XL Android emulator. |
| `flutter build ios --simulator` | Passed with Xcode 27.2. The built plist confirmed the bundle ID, Real Scout label, and iOS 15.0 minimum. The app installed and launched on the iPhone 18 Pro Max simulator running iOS 27.2. |
| `./gradlew :app:signingReport` | Passed. The debug variant uses Gradle's standard debug config and `AndroidDebugKey` alias. `apksigner` independently matched both public certificate fingerprints against the built APK. |
| `git diff --check` | Passed. |

- Debug SHA-1: `59:21:4B:64:2E:DE:A7:1E:4A:55:25:A8:BA:11:71:EE:BB:8A:E2:CB`
- Debug SHA-256: `37:8B:45:8F:E0:17:1E:4D:48:59:CF:60:BF:C4:47:5C:65:73:E2:F0:12:7C:D4:24:FC:B1:62:28:8E:AF:41:3C`

Phase 7.0 is ready for developer review. Runtime verification covered app launch on the emulator and simulator. Physical device and live authentication checks are pending.

## Phase 7.2 — Firebase authentication and session

The developer approved Phase 7.0, supplied the Phase 7.2 scope, and had already registered the Android and iOS apps and generated their local files with FlutterFire CLI. The request covered native OAuth verification, Splash and Auth from the six Figma frames, Google-to-Firebase sign-in, restoration and logout, guest access, the protected backend profile, bilingual responsive presentation, and deterministic and native verification.

Codex used Git, the cached package sources for `firebase_core` 5.2.0, `firebase_auth` 7.1.0, `google_sign_in` 7.2.0, Android 7.2.19 and iOS 6.4.0, the Figma design-to-code skill and MCP, the responsive layout, Dart test, Flutter widget test and static analysis skills, and ImageGen. The image prompt requested nine original property photographs in a shared three-column composition without brand artwork. The original Figma photos and logo remain reference-only. Google Developers supplied the official mark and Google Fonts supplied the OFL-licensed button font. Fonttools prepared a static Latin subset in a temporary environment. [Asset provenance](assets/ASSET_LICENSES.md#authentication-assets)

Firebase CLI read the existing Android app's registered SHAs and current SDK config. Both SHA fingerprints match the local debug key. The prior JSON contained OAuth type 3 only. The refreshed JSON adds the Android client for the matching package/certificate and the linked iOS OAuth client while preserving the project, native app ID and web client. The local FlutterFire option blocks match each native app and Runner bundles the Firebase resource with the matching Google callback. Firebase and production checks were read-only.

| Check | Observed result |
| --- | --- |
| Flutter dependencies, localization, and generated source | `flutter pub get`, `flutter gen-l10n` and `dart run build_runner build` passed. `pubspec.lock` is unchanged. A second generation produced byte-identical Dart output. |
| Static verification | Repository-wide formatter check, `flutter analyze` and `git diff --check` passed. |
| Tests | All 256 passed both normally and with coverage. The suite retains 226 prior cases and adds 30, including the official raster asset check. LCOV measured 90.7% overall (3,469/3,824 lines) and 91.2% under the authentication feature (302/331). |
| Android | `flutter build apk --debug` built the APK. Installed and ran on the Pixel 10 Pro XL Android emulator. Flutter hot restart completed. The app reached Auth and loaded guest Home. Arabic selected from Profile persisted on cold restart. Auth actions were reachable by scrolling at 320 dp. The emulator was returned to its original display size and English. |
| iOS | `flutter build ios --simulator` built Runner. Installed and launched on the iPhone 18 Pro Max simulator (iOS 27.2) and confirmed the guest Auth screen. |
| Deployed API | Credential-free GETs on November 25 returned HTTP 200 and successful envelopes for health and listings. Repeated credential-free GETs for `/auth/me` returned an empty HTTP 500, where the contract specifies 401. |
| Live account | No interactive Google account access was provided. Google credential exchange, authenticated profile HTTP 200, session restoration after full restart, and sign-out with a real account remain to be verified on both platforms. Covered with deterministic fakes and adapters. |

The Blue Auth comparison used Android and iOS captures and the Figma frame. The rendered hierarchy, three image columns, fade, central headings and pill control follow the reference. The original illustration is represented by localized Splash typography with real progress. Auth differs in the generated photos, tile spacing, Google branding treatment, native safe areas and the added guest action. The compact and enlarged layouts keep actions scrollable. The Splash capture is Flutter’s production widget rendered with restoration pending in a test harness. Actual native launch screens remain the OS-owned experience.

Account verification uses the [manual steps in README.md](README.md#live-account-verification). The implementation retains the SDK session on temporary backend errors and uses explicit retry. HTTP 401 causes verification failure without automatic token replay. Android Credential Manager can report some configuration failures as cancellation after account selection, as documented by the installed plugin. Phase 8 remains pending developer review. [Android plugin integration notes](https://pub.dev/packages/google_sign_in_android/versions/7.2.19)


Screenshots are available locally under `/private/tmp/real-scout-phase-7.2/`:

- `splash-flutter-harness.png`
- `android-auth-en.png` and `ios-auth-en.png`
- `android-auth-ar.png`
- `android-auth-compact-ar.png` and `android-auth-compact-controls-ar.png`
- `android-guest-home.png`

## Phase 8 — Favorites, Profile, and preferences

The developer approved Phase 8, confirmed real Google Sign-In with the actual account name and avatar and successful backend profile verification, and reported that setting `NODE_OPTIONS=--experimental-require-module` in Vercel resolved `ERR_REQUIRE_ESM`. The developer chose to carry out authenticated production favorites verification. Phase 8 used an isolated emulator and synthetic account for private-data visual and interaction checks.

Codex inspected the checked-in and sibling API contracts, backend pagination and favorite handlers, Flutter auth/session/token code, property components, GoRouter, design tokens, and localization. It verified that the contract is byte-identical to the backend checkout at `d92fdf0b84e76ac8977efc6c17ff67e59ab66c26`. Figma MCP inspected all three Profile frames and provided the licensed chevron, language and sign-out SVG exports. The original filled-heart variant could not be verified in the free set, so the existing Material fallback is retained. After comparing the emulator Profile with Original Blue, Codex corrected the title, name and menu glyph foregrounds and retook the affected screenshots.

Changes cover the Favorites domain, remote data source, DTO, repositories, generated providers and screen. The active account and revision scope private reads and writes. A shared ID set drives the hearts, and definite failures roll back only the ID involved. A bounded reconciliation read resolves uncertain outcomes when possible. The Profile replacement uses verified account fields with Firebase fallbacks. Settings use the existing locale controller and theme factory with the persisted `blue`, `purple` and `orange` IDs. The account token boundary, auth modal, root router, property hearts, translations, tests, screenshots and asset attribution were also updated.

| Verification | Evidence |
| --- | --- |
| Toolchain and checks | Flutter 3.50.1 and Dart 3.14.0. Package resolution, localization and code generation, formatting, analysis, and diff checks passed. A second generation run reproduced every generated source byte for byte. Both full test runs passed 281 tests, including all 256 existing tests and 25 additions. Line coverage was 90.70% overall, 95.67% for Favorites and 92.63% for Profile. |
| Production HTTP | Anonymous `GET /auth/me`, `GET /favorites`, `GET /favorites/ids`, `PUT /favorites/rental-022`, and `DELETE /favorites/rental-022` returned 401 with `UNAUTHORIZED`. The public list returned 200 and identified `rental-022` as Eastside Staircase Duplex. |
| Firestore | Read the deployed default database rules using the existing Firebase CLI authorization. The deployed source matched the repository’s deny-all rule. This verification used read-only API calls. |
| Runtime | The regular APK launched on the Android emulator. On the isolated emulator, the regular APK restored Arabic and New Orange after process launch and showed the guest sign-in treatment in Favorites. The iOS simulator build installed and launched on iPhone 18 Pro Max. |
| Visual and interaction | The isolated Android run used the actual Flutter UI, live public properties, and a synthetic account and favorite repository. Hot reload completed. Adding a favorite in Details updated the Explore and Home hearts. Removing the fixture favorite emptied Favorites. The run verified both languages, all palettes, 430 dp and 320 dp, and restored Arabic and New Orange on cold start. The fixture entry point was removed after review. [Ten screenshots](docs/screenshots/phase-8) |
| Outstanding | Developer verification of authenticated production favorite writes, cold-start Firebase session restoration, live sign-out and account switching, and live Google Sign-In on both platforms. [Manual sequence](README.md#live-favorites-verification) |

Suggested commits are `feat: add session-scoped property favorites`, `feat: complete profile and persist appearance`, and `docs: record Phase 8 verification and screenshots`.

## Three-palette design fidelity correction

The developer required the original Figma paints and geometry, white primary foregrounds, and an audit of remaining icon fallbacks. Codex used Figma design context and screenshot tools to inspect the three Filters frames, Explore states, and relevant fallback nodes. The three selected Explore SVG exports had identical path data and differed only in fill. Flutter now uses the unmodified Blue export in its original slot with the active brand tint. The shared theme sets white filled-button and selected-chip text, removes chip checkmarks absent from the reference, and applies original selected-tab paint. Orange uses a dark keyboard-focus border to keep focus visible. The design system documents the intentional contrast limits, and the icon inventory records unavailable originals and retained alternatives.

Flutter rendered Explore and Filters at 430 × 932 with test fixtures in all three palettes. The comparisons are linked in the design system. The Android emulator ran the app and hot reload succeeded. These captures do not establish full-app visual parity or iOS runtime verification. [Visual verification](DESIGN_SYSTEM.md#three-palette-fidelity-verification)

## Phase 9.1 — Final Figma fidelity and visual refinement

The developer approved the earlier palette and Explore icon correction and requested the final visual refinement pass. Codex retrieved the three sets of Figma screen frames and inspected Details location, footer, heart, stats and facilities, the Explore filter and filter counter, and the Profile language nodes. The phase uses the existing SVG registry for licensed icons and records the remaining asset gaps. It preserves the established Auth collage and Google control. The original brand mark was authored as a simple angular house shape, rasterized into native launcher and launch resources, and reused as a themed SVG for Flutter Splash.

Codex unified Details favorite actions, added an applied-filter indicator and an external map link, isolated the Arabic currency amount, and added focused tests using fake account, property, and map-launch data. The accepted map fallback uses an address and a user-triggered universal Maps URL. Icon provenance, SDK glyph rationale, and the native-versus-Flutter splash distinction are recorded in the asset and design documents.

| Verification | Observed result |
| --- | --- |
| Toolchain | Flutter 3.50.1 and Dart 3.14.0. Package resolution added url_launcher 6.3.3 and its platform packages. No existing locked dependency version changed. |
| Generation and quality | Localization and build_runner generation passed. A second generation run reproduced the generated Dart source checksums. Formatting, Flutter analysis and diff validation passed. |
| Automated | 284 tests passed in both the regular and coverage runs. Reported line coverage was 90.61% (4,045 of 4,464 instrumented lines). |
| Android and iOS | The debug APK and iOS simulator build compiled successfully. The app launched on the Pixel 10 Pro XL emulator and iPhone 17e simulator. Native evidence includes the Android launcher crop and the iOS Auth capture. |
| Visual comparison | Captures for Blue and Purple in English and Orange in Arabic use production widgets driven by synthetic fixtures at 430 × 932. The native platform screenshots are separate. The fixtures exercise the populated and empty Favorites cases without a real account or production writes. |

The prior developer-confirmed Google sign-in and verified profile are recorded under Phase 8. Codex did not repeat live sign-in, write production favorites or measure private Google avatar source dimensions for Phase 9.1. Automated tests mock the map handoff. [Comparison and deviations](DESIGN_SYSTEM.md#phase-91--figma-fidelity-and-native-branding)

Android hot reload succeeded. From the live Arabic Details screen, Open in Maps launched Google Maps, which presented its own permission prompt. The prompt was left untouched. The automated test separately validates the exact coordinate URL and the app's localized launch-failure feedback.


## Phase 9.1.1 — Embedded map and supplied artwork review

The developer requested real embedded maps, original assets subject to licensing, platform and test verification, and a pause before Phase 9.2. Codex used Figma MCP to inspect the nine supplied frames and the Blue map slot, reviewed the supplied local exports, and consulted the OSMF and Flutter Map documentation. It implemented the independent tile layer and localized map states, made coordinate decoding resilient, and added offline widget checks for two distinct markers, palette colors, attribution, Arabic/English and scroll behavior. An early attribution layout overflow was reproduced in tests and fixed with a wrapping link. The existing DTO rejection case for invalid coordinates now checks that Details preserves the address. No developer edits or rejections were recorded during this phase.

Android and iOS launcher checks exposed stale Flutter artwork in some iOS catalog slots and a blank iOS native launch asset. Codex filled those slots using the existing opaque icon and transparent launch masters, registered Android's existing icon for round launchers, and verified the installed icons. Flutter hot reload succeeded on the Android verification run. Formatting, analyzer, both 286-test runs, generated-source reproducibility, Android debug build, iOS simulator build, and diff whitespace checks passed. Overall coverage was 90.53%. The README records runtime observations and the screenshot index. The Blue iOS map screenshot predates the final reduction of attribution background padding.


### Phase 9.1.1 local asset correction

The developer approved the embedded map and required the supplied originals in the private review build. Codex integrated the three original SVG variants and the untouched Auth PNG using the existing theme and auth screens. A macOS preparation script copies the review project into an ignored folder and uses AppKit to rasterize the Blue SVG for the native launch and launcher resources. Flutter analysis passed and all 286 existing Flutter tests passed. Both native builds succeeded. Codex installed the builds in place and inspected the Pixel and iOS launchers, the normal iOS Auth screen and three Flutter Splash captures on the Pixel emulator with fixture preferences. Codex compared them with the supplied art and approved Figma frames. The redistribution status and review build commands are documented in the README.

### Phase 9.1.1 normal developer build correction

The developer reported that a physical-device run from the main checkout still showed the fallback artwork. Codex traced that behavior to the separate staged project and the old opt-in Dart define. The interim Gradle and Xcode workflow generated private debug resources in their build directories and packaged the original Flutter assets automatically. That interim startup selected the originals from the debug bundle. The Android emulator and iOS simulator were rebuilt and updated in place with `flutter run`. Codex inspected both installed launchers and the supplied Auth image on iOS, and confirmed the packaged Flutter originals match the source files byte for byte. Static analysis, 286 tests and Android hot reload passed.

### Phase 9.1.1 Auth fade and cold Splash timing

Codex read the three Figma Auth frames and their paint transforms, then restored the shared fade as a single Flutter overlay above the supplied collage and the fallback. The supplied PNG was left intact. The Splash widget starts a cancellable two-second timer after its first frame. The existing router waits for both the timer and session restoration, while startup errors remain actionable. Five deterministic widget tests cover fast and slow restoration, immediate errors and retry, rebuilds and resume without duplicate navigation, and disposal. All 291 tests and Flutter analysis passed. Codex verified the normal build on an iPhone 18 Pro Max simulator and captured the Auth fade and all three real cold-start Splash palettes in the ignored `.local-asset-review/fade-splash/` directory.

### Phase 9.1.1 static asset packaging

The developer approved standard static asset packaging and separate delivery and private review copies. Codex removed the branding build hooks and startup probe, kept the existing Auth overlay and Splash lifecycle, used the existing palette mapping to select the bundled SVGs, and rendered the private native resources once with the standalone Swift renderer. The public asset bundle contains the authorized alternatives. No tests were removed or replaced.

Both copies independently passed `flutter clean`, `flutter pub get`, `flutter analyze`, `flutter test`, `flutter test --coverage`, `flutter build apk --debug` and `flutter build ios --simulator`. Both test runs passed 291 tests per copy. LCOV recorded 4,129 of 4,559 lines (90.57%). Codex inspected the Flutter manifests and artwork bytes, Android resource table and compiled iOS launch catalog. The existing widget tests cover the two-second minimum and restoration, retry and timer behavior. `git diff --check` passed.

Standard `flutter run` launched both copies on the Pixel 10 Pro XL emulator and the iPhone 18 Pro Max simulator. Android subsequently completed a hot restart. Codex inspected iOS captures of the authorized Auth artwork and the private Auth fade, original Blue native launch artwork and Blue Flutter Splash. The three original Splash SVGs and the Auth PNG matched the supplied exports byte for byte. No new sign-in or physical-device checks were performed.

### Phase 9.1.1 main checkout artwork

The developer requested the supplied artwork in the main application for local review. Codex copied the four exports byte for byte, backed up all seven source files, reused the one-time Blue native renders after matching the source SVG, and updated the static Splash mapping and Auth asset path. The existing Auth gradient, Splash timer and native build configuration remained in place. The original Flutter assets are ignored. Native resources replace tracked paths and remain unstaged.

From the main root, formatting, clean, package resolution, analysis, all 291 tests, the Android Debug APK build, the iOS simulator build and `git diff --check` passed. APK and simulator bundle inspection confirmed the original Flutter artwork in the asset manifests along with the native icon and launch resources. Standard `flutter run` and hot restart succeeded on the Pixel emulator. The Android App Info screen displayed the original icon.

Standard `flutter run` also launched the main project on the iPhone simulator. Codex inspected the compiled iOS icon, the Blue native launch mark, Blue and Orange Flutter Splash captures, and the supplied Auth image with its fade. A separate Android cold start displayed the Purple Splash. The simulator’s previous theme was restored.

### Final Figma fidelity corrections

Codex inspected the 24 specified frame fills, the neutral surface layers and all three Google button nodes through Figma MCP. The frame fills were opaque white, and the Google source nodes carried subtle 4% theme strokes. The developer requested a borderless app button. Codex removed the Flutter outline, shared the `#FCFCFC` Auth backdrop with the existing gradient endpoint, and extended the existing sign-in progress and retry test with styling assertions.

The full format check, Flutter analysis, all 291 tests and `git diff --check` passed. The main application built and launched on the iPhone 18 Pro Max simulator and Android emulator. The iOS app completed a hot restart. Codex compared the relevant surfaces with the Figma renders and kept app captures outside the repository under `/private/tmp/real-estate-fidelity.OsQ9sU/`. The Android captures used live property data and the emulator’s existing Arabic session. The app continues to use localized sign-in wording and Google button typography. No live Google sign-in was performed during this visual check.

For the Arabic Auth capture, a temporary in-memory locale override loaded the existing Arabic localization on the iOS simulator. Codex removed the override immediately after capture and hot restarted the normal app. Both Auth captures show a borderless control and a continuous fade into the backdrop.

### Final Google Sign-In button styling

The developer approved the verified Figma button geometry, Rubik typography and shadow, with a borderless app treatment. Codex replaced the draft gesture-only control with a Material button, restored its localized error feedback and verified the new properties in the existing sign-in progress and retry test. All 291 tests, Flutter analysis and the diff whitespace check passed.

The existing Android emulator hot reloaded successfully. Hot restarts opened the production Auth widget for private Arabic and English captures via a temporary route override, which was removed before the final restart. Codex inspected the captures for the centered label and mark, borderless shape and shadow. The existing emulator account was preserved. Live Google sign-in was not exercised.

### Orange palette and Profile menu fidelity

The developer requested the original three primary colors and restoration of the original Profile menu before Phase 9.2. Codex used Figma MCP to inspect and render Blue, Purple and Orange Profile, verify the menu labels, measurements and order, and export seven original Iconly Curved SVGs. Flutter's theme factory now uses the original brand value for the shared secondary role. Profile reuses the chevron, Language, Logout and Heart assets, preserves the existing actions, and supplies English and Arabic unavailable feedback for the seven restored rows.

`flutter gen-l10n`, Dart formatting, `flutter analyze`, all 293 Flutter tests and `git diff --check` passed. The first regression test run reached 291 passes and identified an ambiguous chevron finder in the two new tests. Scoping that finder to the target row resolved both failures. The new tests cover menu order and labels, scrolling at 320 × 560 dp, icon alignment and unavailable feedback in both languages.

An incremental Flutter debug run and a hot restart on the existing Android emulator verified the app with live property data and the restored account session. Codex compared the three Profile palettes with their Figma references and inspected Arabic Profile, unavailable feedback, and Orange Home, Explore, Filters and Details. Captures remain in the owner-only local directory `/private/tmp/real-estate-profile-czirajla/`. The native safe area and account identity shift the vertical placement relative to the Figma mock. My Favorites and Appearance extend the menu below Logout. The existing session was used for screenshot verification. Live authentication changes and favorites writes were outside this check. Review stops before Phase 9.2.


## Search and Property Details fidelity follow-up

The developer requested a source-based correction before Phase 9.2 and Android-only review. Codex used Figma MCP to measure nine search nodes, inspect and render all three Details frames, and export the licensed agent contact SVGs. Workspace tools implemented the shared border correction and focused Details changes. The source comparison identified the prior full-opacity search stroke, backed hero dots, safe-area offset, and differences in agent names, contact controls, facility labels, gallery spacing, map ordering, review spacing and footer styling. Android comparison revealed content crossing the status area on scroll, which was corrected with a native-inset backing. [Measurements and deviations](DESIGN_SYSTEM.md#search-and-property-details-fidelity-follow-up)

Verification used the existing Android emulator via hot reload and restart, plus private ADB screenshots of the Search Bar and Details scroll in all three palettes and Arabic. Live property imagery and OpenStreetMap tiles were visible. The contact controls displayed localized unavailable feedback and the account preferences were restored to Purple and Arabic. Flutter localization generation, formatting, static analysis, all 293 tests and `git diff --check` passed. Test assertions cover the per-palette search borders and both attributed contact controls. Compact widths and enlarged text were covered by the existing widget matrix. No iOS verification was performed. Developer visual review is pending.
