// Local samples shaped like the bilingual rental-022 payload.
Map<String, Object?> summaryJson({bool arabic = false}) => {
  'id': 'rental-022',
  'title': arabic
      ? 'دوبلكس بدرج داخلي في شرق أوستن'
      : 'Eastside Staircase Duplex',
  'address': arabic ? 'شرق أوستن، أوستن، تكساس' : 'East Austin, Austin, TX',
  'type': 'duplex',
  'price': 2750,
  'currency': 'USD',
  'pricingPeriod': 'month',
  'rating': 4.6,
  'thumbnail': 'https://example.test/front.jpg',
  'isFeatured': false,
};

Map<String, Object?> detailsJson({bool arabic = false, String? avatar}) => {
  ...summaryJson(arabic: arabic),
  'description': arabic ? 'وحدة للإيجار بثلاث غرف نوم' : 'Three-bedroom rental',
  'bedrooms': 3,
  'bathrooms': 2,
  'area': 137.5,
  'areaUnit': 'sqm',
  'images': ['https://example.test/front.jpg', 'https://example.test/back.jpg'],
  'facilities': ['patio', 'air-conditioning', 'in-unit-laundry'],
  'agent': {'id': 'agent-austin', 'name': 'Jonah Reyes', 'avatar': avatar},
  'location': {'latitude': 30.263, 'longitude': -97.722},
  'reviews': [
    {
      'id': 'rental-022-review-1',
      'reviewerName': 'Drew Diaz',
      'rating': 5,
      'comment': arabic
          ? 'كان وجود حمام ثانٍ مريحاً.'
          : 'A second bathroom was convenient.',
      'date': '2025-07-17T16:00:00Z',
    },
  ],
  'createdAt': '2025-06-23T16:00:00Z',
};

Map<String, Object?> filterOptionsJson({
  num? min = 975,
  num? max = 4250,
  List<Map<String, Object?>>? histogram,
  bool arabic = false,
}) => {
  'price': {
    'min': min,
    'max': max,
    'currency': 'USD',
    'pricingPeriod': 'month',
    'histogram':
        histogram ??
        [
          {'from': 975, 'to': 1138.75, 'count': 2},
          {'from': 1138.75, 'to': 4250, 'count': 28},
        ],
  },
  'area': {
    'min': min == null ? null : 26,
    'max': max == null ? null : 238.25,
    'unit': 'sqm',
  },
  'bedrooms': {'min': min == null ? null : 0, 'max': max == null ? null : 5},
  'bathrooms': {'min': min == null ? null : 1, 'max': max == null ? null : 4},
  'types': min == null
      ? []
      : [
          {'id': 'duplex', 'label': arabic ? 'دوبلكس' : 'Duplex'},
        ],
};

Map<String, Object?> listingEnvelope({bool arabic = false}) => {
  'success': true,
  'data': [summaryJson(arabic: arabic)],
  'pagination': {
    'page': 2,
    'limit': 1,
    'total': 30,
    'totalPages': 30,
    'hasNextPage': true,
    'hasPreviousPage': true,
  },
};
