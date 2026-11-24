# Real Estate API — Contract v1

Status: implemented v1 contract for the Flutter recruitment assessment. Live deployment and authenticated cloud verification are pending.

## 1. Protocol and scope

- Base path: `/api/v1`; HTTPS in deployed environments; JSON UTF-8.
- Property reads are public. Profile and favorites require a Firebase ID token.
- The initial property repository uses a bundled, validated JSON fixture. Favorites use Firestore. No property mutation endpoints are in scope.
- All search, filtering, sorting, counting, pagination and histogram aggregation take place on the server. The repository accepts queries, not a mandatory fetch-all interface.
- Pricing convention for the proposed rental demo: USD per month; area in square meters (`sqm`). These are explicit demo assumptions, not real listing data.

### Demo property fixture

The API uses `src/data/properties.normalized.json`, a validated fixture with 30 fictional monthly USD rentals across the six supported categories. Entries include bilingual text and explicit UTC timestamps. Prices are synthetic, and image URLs are illustrative. The original EUR sale-price fixture referenced in the initial plan was absent from the checkout and available Git history.

## 2. Endpoints

| Method | Path | Auth | Success |
|---|---|---|---|
| GET | `/health` | Public | 200 |
| GET | `/properties` | Public | 200 |
| GET | `/properties/:id` | Public | 200 |
| GET | `/properties/filter-options` | Public | 200 |
| GET | `/auth/me` | Required | 200 |
| GET | `/favorites` | Required | 200 |
| GET | `/favorites/ids` | Required | 200 |
| PUT | `/favorites/:propertyId` | Required | 200 |
| DELETE | `/favorites/:propertyId` | Required | 200 |

All paths above are relative to `/api/v1`.

## 3. Shared models

```ts
type Locale = 'en' | 'ar';
type LocalizedText = Record<Locale, string>;
type PropertyType = 'apartment' | 'townhome' | 'house' | 'condo' | 'duplex' | 'studio';
type PropertySummary = {
  id: string;
  title: string;
  address: string;
  type: PropertyType;
  price: number;
  currency: 'USD';
  pricingPeriod: 'month';
  rating: number;
  thumbnail: string;
  isFeatured: boolean;
};
type PropertyDetails = PropertySummary & {
  description: string;
  bedrooms: number;
  bathrooms: number;
  area: number;
  areaUnit: 'sqm';
  images: string[];
  facilities: string[]; // stable facility keys, localized in Flutter
  agent: { id: string; name: string; avatar: string | null };
  location: { latitude: number; longitude: number };
  reviews: { id: string; reviewerName: string; rating: number; comment: string; date: string }[];
  createdAt: string;
};
type Pagination = {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
};
type Success<T> = { success: true; data: T };
type Page<T> = Success<T[]> & { pagination: Pagination };
```

Internal records store `title`, `description`, `address`, and review `comment` as `LocalizedText` instead of strings. Use Zod to validate the fixture. IDs are nonempty stable strings, ratings are 0–5, prices and areas are finite positive numbers, room counts are nonnegative integers, timestamps are ISO 8601 UTC, coordinates are valid latitude/longitude, URLs use HTTPS. `avatar` is explicitly nullable. No user-specific favorite flag in public property responses; Flutter derives it from the authenticated favorites data.

## 4. Listing — GET /properties

| Parameter | Format | Default |
|---|---|---|
| search | trimmed string, max 120 chars | none |
| types | comma-separated PropertyType values | all |
| minPrice, maxPrice | finite nonnegative decimal | none |
| minBedrooms, minBathrooms | nonnegative integer | none |
| minArea, maxArea | finite nonnegative decimal | none |
| featured | literal `true` or `false` | none |
| sortBy | createdAt, price, rating, area | createdAt |
| sortOrder | asc, desc | desc |
| page | integer 1–1000000 | 1 |
| limit | integer 1–100 | 20 |

Validate with Zod. Reject unknown keys, duplicate parameter occurrences, malformed numeric strings, unsupported enum values, empty type lists and reversed ranges with 400. An empty or whitespace-only search is equivalent to absent search. Deduplicate types. Do not coerce `false` to true. Numeric range endpoints are inclusive. Selected types combine with OR; all other filters combine with AND. Room counts mean at least the selected number; zero imposes no minimum. `featured=false` selects non-featured properties only.

Search both language versions of title, description and address, regardless of response locale. Normalize Unicode, case, whitespace and Arabic diacritics/tatweel and common alef variants consistently; use substring matching on normalized fields. Document exact normalization and test it. No fuzzy search requirement.

Filter, count, sort, paginate, then map to summaries. Sort by requested field and use ID ascending as a deterministic secondary key. Offset = (page - 1) * limit. `totalPages = ceil(total / limit)` (0 when empty); `hasNextPage = page < totalPages`; `hasPreviousPage = totalPages > 0 && page > 1`. An out-of-range page returns 200 with an empty array, unchanged requested page and accurate total.

Example request:

```http
GET /api/v1/properties?search=modern&types=apartment,condo&minPrice=100&maxPrice=1500&minBedrooms=2&minArea=50&page=1&limit=20&sortBy=price&sortOrder=asc
Accept-Language: en
```

Example response (illustrative, one matching record):

```json
{
  "success": true,
  "data": [{"id":"1","title":"Modern Apartment","address":"Amsterdam, Netherlands","type":"apartment","price":950,"currency":"USD","pricingPeriod":"month","rating":4.8,"thumbnail":"https://example.com/property.jpg","isFeatured":true}],
  "pagination":{"page":1,"limit":20,"total":1,"totalPages":1,"hasNextPage":false,"hasPreviousPage":false}
}
```

## 5. Details — GET /properties/:id

Return `Success<PropertyDetails>` on a matching ID. Return 404 `PROPERTY_NOT_FOUND` for unknown IDs. Invalid ID syntax (empty, unsafe path characters, or longer than 128 characters) is a validation error where the route matches. Include the complete details model, not the raw repository record. No pagination for embedded demo reviews.

## 6. Filter options — GET /properties/filter-options

Returns global dataset bounds and distribution, independent of the currently applied query. This endpoint accepts no query parameters. This keeps the controls stable and avoids sending all properties to Flutter.

```ts
type Bounds = { min: number | null; max: number | null };
type FilterOptions = {
  price: Bounds & { currency: 'USD'; pricingPeriod: 'month'; histogram: { from: number; to: number; count: number }[] };
  area: Bounds & { unit: 'sqm' };
  bedrooms: Bounds;
  bathrooms: Bounds;
  types: { id: PropertyType; label: string }[];
};
```

Return `Success<FilterOptions>`. For nonempty data use 20 equal-width price buckets when min differs from max; buckets are lower-inclusive and upper-exclusive except the last, which includes the maximum. Counts sum to the number of properties. If all prices are equal return one bucket with identical endpoints. Empty dataset: null min/max, empty histogram, empty available types. Return only types present, in stable enum order, with localized labels. Flutter disables range controls for null or equal bounds.

## 7. Authentication — GET /auth/me

```http
Authorization: Bearer <firebase-id-token>
Accept-Language: en
```

Verify Firebase ID token on the Node.js runtime using Firebase Admin. Extract UID from verified claims; never accept an asserted UID from a request. Missing/malformed/invalid/expired tokens return 401. Authentication infrastructure failures return 503, not a misleading invalid-token error. No custom JWT or refresh endpoint. Flutter uses Firebase SDK for login and refresh.

```json
{"success":true,"data":{"id":"firebase-uid","email":"demo@example.com","name":"Demo User","avatar":null}}
```

`email`, `name`, and `avatar` may be null. Do not include token or private credentials. All protected responses: `Cache-Control: private, no-store`.

## 8. Favorites

Firestore path: `users/{uid}/favorites/{propertyId}`. Store stable property ID and creation timestamp. Derive ownership solely from verified UID. Never persist favorites in the bundled JSON or process memory.

- `GET /favorites?page=1&limit=20`: return `Page<PropertySummary>` ordered by favorite creation descending with ID ascending as tie-breaker. Same pagination defaults, limits and validation as listing. Exclude orphaned references from results and totals; document the mock repository strategy. No other query parameters.
- `GET /favorites/ids`: return `Success<string[]>` with unique favorite property IDs for the verified UID, ordered by ascending property ID. This endpoint accepts no query parameters and returns `200` for both populated and empty lists. Stored orphaned references may be included. Use the IDs to determine membership for existing displayed properties. The response carries IDs only and uses `Cache-Control: private, no-store`.
- `PUT /favorites/:propertyId`: require an existing property; add if absent without resetting its creation timestamp. Return `{"success":true,"data":{"propertyId":"1","isFavorite":true}}`. Repeated requests are safe, including concurrent requests (use atomic create or transaction).
- `DELETE /favorites/:propertyId`: remove the authenticated user's reference if present, otherwise no-op; return `{"success":true,"data":{"propertyId":"1","isFavorite":false}}`. Allow cleanup of orphaned references.

Use 404 for PUT on a nonexistent property. Flutter uses the ID endpoint for card and detail membership. Absence from a partial favorites page does not establish membership.

Example ID responses

```json
{"success":true,"data":["rental-001","rental-005"]}
```

```json
{"success":true,"data":[]}
```

## 9. Health — GET /health

```json
{"success":true,"data":{"status":"ok"}}
```

Liveness only, not a Firebase/database readiness guarantee. No secrets, internal paths, or environment details.

## 10. Localization and caching

Supported locales `en`, `ar`. Negotiate `Accept-Language` with primary subtags (e.g. `ar-SY`, `en-US`), respecting valid quality weights; default/fallback English. Missing localized text falls back to English. Localize titles, addresses, descriptions, review comments and type labels. Stable IDs, enum keys, currency, units, names and numbers do not change. Flutter localizes static UI and formats currency/units.

Set `Content-Language` on localized successes and `Vary: Accept-Language` where appropriate. Initially use `Cache-Control: no-store` for simplicity; introduce public cache only with correct locale variation. Error codes stay language-independent; messages are English diagnostics translated by Flutter using codes.

## 11. Errors

```json
{"success":false,"error":{"code":"VALIDATION_ERROR","message":"Invalid query parameters","details":[{"field":"minPrice","message":"Must be less than or equal to maxPrice"}]}}
```

| HTTP | Code |
|---|---|
| 400 | VALIDATION_ERROR |
| 401 | UNAUTHORIZED |
| 403 | FORBIDDEN |
| 404 | PROPERTY_NOT_FOUND |
| 500 | INTERNAL_SERVER_ERROR |
| 503 | SERVICE_UNAVAILABLE |

429 `RATE_LIMIT_EXCEEDED` is reserved for future implemented rate limiting. Never expose stack traces or credentials. Framework-generated errors outside matched routes are not guaranteed to use this envelope. Empty listings are not errors. Network timeouts and offline handling remain Flutter responsibilities.

## 12. Acceptance checks

- Fixture validates, contains all six types, and has stable IDs, dates and consistent units.
- Search matches Arabic and English; combined filters and inclusive boundaries are correct.
- Invalid booleans, ranges, sorting and pagination return 400.
- Pagination operates after filtering with accurate counts and deterministic order.
- Histogram covers all records without double counting, including empty and equal-price datasets.
- Localized summaries and details match the response schema; no raw bilingual fields leak.
- Public routes run without Firebase credentials; protected routes reject invalid tokens.
- Favorites are isolated by UID and mutations are idempotent.
- Vitest uses deterministic fixtures and mocked auth/storage; no production credentials required.
- Run lint, typecheck, tests and production build; record actual results in AI_USAGE.md.

## 13. Limitations and future migration

The bundled JSON is a read-only mock. Filtering runs in memory and uses offset pagination. A future PostgreSQL repository can implement indexed filtering, counts, pagination, and aggregation within the public property contract. Firebase Authentication and favorites are implemented for this assessment. Live Google Sign-In, real ID-token verification, authenticated Firestore persistence, and Vercel deployment verification are pending.
