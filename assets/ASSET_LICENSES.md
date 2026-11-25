# Asset provenance and licenses

## Home and navigation SVGs

**Iconly 2.3 Essential Icons by Piqo Studio (Piqo Design)**. The author links the free Community icon set from its design publication. Figma's free-file terms license redistribution and adaptation under CC BY 4.0. The assessment's named remote Iconly Light, Light-Outline and Bold instances were exported from the supplied reference and credited to Piqo Studio. This grant is specific to the free set. [Author's release and source link](https://dribbble.com/shots/15258922-Cinema-App-P2) · [Iconly 2.3 release notes by Piqo Studio](https://dribbble.com/shots/15543844-Iconly-Roadmap) · [Iconly Community source](https://www.figma.com/community/file/876509330914541878) · [Figma Community free-file licensing](https://help.figma.com/hc/en-us/articles/360042296374-Figma-Community-copyright-and-licensing) · [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

| Bundled SVG | Original Blue Figma node | Treatment |
| --- | --- | --- |
| `navigation/home-outline.svg` | `1:4112` | Original 1.5 px round stroke |
| `navigation/home-selected.svg` | `1:4491` | Original filled silhouette |
| `navigation/explore-outline.svg` | `1:4494`, shared with search input `1:4460` | Original clipped outline, scaled to the requested slot |
| `navigation/explore-selected.svg` | `1:4115` | Original compound geometry split at its two exported subpaths. A clipped 1.8 px stroke keeps the pale #F9F9FA handle distinguishable on white without extending the silhouette |
| `navigation/profile-outline.svg` | `1:4497` | Original compound paths |
| `navigation/profile-selected.svg` | `1:3865` | Original filled silhouette |
| `actions/notification.svg` | `1:4456` | Bell only. The sample badge is a separate layer `1:4457` |
| `actions/filter.svg` | `1:4462` | Iconly's Home filter geometry |
| `actions/back.svg` | `1:4163` | Original arrow, mirrored by the widget in RTL |
| `property/heart-outline.svg` | `I1:4473;85001:13433`, shared with `I1:4470;85001:13415` | Original outline reused at 20 and 22 dp |
| `property/rating-star.svg` | `I1:4470;85001:13417`, shared with `I1:4473;85001:13426` | Original two-stop gradient reused at 14 and 10 dp |

The SVGs keep the exported view boxes and path coordinates. Opaque white Figma luminance masks were expressed as equivalent clip paths for `flutter_svg`. Internal IDs were shortened. App tinting changes semantic paint at runtime. The themed Explore path alone is recolored and its pale secondary paint remains fixed. Every SVG was parsed and rasterized in Flutter tests. [Measured node inventory](FIGMA_ICON_INVENTORY.md)

## Retained alternatives and future assets

- **Iconsax (Vuesax)** supplies the `setting-4` outline in `1:4078` and `1:3890`. It differs from Home's Iconly filter. Iconsax's developer terms permit integration subject to their notice and redistribution rules and prohibit loose icon files. This phase bundles no Iconsax SVGs. [Iconsax license](https://docs.iconsax.io/license-and-terms/license) · [Iconsax identity and distribution](https://docs.iconsax.io/faqs/key)
- **Material Icons from the installed Flutter SDK** supply the guest avatar, selected favorite heart, placeholder images and the accessibility checkmark in the selected chip. The Figma Home cards show an outline heart for both card styles. No original selected card-heart state was found. [Material Icons license](https://github.com/google/material-design-icons/blob/master/LICENSE)
- **Google mark** `1:4549` has four fixed colors. It is inventoried only. Authentication work will require the official Google asset and the published branding rules. [Google branding guidelines](https://developers.google.com/identity/branding-guidelines)
- **Real Scout branding and unnamed facility, stat and map glyphs** are inventoried for reference. Their originating author or redistribution terms could not be confirmed from the supplied Community copy. No files from those groups are bundled.
- **Rubik** remains bundled under SIL OFL 1.1 with its attribution and complete notice. The runtime property photos remain server-supplied and are sourced as described in the API repository. [Rubik license](fonts/rubik/OFL.txt) · [Design system asset notes](../DESIGN_SYSTEM.md#7-assets-and-provenance)

## Phase 5 Explore and Filters

Explore and the sheet reuse the already-attributed Iconly back, notification, search, filter, star, and heart files. The Vuesax filter in Search-v2 and Filters remains a design reference. The app uses the existing Iconly filter under the recorded license. The counter paths come from unnamed Figma components, so the counters use the SDK's Material plus and minus glyphs. The new layout toggle also uses Material glyphs. [Icon inventory](FIGMA_ICON_INVENTORY.md)
