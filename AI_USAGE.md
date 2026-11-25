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

Android runtime and full Details, Profile, authentication, and favorite persistence remain outside this phase. Phase 5 is pending developer review.
