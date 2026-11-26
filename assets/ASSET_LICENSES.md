# Asset licensing and attribution

This document records the sources, attribution, and redistribution limits for bundled and runtime assets. [Icon design and fallbacks](../DESIGN_SYSTEM.md#icon-design-and-fallbacks)

## Iconly SVGs

**Iconly 2.3 Essential Icons by Piqo Studio (Piqo Design)**. The author links the free Community icon set from its design publication. Figma's free-file terms license redistribution and adaptation under CC BY 4.0. The assessment's named remote Iconly Light, Light-Outline and Bold instances were exported from the supplied reference and credited to Piqo Studio. This grant is specific to the free set. [Author's release and source link](https://dribbble.com/shots/15258922-Cinema-App-P2) · [Iconly 2.3 release notes by Piqo Studio](https://dribbble.com/shots/15543844-Iconly-Roadmap) · [Iconly Community source](https://www.figma.com/community/file/876509330914541878) · [Figma Community free-file licensing](https://help.figma.com/hc/en-us/articles/360042296374-Figma-Community-copyright-and-licensing) · [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

Paths below are relative to `assets/icons/`. Node IDs identify the source instances in the supplied Original Blue design. The exports preserve the source vector geometry. Some opaque Figma masks became equivalent SVG clip paths and internal IDs were shortened. The app applies semantic colors where appropriate. [Home](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4426) · [Explore list](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4120) · [Explore grid](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4055) · [Details](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4236) · [Profile](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3786)

| Bundled SVG | Figma source node | Iconly glyph |
| --- | --- | --- |
| `navigation/home-outline.svg` | `1:4112` | Light Home |
| `navigation/home-selected.svg` | `1:4491` | Bold Home |
| `navigation/explore-outline.svg` | `1:4494`, also used for search at `1:4460` | Light-Outline Search |
| `navigation/explore-selected.svg` | `1:4115` | Bold Search |
| `navigation/profile-outline.svg` | `1:4497` | Light-Outline Profile |
| `navigation/profile-selected.svg` | `1:3865` | Bold Profile |
| `actions/notification.svg` | `1:4456` | Light-Outline Notification |
| `actions/filter.svg` | `1:4462` | Light-Outline Filter |
| `actions/back.svg` | `1:4163` | Light-Outline Arrow - Left |
| `property/heart-outline.svg` | `I1:4473;85001:13433`, shared with `I1:4470;85001:13415` | Light-Outline Heart |
| `property/rating-star.svg` | `I1:4470;85001:13417`, shared with `I1:4473;85001:13426` | Bold Star |
| `actions/details-back.svg` | `1:4267` | Light Arrow - Left |
| `actions/details-chat.svg` | `I1:4310;929:29137` | Light Chat |
| `actions/details-call.svg` | `I1:4310;929:29138` | Light Call |
| `property/location.svg` | `1:4383` | Bold Location |
| `actions/profile-chevron.svg` | `1:3824` | Light Arrow - Right 2 |
| `actions/profile-booking.svg` | `1:3822` | Curved Calendar |
| `actions/profile-payments.svg` | `1:3826` | Curved Wallet |
| `actions/profile-account.svg` | `1:3831` | Curved Profile |
| `actions/profile-notifications.svg` | `1:3835` | Curved Notification |
| `actions/profile-security.svg` | `1:3839` | Curved Shield Done |
| `actions/profile-language.svg` | `1:3843` | Curved More Circle |
| `actions/profile-help.svg` | `1:3847` | Curved Info Square |
| `actions/profile-invite.svg` | `1:3851` | Curved 3 User |
| `actions/profile-logout.svg` | `1:3855` | Curved Logout |

## SDK icons and reference artwork

Flutter's bundled Material Icons supply the intentional fallbacks documented in the design system. A matching filled property heart from the attributable Iconly free set could not be verified. Provenance and redistribution rights also remain unresolved for the supplied search and notification alternatives, filter counter vectors, property stat and facility glyphs, and illustrated map artwork. Those reference vectors are outside the bundle. [Material Icons license](https://github.com/google/material-design-icons/blob/master/LICENSE)

The Search-v2 and Filters references use Iconsax (Vuesax) `setting-4` at `1:4078` and `1:3890`. The developer terms permit integration subject to notice and redistribution restrictions, including restrictions on distributing loose icon files. The app bundles the attributed Iconly filter. [Filters frame](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3867) · [Iconsax license](https://docs.iconsax.io/license-and-terms/license) · [Iconsax identity and distribution](https://docs.iconsax.io/faqs/key)

## Authentication assets

`icons/auth/google.png` is an unretouched 80 × 80 center crop of the Google mark from the official 4× light icon-mode pill PNG for Android and web. It appears only in the Google sign-in control and remains subject to Google's brand terms. Figma node `1:4549` is the design reference. [Auth frame](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4499) · [Google branding guidelines and asset bundle](https://developers.google.com/identity/branding-guidelines#download_pre-approved_brand_icons)

## Fonts

Rubik is bundled under SIL OFL 1.1. Its attribution and complete notice ship with the font. The retired Google Sans subset and its SIL OFL notice are preserved together in the private archive. [Rubik license](fonts/rubik/OFL.txt)

## Phase 9.1.1 — Supplied Figma exports

The developer supplied seven files under `original_figma_assets/`. The three SVGs (`app_icon.svg`, `app_icon_purpel.svg`, `app_icon_orange.svg`) have 134 × 113 viewBoxes and correspond to the Blue, Purple and Orange Figma mark artwork. The three matching PNGs are transparent 134 × 113 references. No author grant or original publication license was supplied for the marks. The 798 × 1104 `login_image.png` shows a Freepik watermark on the third center-column photograph. Neither the original licensed download nor grants covering the other source photos were established. Do not distribute these exports or their derivatives pending permission. [Freepik stock downloads and license documentation](https://www.freepik.com/ai/docs/how-to-download-freepik-images)

The main project bundles the original SVGs at `brand/logo_blue.svg`, `brand/logo_purple.svg`, and `brand/logo_orange.svg`, plus the unmodified `auth/login_image.png`. The launcher and launch PNG changes under Android `mipmap-*` and iOS `AppIcon.appiconset` and `LaunchImage.imageset` derive from a one-time render of the supplied Blue SVG. The manual renderer is preserved in the private cleanup archive. Android and iOS builds package the checked-in PNGs through their standard resource systems. Keep these assets, screenshots and binaries local while redistribution permission remains unresolved. [Original Blue Splash](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4551)

## Runtime maps and photos

The property map displays runtime OpenStreetMap tiles with linked attribution. Tiles are fetched under the public tile service policy and cached by Flutter Map. No tiles are bundled. [OpenStreetMap copyright and ODbL attribution](https://www.openstreetmap.org/copyright) · [OSMF tile policy](https://operations.osmfoundation.org/policies/tiles/)

Property photos are supplied by the API. The backend documentation records the demo dataset's sources. [Pexels license](https://www.pexels.com/license/)
