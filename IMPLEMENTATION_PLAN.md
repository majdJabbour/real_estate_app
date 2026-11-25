# Flutter Real Estate App — Implementation Plan

Status: proposed sequence for developer approval. Existing dependency setup and initial commit are reported complete. Backend public API is deployed; live Firebase sign-in and Firestore persistence remain unverified. Scope and colors must be confirmed against the selected Figma frames before UI work. Each phase ends with actual checks, AI_USAGE.md update, review and a meaningful commit after developer approval. Do not implement all phases in one agent run.

## 0 — Baseline and documentation
Inspect project, Flutter/Dart, pubspec, git status, actual platform IDs and existing scaffold. Verify installed package API conventions. Copy current sibling backend contract as a reference (not the older draft), record revision. Establish AI_USAGE.md and README baseline. Verify analyze/test and document build prerequisites. No cloud changes. Commit: `docs: establish flutter engineering guidelines` (or separate genuine tooling changes).

## 1 — Design inspection and system

### 1.1 — Figma analysis

Approved for continuation. [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) records all three variants, frame IDs, measured values, and asset provenance questions.

### 1.2 — Shared multi-theme design system

Approved for continuation. Blue is the default. The shared light theme factory supports Blue, Purple, and Orange with bundled Rubik and four primitives for primary actions, icon actions, search, and choice/filter chips. A temporary preview exercises all variants, English and Arabic direction, and control states.

### 1.3 — Responsive and adaptive layout foundation

Approved for continuation. The layout foundation uses local safe-area constraints to center capped content and size adaptive grids. The temporary preview demonstrates the calculations and lazy variable-height rows.

## 2 — Core infrastructure and localization

Bootstrap loads persisted English or Arabic before mounting the app in `ProviderScope`. Generated providers expose configuration, the locale controller, and the Dio client. Shared request handling covers cancellation, language headers, stale responses, explicit authentication policy, typed errors, and envelopes. Firebase token acquisition and property repositories are later phases. Review this phase before moving to property data and state. Suggested commit `feat: add core networking and localization`.

## 3 — Property data layer

Implemented the domain repository, immutable models and query, generated DTO decoding and providers, and public listing, details, and filter calls with cancellation and pagination. Verified the four production response shapes in both languages and exercised malformed responses, locale changes, and dependency overrides with deterministic tests. Approved for continuation.

Screen state belongs with its approved consumers in Phases 4–6. Locale-sensitive providers will cancel obsolete requests and guard current state when locale, query, or route arguments change. Explore will own debounce, pagination, and filter drafts.

## 4 — Production navigation and Home

Implemented the stateful Home, Explore, and Profile tab shell and the root property-details route. Home uses the approved Blue reference, shared theme palettes, real listing and category data, and independently refreshable sections. Explore, Filters, Details, and Profile intent handling is temporary, with language selection available in Profile. Authentication and persistent favorites remain in their planned phases. Phase 4 is functionally approved.

### 4.1 — Original Figma icons and Home refinement

Verified Iconly provenance, bundled the original Home and navigation SVG shapes, and refined Home spacing and controls using the Blue Figma reference and live simulator captures. The shared icon system keeps theme paints and RTL behavior explicit. The original icon inventory and outstanding artwork provenance are recorded for later phases. Approved for continuation. Suggested commit `feat: use original Figma icons on Home`.

## 5 — Explore and Advanced Filters

Implemented both Explore layouts with one request controller, server search and pagination, and the Figma-based filter sheet with draft/apply/reset behavior. Existing Home intents open the production branch and preserve its state on regular tab returns. Verified English and Arabic layouts, compact and landscape behavior, and the deployed API. Approved for continuation. Suggested commit `feat: implement Explore and advanced property filters`.

## 6 — Property details
Implemented the approved Property Details screen on the existing root route. A generated locale-aware provider loads by ID and cancels obsolete requests. Details renders the actual photos, property statistics, description, agent, facilities, coordinates, reviews and monthly USD price. It includes a swipeable hero and full-screen zoom viewer, localized failures and retry, and explicit empty-section states. Booking and favorites are presented as unavailable. Agent contact and share controls are omitted. Developer review is pending. Suggested commit `feat: implement property details`.

## 7 — Firebase authentication
Developer confirms actual Android application ID and iOS bundle ID; register both in existing Firebase project via FlutterFire CLI and configure Google provider platform prerequisites. No new Admin keys or Firestore direct client. Implement sign-in, session restoration, logout, protected API token attachment and bounded refresh. Verify real Google login and `/auth/me` on supported platform; report pending platforms. Commit config and auth in meaningful groups.

## 8 — Favorites and profile
Shared session-scoped ID set from GET /favorites/ids, optimistic PUT/DELETE, rollback, per-property concurrency and stale-session guards. Hearts across home/explore/details stay synchronized. No separate favorites screen. Implement approved profile and language controls; avoid inert menu actions. Verify real Firestore persistence across requests and relaunch, account isolation and logout; review effective cloud rules with developer. Commit: `feat: synchronize favorites and user profile`.

## 9 — Quality and delivery
Run generation as applicable, formatting, analyze, unit/provider/widget tests and approved integration tests. Build Android and iOS where supported. Compare screenshots with Figma at 430 and test 320/375/390, landscape, Arabic/English, enlarged text; optional tablet if time permits. Verify offline/timeout/error/retry, rapid search, pagination, language changes, login/logout and favorites. Finish README and actual AI usage, screenshots in both languages or short demo, access links and reproducible instructions. Disclose unverified live behavior, external image dependency and mock backend limitations. Review Git history and secrets. Commit: `docs: finalize assessment delivery` plus real fixes as separate commits.

## Priority and scope guard
The assessment is primarily Flutter and suggests 12–14 working hours. Complete approved public screens and required bilingual/API behavior before expanding optional auth/profile features if time is constrained. Firebase configuration can be performed earlier as a separate setup task with developer approval, but must not block public UI work. Do not claim completion for untested features or silently change the contract. No artificial commits or arbitrary test-count goals.
