# Flutter Real Estate App — Implementation Plan

Status: proposed sequence for developer approval. Existing dependency setup and initial commit are reported complete. Backend public API is deployed; live Firebase sign-in and Firestore persistence remain unverified. Scope and colors must be confirmed against the selected Figma frames before UI work. Each phase ends with actual checks, AI_USAGE.md update, review and a meaningful commit after developer approval. Do not implement all phases in one agent run.

## 0 — Baseline and documentation
Inspect project, Flutter/Dart, pubspec, git status, actual platform IDs and existing scaffold. Verify installed package API conventions. Copy current sibling backend contract as a reference (not the older draft), record revision. Establish AI_USAGE.md and README baseline. Verify analyze/test and document build prerequisites. No cloud changes. Commit: `docs: establish flutter engineering guidelines` (or separate genuine tooling changes).

## 1 — Design inspection and system

### 1.1 — Figma analysis

Approved for continuation. [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) records all three variants, frame IDs, measured values, and asset provenance questions.

### 1.2 — Shared multi-theme design system

Blue is the default. The shared light theme factory supports Blue, Purple, and Orange with bundled Rubik and four primitives for primary actions, icon actions, search, and choice/filter chips. A temporary preview exercises all variants, English and Arabic direction, and control states. Feature-specific widgets, app navigation, production localization, and runtime theme persistence are later work. Review this phase before proceeding. Suggested commit `feat: implement shared multi-theme design system`.

## 2 — Core infrastructure and localization
Typed API configuration, Dio, response envelopes, errors, request cancellation, ARB en/ar and persisted locale. Bootstrap app and verify locale switch/restore, localized errors, public request headers and URL joining. Keep Firebase optional until configured. Commit cohesive networking/localization changes separately if helpful.

## 3 — Property data and state
DTOs, mapping, repository contract and implementation. Listing, details, filter options, typed query serialization and pagination. Provider state for featured, listing, details, filters, search debounce and stale result guards. Tests against contract and mocked responses. Public API smoke checks. Commit: `feat: implement property data and query state`.

## 4 — Navigation and home
Implement approved shell/routes and home screen from Figma. Reusable cards and section headers; featured and recommended queries, loading/error/empty/retry, image fallback. Use real API data. Test navigation and layouts. Commit: `feat: implement home and navigation`.

## 5 — Explore and filters
Implement approved list/grid layouts, server search, category selection, pagination, draft/apply/reset filters, histogram and sliders from global filter options. Ensure filters and query survive appropriate navigation, reset pages on changes, retry next page and cancel stale work. Verify combined filters and empty/equal bounds. Commit search and filters separately if cohesive.

## 6 — Property details
Implement approved details screen, gallery, location, facilities, agent, reviews and legitimate actions as supported by scope/data. No invented phone numbers or fake bookings. Handle missing optional fields and broken images. Verify scroll and RTL. Commit: `feat: implement property details`.

## 7 — Firebase authentication
Developer confirms actual Android application ID and iOS bundle ID; register both in existing Firebase project via FlutterFire CLI and configure Google provider platform prerequisites. No new Admin keys or Firestore direct client. Implement sign-in, session restoration, logout, protected API token attachment and bounded refresh. Verify real Google login and `/auth/me` on supported platform; report pending platforms. Commit config and auth in meaningful groups.

## 8 — Favorites and profile
Shared session-scoped ID set from GET /favorites/ids, optimistic PUT/DELETE, rollback, per-property concurrency and stale-session guards. Hearts across home/explore/details stay synchronized. No separate favorites screen. Implement approved profile and language controls; avoid inert menu actions. Verify real Firestore persistence across requests and relaunch, account isolation and logout; review effective cloud rules with developer. Commit: `feat: synchronize favorites and user profile`.

## 9 — Quality and delivery
Run generation as applicable, formatting, analyze, unit/provider/widget tests and approved integration tests. Build Android and iOS where supported. Compare screenshots with Figma at 430 and test 320/375/390, landscape, Arabic/English, enlarged text; optional tablet if time permits. Verify offline/timeout/error/retry, rapid search, pagination, language changes, login/logout and favorites. Finish README and actual AI usage, screenshots in both languages or short demo, access links and reproducible instructions. Disclose unverified live behavior, external image dependency and mock backend limitations. Review Git history and secrets. Commit: `docs: finalize assessment delivery` plus real fixes as separate commits.

## Priority and scope guard
The assessment is primarily Flutter and suggests 12–14 working hours. Complete approved public screens and required bilingual/API behavior before expanding optional auth/profile features if time is constrained. Firebase configuration can be performed earlier as a separate setup task with developer approval, but must not block public UI work. Do not claim completion for untested features or silently change the contract. No artificial commits or arbitrary test-count goals.
