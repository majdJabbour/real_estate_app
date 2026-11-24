# Real Estate design system

Phase 1.1 Figma analysis and Phase 1.2 shared Flutter design system · 2026-11-24

## 1. Source and frame inventory

The supplied Figma file is `YKHgRiNXTErazshNFTD1Fz`, page `0:1`. The unsectioned Blue frames are the proposed default. The named sections contain [New Purple (1:2987)](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2987) and [New Orange (1:2188)](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2188). The single [colors reference (1:4584)](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4584) is 544 × 726 and includes the [typography sample (1:4613)](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4613). [Source file](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/Real-Estate-Mobile-App-Design--Community---Copy-?node-id=0-1)

| Screen | Figma frame size, all variants | Original Blue | New Purple | New Orange |
| --- | --- | --- | --- | --- |
| Splash | 430 × 932 | [1:4551](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4551) | [1:3753](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3753) | [1:2954](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2954) |
| Auth | 430 × 932 | [1:4499](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4499) | [1:3701](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3701) | [1:2902](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2902) |
| Home | 430 × 1459 | [1:4426](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4426) | [1:3628](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3628) | [1:2829](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2829) |
| Details | 430 × 2060 | [1:4236](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4236) | [1:3438](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3438) | [1:2639](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2639) |
| Search-v1 | 430 × 1041 | [1:4120](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4120) | [1:3322](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3322) | [1:2523](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2523) |
| Search-v2 | 430 × 1051 | [1:4055](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-4055) | [1:3257](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3257) | [1:2458](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2458) |
| Filters | 430 × 955 | [1:3867](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3867) | [1:3069](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3069) | [1:2270](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2270) |
| Profile | 430 × 975 | [1:3786](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-3786) | [1:2988](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2988) | [1:2189](https://www.figma.com/design/YKHgRiNXTErazshNFTD1Fz/?node-id=1-2189) |

Figma MCP returned 27 renders during analysis, covering each of the 24 frames, both variant sections and the colors reference. The links above identify the captured nodes. The individual Orange frames resolved text and imagery that appeared blank in the Orange section render. Measurements come from node properties, including instance descendants and styled text runs. Screenshots provided a visual cross-check. The analyzed source uses English example text and simulated iOS chrome. Flutter should use system insets and native system chrome.

## 2. Cross-variant comparison

Layer-tree positions, sizes, names, kinds, visibility, auto-layout metrics, corner radii, font runs, vector geometry, image-fill hashes and transforms, and effects were compared across matching frames. All 24 frames are 430 Figma px wide. Dimensions below are source units. Flutter layout values are proposed in section 8.

| Screen | Shared structure | Variant differences |
| --- | --- | --- |
| Splash | White frame, centered mark, same vector path geometry, mark bounds 133.885 × 112.445 | Blue logo lockup at (77, 379) measures 276 × 174.445. Purple and Orange start at (100, 380) and measure 230 × 172.445. Tagline is Outfit Medium 12 in Blue, 10 in Purple and Orange. The main gradient stops and some gradient transforms differ. The dark swoosh is shared. |
| Auth | Identical collage geometry, nine image sources and crops, typography, Google mark and button layout | Auth heading accent changes in a rich text run. The button border follows the 4% primary tint. |
| Home | Identical header, search, section spacing, carousel, grid, tabs, typography and imagery | Primary changes on links, grid prices, selected chip and tab, notification dot and tinted borders. Featured prices and favorite outlines on photos stay white. |
| Details | Identical hero, gallery, overview, stats, facilities, icons, review, and footer geometry, text metrics and imagery | Accent colors change on indicators, icons, tags, actions and pricing. Stat, facility and tag backgrounds use 4% primary in Blue and 10% in Purple and Orange. Map ground and rating star stay shared. |
| Search-v1 | Same input, horizontal chips, results header, list card sizes, content and imagery | The input caret is accented in a styled text run. Chip, price, back-button tint, and navigation accents follow the palette. |
| Search-v2 | Same empty search input, chips, card geometry, images and typography | Chip, price, back-button tint and navigation accents follow the palette. The selected Explore icon's internal pale path remains shared in addition to its themed foreground. |
| Filters | Same sheet background at y=197, controls, labels, example bars and CTA dimensions | The content group is y=223 in Blue (`1:3971`) and y=221 in Purple (`1:3173`) and Orange (`1:2374`). The bars, range controls, selected chips and CTA are tinted by variant. |
| Profile | Same avatar image, menu layout and labels, nav geometry and typography | Selected nav, notification dot, avatar edit badge and dividers follow the palette. Logout red stays shared. |

Search-v1 and Search-v2 represent two distinct results layouts. The first shows entered search text and list cards, while the second shows a placeholder and grid cards. The theme comparison does not tie a query state to a results layout.

## 3. Colors and opacity

Hex values are sRGB. Percentages are source paint opacity before compositing. Unmarked opacity is 100%. **Primary** in the value columns below means the exact hex in the first row of that column. Role labels describe observed uses unless marked as a proposal.

| Role | Original Blue | New Purple | New Orange | Evidence |
| --- | --- | --- | --- | --- |
| Primary, selected tab text/icon, selected chip, CTA, links, price accents, notification dot | `#0061FF` | `#8B5DFF` | `#FF8000` | `1:4588`, selected chip `1:4479` / `1:3681` / `1:2882` |
| Strong primary tint, proposed primary container | `#0061FF` 10% | `#8B5DFF` 10% | `#FF8000` 10% | Blue Primary-2 `1:4592`; back circle `1:4103` / `1:3305` / `1:2506` |
| Subtle tint, search and Google button outlines, unselected chip fill, counter background | `#0061FF` 4% | `#8B5DFF` 4% | `#FF8000` 4% | `1:4458`, `1:4481`, `1:4547`, `1:4033` |
| Details tag, stats and facility icon backgrounds | `#0061FF` 4% | `#8B5DFF` 10% | `#FF8000` 10% | `1:4277` / `1:3479` / `1:2680`; stats `1:4283`; facilities `1:4319` |
| Unselected chip text and border | `#191D31` / primary 10% | same text / primary 10% | same text / primary 10% | `1:4481`, `1:4482` |
| Selected chip and primary button label | `#FFFFFF` | same | same | `1:4480`, `I1:4053;433:784` |
| Background and major surfaces | `#FFFFFF` | same | same | `1:4426`, `1:4473`, `1:3970` |
| Search field surface | `#FBFBFD` | same | same | `1:4458` / `1:3660` / `1:2861` |
| Primary, secondary and tertiary text | `#191D31`, `#666876`, `#8C8E98` | same | same | Reference `1:4601`, `1:4605`, `1:4609` |
| Divider and navigation top edge | primary 10% | primary 10% | primary 10% | `I1:3819;435:5228`, `1:4489`. Room row divider uses primary 4% at `1:4036`. |
| Unselected navigation, Explore icon inset | `#666876`, `#F9F9FA` | same | same | `1:4495`, `I1:4115;29221:577` |
| Slider track, active track and thumb outline | primary 10%, primary, primary | same ratios | same ratios | `1:4005`–`1:4007`; thumb fill `#FFFFFF`, label uses primary |
| Histogram bars | primary 10% | primary 10% | primary 10% | `1:3983`–`1:4003` |
| Ratings, shared accent | Star gradient `#FB9400` → `#FFAB38`, badge number `#246BFD`, badge fill `#FFFFFF` 90% | same | same | `I1:4085;85001:13426;430:6169`, `I1:4085;85001:13427`, `I1:4085;85001:13425`. Details inline rating text uses `#666876`. |
| Unselected property heart | Grid/list `#8C8E98`, featured `#FFFFFF`, Details `#191D31` | same | same | `I1:4085;85001:13433;430:8279`, `1:4182`, `I1:4470;85001:13415`, `1:4270` |
| Logout and modal scrim | `#F75555`, `#000000` 30% | same | same | `1:3856`, `1:3969` |
| Map illustration ground, media mask fills | `#EEF4FF`; `#BDBDBD` and `#C4C4C4` | same | same | `1:4389`, `1:4371`, `1:4238`. Mask fills are evidence for the photo geometry. A broken-image treatment needs approval. |
| Secondary brand, disabled, selected property favorite, general error and success | Unspecified | Unspecified | Unspecified | The sampled frames show active buttons, outline property hearts, and a red logout treatment. The accented review heart is a separate action. |

The Blue Primary-3 swatch `1:4596` actually uses `#0061FF` at **5%**. Its label `1:4598` says 4%. Multiple actual Blue UI layers use 4%, including `1:4458` and `1:4481`. The reference divider `1:4612` uses `#704F38` at 10%. In-app dividers use the brand tint. Unselected chips remain selectable. Section 12 records the implemented disabled, feedback and favorite roles.

The featured overlay `I1:4470;85001:13408` is shared across variants. Its linear stops are 0% position `#4B4B4B` at 0% opacity, 17.2% `#444444` at 11.4%, 27.1% `#404040` at 18%, 41.7% `#3A3A3A` at 27.7%, 52.6% `#363636` at 35%, 66.1% `#2F2F2F` at 46.3%, 80.2% `#282828` at 56.1% and 100% `#202020` at 70%. Positions and opacities here are displayed to one decimal percent.

The Splash mark uses separate linear paints at 100% opacity. This table records the stop positions to one decimal percent. Preserve the authored gradient transforms in the SVG.

| Mark path (Blue / Purple / Orange node IDs) | Original Blue stops | New Purple stops | New Orange stops |
| --- | --- | --- | --- |
| `1:4554` / `1:3756` / `1:2957` | 21.9% `#006CBD`, 100% `#004F94` | 0% `#8B5DFF`, 30.1% `#926EEB`, 73.2% `#976DFF`, 100% `#5F37C4` | 0% `#FF8000`, 30.1% `#FF952A`, 73.2% `#DF8831`, 100% `#FFA952` |
| `1:4555` / `1:3757` / `1:2958` | 6.7% `#006CBD`, 32.5% `#0067B6`, 69.5% `#005AA3`, 92.4% `#004F94` | 11.3% `#8B5DFF`, 72.8% `#A37FFF`, 100% `#6C35F5` | 11.3% `#FF9C39`, 72.8% `#E67400`, 100% `#FF9932` |
| `1:4556` / `1:3758` / `1:2959` | 11.3% `#006CBD`, 72.8% `#0059A2`, 100% `#004F94` | 11.3% `#8B5DFF`, 72.8% `#A37FFF`, 100% `#6C35F5` | 11.3% `#FF9C39`, 72.8% `#E67400`, 100% `#FF9932` |
| `1:4558` / `1:3760` / `1:2961` | 0% `#006CBD`, 30.1% `#0067B6`, 73.2% `#005AA3`, 100% `#004F94` | 0% `#8B5DFF`, 30.1% `#926EEB`, 73.2% `#976DFF`, 100% `#AD8CFF` | 0% `#FF8000`, 30.1% `#FF952A`, 73.2% `#DF8831`, 100% `#FFA952` |

## 4. Typography

The reference `1:4614` is Rubik SemiBold 36/40 px with zero tracking. The product UI uses upright Rubik Regular 400, Medium 500, SemiBold 600 and Bold 700. Figma line heights below retain their authored units. `Auto` uses font metrics. Tracking is zero except where specified. Project-local text styles were empty. For several inherited reference styles, the visible text runs expose resolved metrics and an instance style ID.

| Component | Extracted family, size / line height | Node examples |
| --- | --- | --- |
| Auth intro | Rubik Regular 16 / 180%, tracking 10% | `1:4544` |
| Auth hero, description and button | Rubik SemiBold 32 / 130%, Regular 18 / 180%, Medium 18 / 130% | `1:4545`, `1:4546`, `1:4550` |
| Splash wordmark and tagline | Outfit Black 20 / Auto, Outfit Medium 12 / Auto in Blue and 10 / Auto in Purple and Orange, both 10% tracking | `1:4561`–`1:4562`, `1:3763`–`1:3764`, `1:2964`–`1:2965` |
| Home greeting and name | Rubik Regular 12 / 180%, Medium 16 / 130% | `1:4452`, `1:4453` |
| Page/section titles and actions | Rubik SemiBold 20 / 120% on Explore and Home, SemiBold 20 / 130% on Profile, SemiBold 16 / 140% for Home actions | `1:4083`, `1:3809`, `1:4465` |
| Search and chips | Rubik Regular 14 / 130% for placeholder, SemiBold 14 / 130% for query; 14 / 180% chips, SemiBold selected and Regular inactive | `1:4145`, `1:4151`, `1:4153` |
| Grid card | Rubik SemiBold 16 / 120% title and price, Regular 12 / Auto address, SemiBold 10 / 140% rating | `I1:4473;85001:13429`–`13432`, `I1:4473;85001:13427` |
| List card | Rubik SemiBold 18 / 140% title and 18 / 120% price, Regular 14 / 140% address, SemiBold 8 / 140% rating | `1:4179`, `1:4180`, `1:4183`, `1:4177` |
| Featured card | Rubik Bold 20 / 110% title and 20 / 120% price, Regular 16 / 140% with 0.2 px tracking for address, SemiBold 12 / 140% badge | `I1:4470;85001:13410`, `I1:4470;85001:13418` |
| Details | Rubik Bold 24 / 120% title, SemiBold 20 / 120% sections and 18 / 120% agent name. Regular 16 / 170% overview and review, Regular 14 / 140% facility label. Small tag uses SemiBold 10 / Auto. The 12 / Auto Medium price label has 2 px tracking. | `1:4275`, `1:4309`, `I1:4310;546:5919`, `1:4313`, `1:4323`, `I1:4277;442:2197`, `1:4423` |
| Filters | Rubik SemiBold 16 / 24 px section titles, Medium 14 / 20 px count labels, SemiBold 12 / 16 px price labels, Medium 14 / 180% filter chips when inactive, SemiBold 16 / 140% CTA. Counter values use Inter Bold 12 / 16 px. | `1:3980`, `1:4031`, `1:4010`, `1:4020`, `1:4034`, `I1:4053;433:784` |
| Profile and nav | Rubik SemiBold 24 / 120% name, Medium 18 / 140% menu, Medium 12 / 130% nav | `1:3818`, `1:3823`, `1:4495` |
| Illustration and library exceptions | Details map street labels use Urbanist Regular 10 / Auto with 0.2 px tracking. Filters area range labels use Inter Semi Bold 12 / 16 px. | `1:4396`–`1:4399`, `1:4051`–`1:4052` |

**Font files proposed for implementation.** Bundle a pinned upright `Rubik[wght].ttf` under SIL OFL 1.1 with its copyright and license. Upstream documents Arabic in the upright family starting in v2.300. Google Fonts lists Arabic and a 300–900 weight axis. Verify the exact shipped binary's character map and render Arabic at all four used weights on both platforms. Include Arabic-Indic digits, punctuation, mixed Latin names and diacritics in those checks. Bundle static instances at 400/500/600/700 if Flutter's variable font behavior fails a device check. There is no UI requirement for italics in the sampled frames. [Rubik upstream](https://github.com/googlefonts/rubik#source-files-v2300) · [Google Fonts metadata](https://raw.githubusercontent.com/google/fonts/main/ofl/rubik/METADATA.pb) · [Rubik license](https://github.com/google/fonts/blob/main/ofl/rubik/OFL.txt)

Outfit, Inter and Urbanist are also distributed under OFL. Their cited distributions list no Arabic subset. If an approved outlined SVG includes the English wordmark, it removes the need for an Outfit runtime font. If the Splash tagline is live or localized, use Rubik for Arabic and either bundle Outfit 500/900 for approved Latin text or approve one Rubik style. Inter is only needed for literal parity of the small filter numeral styles. Urbanist is tied to the decorative map instance. Propose Rubik for locale-aware counter values and omit the illustrative map typography if the map asset is omitted. Device shaping and exact binary coverage remain to be verified. [Outfit metadata](https://raw.githubusercontent.com/google/fonts/main/ofl/outfit/METADATA.pb) · [Inter metadata](https://raw.githubusercontent.com/google/fonts/main/ofl/inter/METADATA.pb) · [Urbanist metadata](https://raw.githubusercontent.com/google/fonts/main/ofl/urbanist/METADATA.pb)

## 5. Spacing, shape and effects

| Source pattern | Extracted values | Nodes |
| --- | --- | --- |
| Phone content margins and headers | 20 px sides give 390 px content at the 430 px frame. Details' 428 px internal canvas gives 388 px content with 20 px padding. Header action slot is 44 × 44 with a 22 px glyph. | `1:4448`, `1:4454`–`1:4456`, `1:4273` |
| Search and chips | Search 390 × 52, radius 6, 1 px border, 20 px glyphs with 14 px side insets. Scroll chips 41 px high, radius 30, 8 px vertical and 20 px horizontal padding, 12 px gap. Filter chips are 33 px high with 4 px vertical padding, 10 px gaps, and 1 px inactive borders. | `1:4458`, `1:4478`–`1:4482`, `1:4014`–`1:4019` |
| List, grid and carousel | List vertical gap 16. Grid column gap 16, row gap 20. Featured horizontal gap 20. Shared photo corner radius 10 on list/grid/gallery and 20 on the featured image mask. | `1:4169`, `1:4472`, `1:4475`, `1:4469`, `I1:4470;85001:13405`, `1:4174`, `1:4372` |
| Filters and main actions | Sheet top corners 24, content group gap 32, body section gap 30. CTA radius 100, 16 px button padding in Filters, 14 px vertical and 16 px horizontal padding in Details. | `1:3970`, `1:3971`, `1:3978`, `1:4053`, `1:4425` |
| Details content | 30 px section gap, 24 px top/bottom and 20 px side padding. Footer 428 × 110 with top radius 36 and 1 px stroke. Hero reference is 428 × 460 (about 0.93 width-to-height). | `1:4273`, `1:4420`, `1:4239` |
| Dividers and icon discs | Profile divider 1 px, filter counter divider 1.5 px. Details stat disc 40 with 16 px glyph, facility disc 60 with 28 px glyph. Discs have radius 100 in Figma. | `I1:3819;435:5228`, `1:4036`, `1:4283`, `1:4319`, `1:4320` |

| Figma drop shadow | Color and opacity | Offset x/y · blur · spread | Nodes |
| --- | --- | --- | --- |
| Card shell | `#04060F` 5% | 0/4 · 60 · 0 | `1:4473`, `1:4170` |
| Rating pill | `#04060F` 12% | 0/20 · 100 · 0 | `I1:4470;85001:13416`, `I1:4473;85001:13425`, `1:4175` |
| Google button | `#000000` 20% | 0/4 · 120 · 0 | `1:4547` |
| Primary button shell | `#704F38` 25% | 4/8 · 24 · 0 | `1:4053`, `1:4425` |
| Primary button text effect | `#246BFD` 25% | 4/8 · 24 · 0 | `I1:4053;433:784`, `I1:4425;433:784` |

All listed effects use normal blending and matched across the three variants. The inspected frames supply drop-shadow geometry. Material elevation levels are an implementation choice to validate visually. The measured 20, 16, 12 and 8 px steps are candidates for common spacing. Keep the 6, 10, 24, 28, 30 and 36 px radii where they describe actual component silhouettes. A pill or disc can derive its radius from its bounds. Widget touch regions can exceed the visual icon or chip bounds.

## 6. Reusable components

Dimensions are Figma references. Clear selected, active and unselected examples exist for tabs and chips. Where loading, focus, pressed, error or disabled appearances lack a sampled frame, define them during implementation review through shared component themes and semantics.

| Component | Source and measured shape | State, theme and data |
| --- | --- | --- |
| Primary button | Set Filter `1:4053` 390 × 54. Booking Now `1:4425` 236 × 50. Both radius 100. | Active brand fill and white label. Keep a shared button style. Filter state controls applicability. Booking scope is unresolved. |
| Google Sign-In | `1:4547` 390 × 59, radius 30, 10 px mark-to-text gap, 22 × 22 multicolor mark `1:4549`. | Shared white surface and themed 1 px outline. Auth state supplies pending, cancellation and error behavior. Follow Google branding during implementation. |
| Icon button | Header `1:4454` 44 × 44 and 22 px glyph; Search back `1:4102` 44 × 44; Filters back `1:3973` 32 × 32 and 20 px glyph. Details top action strip `1:4266` is 428 × 48. | White and tinted backgrounds with dark glyphs, with a themed notification badge in the mock. Enlarge hit targets and expose labels. |
| Search input | `1:4458`, `1:4077`, `1:4142`, all 390 × 52. | Placeholder and filled examples; themed border and caret. Query, debounce, pagination and data loading use server state. |
| Filter chips | `1:4479`, `1:4481`, `1:4015`, `1:4019`. Heights 41 and 33. | Selected brand, unselected tinted. Use server type IDs and localized labels. All means no type constraint. |
| Property grid card | `1:4473` / `1:4085` 187 × 275, radius 12, inner padding 16 top/14 sides/20 bottom. Image 159 × 154, ratio about 1.03. | Dynamic title, address, thumbnail, rating, monthly price, ID and favorite membership. Price uses brand. Height follows text and constraints. |
| Property list card | `1:4170` 390 × 128, radius 28, 100 × 100 image. 14 px leading inset and image-to-text gap, 18 px trailing inset. | Same data as grid. Reflow text and price on compact widths and larger text. |
| Featured property card | `1:4470` 250 × 340, image ratio about 0.74. Image mask `I1:4470;85001:13405`. | Server `featured=true`; photo overlay, white text and heart. Shared visual structure with dynamic content. |
| Rating | Featured pill `I1:4470;85001:13416` 58 × 25 with 14 px star. Grid `I1:4473;85001:13425` 40 × 22 with 10 px star. List `1:4175` 35 × 15 with 8 px star. Details `1:4279` 20 × 20 star. | Shared star gradient and badge palette. Format dynamic scores and give accessible ratings. Any displayed review count must come from returned data. |
| Favorite button | Grid `I1:4473;85001:13433` 20 × 20, list `1:4182` and featured `I1:4470;85001:13415` 22 × 22, Details `1:4270` 28 × 28. | Outline examples use contextual colors. Use one authenticated membership set and define a distinct selected appearance during review. |
| Bottom navigation | `1:4489`, `1:4110`, `1:4226`, `1:3857`. Strip 430 × 86, 24 px icons, 6 px icon-to-label gap, 1 px top stroke. | Home, Explore and Profile, with bold selected symbols and outline unselected symbols. The selected Explore glyph includes a shared pale detail. Native safe area is separate from the strip. |
| Section header | `1:4463`, `1:4466` 390 × 24, 12 px gap. Details `1:4367` 388 × 24. | Optional accent action. Wrap title or reposition action as needed. Explore total comes from server pagination. |
| Counters | `1:4030` and `1:4037` 390 × 24 rows. Step controls `1:4033` / `1:4040` are 23 × 24 or 24 × 24, 16 px internal gap in `1:4032`. | Tinted circles and primary symbols. Draft minimums for bedrooms/bathrooms. Respect valid bounds and provide accessible increment/decrement. |
| Range sliders | `1:4004` 386 × 24 and `1:4045` 390 × 48. 4 px track, 24 px thumbs with 3 px outline. | Active and inactive tracks, white thumbs, primary labels. Adapt track and value label placement to server price and area ranges. |
| Price histogram | `1:3982` 390 × 58.273 with 21 authored bar layers; most are 15.471 px wide. | Reference colors and size guide rendering. Server bucket counts drive painting. Supports 20, one, or zero buckets per the contract. |
| Profile menu | `1:3821`, `1:3854` 390 × 28 content rows, 28 px glyph and 20 px chevron for navigable rows. Rows typically have a 24 px gap. Avatar `1:3817` 140 × 140. | Shared labels and themed edit badge with a separate red logout action. Profile fields come from the verified session or API. |
| Facility and stat items | Facilities `1:4316` 388 × 196, cells `1:4318` 91 × 88, 60 px disc / 28 px glyph. Stats `1:4283` use 40 px discs / 16 px glyphs. | Brand glyph and variant tint. Localize backend facility keys; allow wrapping and a fallback icon or label for an unrecognized key. |
| Gallery | `1:4366`, `1:4370`, `1:4373`, `1:4376`: 118 × 118 images, radius 10, x positions 0/135/270. Hero `1:4239` uses 428 × 460. | Dynamic photos, index dots and remaining-photo count. The mock `20+` does not define a runtime count. |

## 7. Assets and provenance

| Asset | Source nodes and availability | Proposed export and use |
| --- | --- | --- |
| Real Scout logos | Blue lockup/mark `1:4552` / `1:4553`, Purple `1:3754` / `1:3755`, Orange `1:2955` / `1:2956`. All three marks exported to SVG bytes through Figma MCP for an availability check. | Keep one SVG per approved brand mark to preserve gradient stops, transforms and `#414042` swoosh. Keep the localized tagline as text. Export an outlined English wordmark only if approved as fixed branding. |
| Auth collage | `1:4521`, Purple `1:3723`, Orange `1:2924`. Nine visible photo tiles across three 109 px columns, ~9 px vertical gaps and radius 10. Figma resolves the image sizes of the 12 image-fill references in the Blue subtree, including layers outside the visible tile set. The nine visible image fills match across themes. Fade `1:4541` uses `#FBFBFB` at 10% opacity at 56.5% and `#FCFCFC` at 100% at 92.8%. | One licensed shared raster composite or reusable cropped set with native fade, depending on crop and responsiveness review. Keep type and buttons live. Photo provenance for the reference collage is pending. |
| Google mark | `1:4549`; SVG bytes available. Flat colors `#4285F4`, `#34A853`, `#FBBC04`, `#EA4335`. | Use approved official artwork and keep all four colors. Validate button styling against Google's guidance. [Google branding guidelines](https://developers.google.com/identity/branding-guidelines) |
| Iconly, Vuesax and facilities | Iconly notification `1:4456`, home `1:4491`, selected Explore `1:4115`, filters Vuesax `1:4078`, facility glyph `1:4320`. MCP returned SVG for selected icon/frame samples. | SVG export for verified licensed glyphs, or approval of equivalent native icons. Recolor a shared glyph only if all visible parts are intended to take the same color. Preserve masks, holes and compound paths. Use an explicit palette slot for multi-paint assets such as selected Explore. |
| Decorative assets | Ratings `I1:4085;85001:13426` use a two-stop star; Details map `1:4385` is a stylized preview with a themed pin. Photo media masks are present. A standalone broken-image placeholder was not identified. | Retain the rating gradient if licensed or render it natively. Use real backend location data for address/coordinates and an approved map behavior. Propose a shared native image fallback with a semantic label. |
| Listing, gallery and avatar imagery | Featured `I1:4470;85001:13406`, thumbnail `I1:4473;85001:13424`, gallery `1:4372`, Details hero `1:4239`, profile mock avatar `1:3817`. | Serve listing/hero/gallery images from the API and profile imagery from nullable backend fields. The mock images and identities are design samples. |
| Fonts | Rubik sample `1:4614`, Outfit wordmark `1:4561`, Inter counter `1:4034`, Urbanist map labels `1:4396`–`1:4399`. | See section 4 for distributable sources and which files are justified. |

Figma export access confirms technical availability. It does not establish redistribution rights. The supplied file is a copy. Establish the original Community listing, creator, file license, and applicable third-party logo, icon and photo terms before bundling source artwork. Figma's free-file policy generally requires attribution under CC BY 4.0. The exact source listing and the individual Figma artwork licenses remain unresolved. The backend documents separately licensed Pexels URLs for the demo property dataset. [Figma Community licensing](https://help.figma.com/hc/en-us/articles/360042296374-Figma-Community-copyright-and-licensing) · [Pexels license](https://www.pexels.com/license/)

## 8. Phase 1.1 theme proposal and responsive layout references

### One theme factory

- Define `AppThemeVariant` with `blue`, `purple` and `orange`. Select Blue by default. Build all three light themes through one factory that combines shared typography, spacing, shapes, effects, and component defaults with an immutable palette for the selected variant.
- Set `ThemeData.colorScheme` using explicit role mappings for `primary`, `onPrimary`, `primaryContainer`, `surface`, `onSurface`, and dividers or outlines where their semantics match. A seed-generated scheme can drift from measured sRGB values, so any generated fallback should be overridden for the assigned roles. There is no measured secondary brand. Define a secondary role only as needed by Material, with the decision documented.
- Read `Theme.of(context).colorScheme`, `textTheme` and component themes in feature widgets. Use Material button, navigation, chip, input, divider and slider themes where they express the required states. Use one small immutable `ThemeExtension` for genuinely custom roles such as Details tint, histogram fill, rating palette and contrast-tested brand foregrounds if they need to vary independently. Read it through `Theme.of(context).extension<T>()`. Select the logo asset through the same palette/configuration path.
- Keep a single component per behavior across all themes. Property grid, list and featured treatments can share content models and small subcomponents while retaining their purposeful layout differences. Screens consume semantic roles and avoid branching on brand.
- If runtime switching is approved later, use generated Riverpod state and SharedPreferences. Persist stable values `blue`, `purple`, `orange`, restore before rendering where practical, and fall back to Blue for missing or unknown values. Runtime switching and dark mode are outside this proposal's implementation scope.

**Accessible role mapping is a proposal.** Using sRGB luminance on white, the primary contrasts are 5.06:1 Blue, 4.11:1 Purple and 2.52:1 Orange. Tertiary text is 3.26:1, and logout red is 3.29:1. Purple and Orange need an approved normal-text foreground/brand text pairing for CTAs and small links. Keep source values in the design table, then verify contrast on actual backgrounds and overlays. Use a stronger approved text role for critical small secondary content, and communicate selected/error states through shape, iconography or labels as appropriate. [WCAG contrast minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html)

### Width strategy

These are engineering starting points. Use local constraints after safe insets and side padding, with actual content and text scaling determining layout. Keep the guideline breakpoints at 360, 600, and 840 dp, using a padding transition at 390 dp. At reference scale the Figma grid cards are 187 dp wide. Start with a **proposed 160 dp minimum** for regular text and a 16 dp gap. Compute columns from available content width and usable card minimum, with a cap of 3 on tablet widths below 840 pending device review. Raise the effective minimum or switch to one column when text or actions cannot fit.

| Available logical viewport | Side padding | Content width before safe insets | Proposed default grid |
| --- | --- | --- | --- |
| 320 dp | 16 dp | 288 dp | 1 column. Allow list thumbnail and price layout to reflow. |
| 375 dp | 16 dp | 343 dp | 2 × 163.5 dp if content fits. |
| 390 dp | 20 dp | 350 dp | 2 × 167 dp if content fits. |
| 430 dp | 20 dp | 390 dp | 2 × 187 dp, matching the Figma reference. |
| 600 dp | 24 dp | 552 dp | Up to 3 × 173.3 dp. |
| 768 dp | 24 dp | 720 dp | Up to 3 × 229.3 dp with the proposed cap. |

Use `LayoutBuilder`, `Flexible`/`Expanded`, `Wrap`, slivers, adaptive grid delegates, `AspectRatio`, `SafeArea` and `MediaQuery` for insets and the system text scaler. A grid delegate can derive its column count from constraints and reserve predictable image space while allowing for necessary text height. Use the measured image ratios as starting points and tune `BoxFit.cover` cropping with backend photos. On wider screens, propose a centered 1120 dp content cap for property collections, 680 dp for Details, 560 dp for Filters, and 480 dp for Auth. These caps are provisional.

Keep featured cards and category chips in horizontally scrollable sections, with a partial following tile where space permits. Keep the filter sheet scrollable from the body to the viewport edge, with Apply reachable above the safe area. At short heights or with the keyboard open, allow the sheet to occupy more space and keep focus visible. Preserve page navigation, search state and scroll position. Use roughly 48 dp target areas where feasible even for 20–28 px visual glyphs, and allow labels to wrap or reflow. Validate 320/375/390/430 dp, tablet proposals, landscape, English, Arabic and enlarged text with Flutter before accepting these measurements for implementation.

## 9. Arabic and RTL

- Use generated English and Arabic ARB localizations and the resulting `Directionality`. Keep English as the proposed default. Use `EdgeInsetsDirectional`, `AlignmentDirectional`, and start/end placement for card content, search controls, layouts, headers and price rows.
- Lay out tabs, chips and horizontal carousels from the logical start. Let back, forward and trailing chevrons mirror where directional. Preserve the identity of brand marks, Google artwork, hearts, stars, media and nondirectional facility icons. Map orientation remains tied to geography.
- Keep gallery item and page indicator order consistent with visible navigation and screen-reader order. Provide slider semantics for minimum and maximum. Draw histogram bars in the same direction as increasing slider values and test both directions with actual thumb positions.
- Let Rubik shape bilingual text. Keep localized units and currency patterns together. Use locale-aware numbers and isolate mixed-script segments where needed, including phone numbers or identifiers supplied by a legitimate source. Avoid tracking Arabic letters merely to match a Latin heading. Test Arabic joining, baselines, numerals, long labels, diacritics, wrapping and large text on both platforms.
- Fetch localized titles, descriptions, addresses and review comments with `Accept-Language`. Translate stable type/facility keys and UI strings locally as appropriate, keeping server-provided localized filter labels. State, role colors and layout policy are shared across all three themes.

## 10. API and assessment scope

The following mapping follows [API_CONTRACT.md](API_CONTRACT.md), [AGENTS.md](AGENTS.md) and [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md). Figma documents candidate screens and actions. The developer still decides which are assessment requirements.

| Figma area or action | Contract and proposed treatment |
| --- | --- |
| Splash and Auth | Splash can present approved branding. Google sign-in and session restoration are a later Firebase client phase. `GET /auth/me` verifies the Firebase ID token and returns nullable profile fields. Public browsing can work before sign-in. Confirm whether Splash/Auth require dedicated routes in the assessed flow. |
| Home Featured and Recommendations | `GET /properties?featured=true` supports Featured. A second listing query can power recommendations. Personalized recommendations are absent from the contract. Resolve See All into approved Explore behavior with relevant filters. |
| Explore list/grid | Both consume the same listing, server search, sort, filters, pagination and total. Example categories such as Villa/Other are sample text. Use supported types from the backend. Adopt one Explore route with reusable result layouts. Confirm layout mode and any control for switching. |
| Filters | `GET /properties/filter-options` gives global bounds, histogram and localized types. Use server buckets, handle null/equal ranges, keep draft separate from applied values, and apply only on Set Filter. Price is USD/month and area is sqm. Room counters are minimum filters with zero meaning no constraint. |
| Details data | `GET /properties/:id` supplies photos, facilities, coordinates, agent name/nullable avatar, reviews, bedrooms, bathrooms and area. The mock sqft units and sample price must follow the API's units and values. Gallery count derives from photos. The contract has no review-total field beyond the returned reviews, no likes, no separate review endpoint and no agent contact channels. |
| Favorites | Protected `GET /favorites/ids`, `PUT /favorites/:propertyId` and `DELETE /favorites/:propertyId` support property hearts. Keep one session-scoped ID set, optimistic rollback and stale-session guards. The paginated favorite listing endpoint does not create an assessment screen. |
| Profile and settings | Verified name/email/avatar, locale selection and SDK logout have an implementation path. Profile editing, avatar uploads, notifications, and security settings do not have contract endpoints. |
| Booking, payments, chat/phone, help and invitations | Unsupported by this contract. The proposed demo scope omits these actions or presents an explicitly approved disabled treatment where a visible reference is required. No fabricated contacts, booking confirmation, payments or notification data. |
| Local share or map handoff | Can be considered for later approval with verified coordinates, a legitimate share destination and existing platform capabilities. The contract supplies coordinates and address. It supplies neither map tiles nor a public listing deep-link format. |

## 11. Open decisions and extraction limits

1. Confirm mandatory frames and Explore layout behavior, including whether Splash, Auth, Profile and each detail action are in assessment scope.
2. Confirm original artwork provenance, rights, and attribution for delivery. Resolve the localized tagline, authorized auth imagery and icon sources, Google button styling, and map action.
3. Verify final feature layouts with realistic localized data, dynamic media, and enlarged text on both platforms.
4. The Figma review covered the supplied canvas, including resolved instance content. External component library states, redistribution rights, and Flutter pixel parity need separate verification.

## 12. Phase 1.2 implementation

### Approved decisions

- Blue is the default. Preserve `#0061FF`, `#8B5DFF`, and `#FF8000` in `ColorScheme.primary`. Use the actual 4% subtle tint and 10% stronger tint, with Details using 4% in Blue and 10% in Purple and Orange.
- Use the Blue Filters layout reference when the sheet is implemented. Its content starts at y=223 in the source frame, 26 px below the sheet top. Apply that placement across variants, accounting for responsive constraints and safe areas.
- Keep the shared rating gradient, `#246BFD` number ink, and 90% white source badge. Keep the official Google mark multicolor when Auth is introduced. Blue, Purple and Orange logo references are `1:4553`, `1:3755`, and `1:2956`. Source artwork remains pending verified rights.
- Use Rubik in weights 400, 500, 600 and 700, including counters. Urbanist and Inter are omitted. Outfit remains optional for fixed Splash branding.

### Theme and controls

`AppTheme.light()` maps an immutable palette into one light `ThemeData` factory. Native component themes define filled and text buttons, icon buttons, chips, input, text selection, and dividers. Widgets obtain semantic roles from `Theme.of(context)` and `AppThemeColors.of(context)`. The typed extension carries Details tint, success, favorite and placeholder roles with `copyWith` and color interpolation. The preview swaps themes immediately so animations between different foreground and background pairs do not introduce transient contrast issues.

The four primitives are `AppPrimaryButton`, `AppIconButton`, `AppSearchField`, and `AppChoiceChip`. They use the source 54 dp action minimum, 44 dp icon surface with a padded 48 dp target, 52 dp search minimum, and normal/compact chip padding from section 5. Content can grow with text scaling. A checked mark supplements selected chip color. The preview uses Material glyphs pending decisions on source icon licensing. The favorite example switches between filled and outline hearts. The loading example disables activation and announces its label in a live region.

### Accessible colors

| Role | Blue | Purple | Orange |
| --- | --- | --- | --- |
| Original brand fill | `#0061FF` | `#8B5DFF` | `#FF8000` |
| Button and selected chip foreground | `#FFFFFF` · 5.06:1 | `#101018` · 4.60:1 | `#191D31` · 6.61:1 |
| Brand text and focus on light surfaces | `#0061FF` · 5.06:1 on white | `#6338C6` · 7.21:1 on white | `#9A4500` · 6.51:1 on white |

| Shared semantic role | Foreground and surface | Contrast |
| --- | --- | --- |
| Error | `#B32636` on `#FCEBED` | 5.62:1 |
| Success | `#17643A` on `#E7F4EA` | 6.34:1 |
| Disabled | `#666876` on `#E8E9ED` | 4.55:1 |
| Image placeholder | `#666876` on `#F1F2F5` | 4.93:1 |
| Search placeholder and boundary | `#666876` placeholder and `#8C8E98` stroke on `#FBFBFD` | 5.34:1 text, 3.16:1 stroke |
| Favorite | `#A52650` filled, `#666876` outline | Tested at ≥3:1 on each preview icon tint |

Button and selected chip text use the accessible foregrounds above. Search uses a stronger neutral stroke in its enabled state and a 2 dp focus stroke. The source 4% tint is retained for the disabled search stroke and the unselected chip fill. Small secondary text and active search hints use `#666876`. A contrasting 2 dp ring indicates keyboard focus inside filled actions. Hover, focus and press overlays are calculated against the resting foreground. Tests use WCAG relative luminance for the rendered role pairings, including composited state layers. Review the future rating pill with real imagery because the original 90% background makes contrast depend on the photo. [WCAG contrast minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html)

### Bundled type and preview

The four upright static Rubik TTFs are version **2.300**, downloaded unchanged from upstream commit `9167c98fa8699d75ee51769eba20d81beb16bcb5`. Weight registration in `pubspec.yaml` matches each font's TrueType OS/2 weight class. The fonts and the upstream SIL Open Font License 1.1 with the 2015 Rubik Project Authors copyright are bundled locally. For each weight, Fontconfig verified 154 required Latin and Arabic code points, covering printable ASCII, standard Arabic letters, Arabic-Indic digits, punctuation and diacritics. HarfBuzz shaped both sample strings without missing glyphs. Flutter uses the measured text metrics for the implemented controls and zero tracking for these roles in both directions. Nonzero Latin tracking is recorded in section 4 for future use where appropriate. [Pinned upstream font files](https://github.com/googlefonts/rubik/tree/9167c98fa8699d75ee51769eba20d81beb16bcb5/fonts/ttf) · [Pinned OFL](https://github.com/googlefonts/rubik/blob/9167c98fa8699d75ee51769eba20d81beb16bcb5/OFL.txt)

`flutter run` opens the temporary preview directly. Theme chips and the English/Arabic toggle affect only the preview and use normal directionality and system text scaling. Flutter Widget Previewer annotations provide 430 dp and 320 dp views, including a 2× text sample. The property grid, Details components, and filter sheet layout remain implementation references. The phase establishes shared controls and tokens for future screens. It does not establish pixel parity.

### Phase 1.2 verification

The 23-test suite and coverage run passed. The widget tests checked Arabic RTL at widths of 320, 375, 390 and 430 dp and a 640 × 320 dp landscape viewport, all with 2× text scaling. The Android debug APK and unsigned iOS simulator app both built successfully. The iPhone 18 Pro simulator on iOS 27.2 rendered Blue and Purple in English and Orange in Arabic. The Arabic capture showed joined text, mirrored search controls and the filled favorite icon. The Android APK was built without a device run in this phase.
