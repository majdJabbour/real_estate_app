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
