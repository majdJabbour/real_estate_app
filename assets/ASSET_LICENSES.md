# Asset provenance and licenses

## Home and navigation SVGs

**Iconly 2.3 Essential Icons by Piqo Studio (Piqo Design)**. The author links the free Community icon set from its design publication. Figma's free-file terms license redistribution and adaptation under CC BY 4.0. The assessment's named remote Iconly Light, Light-Outline and Bold instances were exported from the supplied reference and credited to Piqo Studio. This grant is specific to the free set. [Author's release and source link](https://dribbble.com/shots/15258922-Cinema-App-P2) · [Iconly 2.3 release notes by Piqo Studio](https://dribbble.com/shots/15543844-Iconly-Roadmap) · [Iconly Community source](https://www.figma.com/community/file/876509330914541878) · [Figma Community free-file licensing](https://help.figma.com/hc/en-us/articles/360042296374-Figma-Community-copyright-and-licensing) · [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

| Bundled SVG | Original Blue Figma node | Treatment |
| --- | --- | --- |
| `navigation/home-outline.svg` | `1:4112` | Original 1.5 px round stroke |
| `navigation/home-selected.svg` | `1:4491` | Original filled silhouette |
| `navigation/explore-outline.svg` | `1:4494`, shared with search input `1:4460` | Original clipped outline, scaled to the requested slot |
| `navigation/explore-selected.svg` | `1:4115` | Unmodified 20 × 20 compound-path export centered in the 24 × 24 slot. Both the lens and handle take the palette paint |
| `navigation/profile-outline.svg` | `1:4497` | Original compound paths |
| `navigation/profile-selected.svg` | `1:3865` | Original filled silhouette |
| `actions/notification.svg` | `1:4456` | Bell only. The sample badge is a separate layer `1:4457` |
| `actions/filter.svg` | `1:4462` | Iconly's Home filter geometry |
| `actions/back.svg` | `1:4163` | Original arrow, mirrored by the widget in RTL |
| `property/heart-outline.svg` | `I1:4473;85001:13433`, shared with `I1:4470;85001:13415` | Original outline reused at 20 and 22 dp |
| `property/rating-star.svg` | `I1:4470;85001:13417`, shared with `I1:4473;85001:13426` | Original two-stop gradient reused at 14 and 10 dp |

The SVGs keep the exported view boxes and path coordinates. Opaque white Figma luminance masks were expressed as equivalent clip paths for `flutter_svg`. Internal IDs were shortened. App tinting changes semantic paint at runtime. The Explore export uses one themed paint for both lens and handle. Every SVG was parsed and rasterized in Flutter tests. [Measured node inventory](FIGMA_ICON_INVENTORY.md)

## Retained alternatives and future assets

- **Iconsax (Vuesax)** supplies the `setting-4` outline in `1:4078` and `1:3890`. It differs from Home's Iconly filter. Iconsax's developer terms permit integration subject to their notice and redistribution rules and prohibit loose icon files. This phase bundles no Iconsax SVGs. [Iconsax license](https://docs.iconsax.io/license-and-terms/license) · [Iconsax identity and distribution](https://docs.iconsax.io/faqs/key)
- **Material Icons from the installed Flutter SDK** supply the guest avatar, selected favorite heart, placeholder images. The Figma Home cards show an outline heart for both card styles. No original selected card-heart state was found. [Material Icons license](https://github.com/google/material-design-icons/blob/master/LICENSE)
- **Google mark** `1:4549` has four fixed colors. It is inventoried only. The shipped mark comes from the official Google branding package. [Google branding guidelines](https://developers.google.com/identity/branding-guidelines)
- **Real Scout branding and unnamed facility, stat and map glyphs** are inventoried for reference. Their originating author or redistribution terms could not be confirmed from the supplied Community copy. No files from those groups are bundled.
- **Rubik** remains bundled under SIL OFL 1.1 with its attribution and complete notice. The runtime property photos remain server-supplied and are sourced as described in the API repository. [Rubik license](fonts/rubik/OFL.txt) · [Design system asset notes](../DESIGN_SYSTEM.md#7-assets-and-provenance)

## Phase 5 Explore and Filters

Explore and the sheet reuse the already-attributed Iconly back, notification, search, filter, star, and heart files. The Vuesax filter in Search-v2 and Filters remains a design reference. The app uses the existing Iconly filter under the recorded license. The counter paths come from unnamed Figma components, so the counters use the SDK's Material plus and minus glyphs. The new layout toggle also uses Material glyphs. [Icon inventory](FIGMA_ICON_INVENTORY.md)

## Phase 6 Property Details

| Bundled SVG | Original Blue Figma node | Treatment |
| --- | --- | --- |
| `actions/details-back.svg` | `1:4267` | Iconly Light Arrow - Left. Preserves the 28 × 28 viewBox and 1.5 px round strokes. Mirrors in RTL. |
| `property/location.svg` | `1:4383` | Iconly Bold Location. Preserves the 20 × 20 viewBox and even-odd fill. Uses the active theme's accessible accent. |

Both SVGs are credited to Piqo Studio under the recorded Iconly CC BY 4.0 grant. Details reuses the bundled heart and gradient star. Stat and facility icons, person placeholders, and viewer Close use the installed Flutter SDK's Material artwork. Property and avatar imagery comes from the API when available. No Figma sample images, map artwork, or unnamed glyph vectors were added to the app bundle. [Iconly and Material sources](#home-and-navigation-svgs) · [Measured icon inventory](FIGMA_ICON_INVENTORY.md)


## Authentication assets

- The previous fallback Auth collage was original ImageGen output created for Phase 7.2 from a description of the three-column property composition. It depicts illustrative buildings, with no source photo or Figma render embedded. The supplied Auth collage replaces it for local review.
- `icons/auth/google.png` is the unretouched center crop of the Google mark in the official 4× light icon-mode pill PNG for Android and Web. The 80 × 80 crop renders at 20 dp without recoloring, stretching or mirroring and appears only in the white Google sign-in control. The Google mark remains subject to Google's brand terms. [Google branding guidelines and asset bundle](https://developers.google.com/identity/branding-guidelines#download_pre-approved_brand_icons)
- The earlier Google Sans Medium subset and its SIL Open Font License 1.1 are preserved together in the private archive. The current sign-in control uses Rubik.

## Phase 8 Profile

Three unmodified Blue-frame group SVG exports use the existing Iconly CC BY 4.0 attribution to Piqo Studio. Flutter supplies the surrounding Figma slot, direction and tint through `AppIcon`.

| File | Figma node | Glyph |
| --- | --- | --- |
| `actions/profile-chevron.svg` | `1:3824` | Light Arrow - Right 2 |
| `actions/profile-language.svg` | `1:3843` | Curved More Circle |
| `actions/profile-logout.svg` | `1:3855` | Curved Logout |

The existing Outline Heart is reused. The selected heart, appearance and avatar fallback use Material SDK glyphs. Piqo’s release describes the free Bold family. Access to the original Community Heart export could not be confirmed, so no filled Iconly asset was added. [Piqo Studio’s Iconly 2.3 release](https://dribbble.com/shots/15543844-Iconly-Roadmap) · [Existing Iconly attribution](#home-and-navigation-svgs)

## Phase 9.1 — Splash and native brand mark

Earlier fallback branding used an angular house silhouette and native PNG derivatives. The local review build now uses the supplied branding below.


## Phase 9.1.1 — Supplied Figma exports

The developer supplied seven files under `original_figma_assets/`. The three SVGs (`app_icon.svg`, `app_icon_purpel.svg`, `app_icon_orange.svg`) have 134 × 113 viewBoxes and correspond to the Blue, Purple and Orange Figma mark artwork. The three matching PNGs are transparent 134 × 113 references. No author grant or original publication license was supplied for the marks. The 798 × 1104 `login_image.png` shows a Freepik watermark on the third center-column photograph. Neither the original licensed download nor grants covering the other source photos were established. Keep these exports and their derivatives out of delivery commits pending permission. [Freepik stock downloads and license documentation](https://www.freepik.com/ai/docs/how-to-download-freepik-images)

The property map displays runtime OpenStreetMap tiles with linked attribution. Tiles are fetched under the public tile service policy and cached by Flutter Map. No tiles are bundled. [OpenStreetMap copyright and ODbL attribution](https://www.openstreetmap.org/copyright) · [OSMF tile policy](https://operations.osmfoundation.org/policies/tiles/)


The main project bundles the original SVGs at `brand/logo_blue.svg`, `brand/logo_purple.svg`, and `brand/logo_orange.svg`, plus the unmodified `auth/login_image.png`. The launcher and launch PNG changes under Android `mipmap-*` and iOS `AppIcon.appiconset` and `LaunchImage.imageset` derive from a one-time render of the supplied Blue SVG. Keep these assets, screenshots and binaries local while redistribution permission remains unresolved.

### Restored Profile menu icons

The Calendar, Wallet, Profile, Notification, Shield Done, Info Square and 3 User SVGs are unmodified exports of the supplied Iconly Curved instances from the Blue Profile frame. Attribution remains with Piqo Studio under the recorded Iconly 2.3 CC BY 4.0 grant. Runtime tint and directional layout follow the shared icon registry. [Source nodes and SVG inventory](FIGMA_ICON_INVENTORY.md#restored-profile-menu) · [Iconly source and license](#home-and-navigation-svgs)


## Details agent contact SVGs

`actions/details-chat.svg` and `actions/details-call.svg` are unchanged Iconly Light Chat and Call exports from `I1:4310;929:29137` and `I1:4310;929:29138`. Piqo Studio's Iconly 2.3 CC BY 4.0 attribution applies. Flutter tints the original vectors with each palette's primary. [Iconly source and license](#home-and-navigation-svgs)
