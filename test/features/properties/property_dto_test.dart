import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/features/properties/data/property_dto.dart';
import 'package:real_estate_app/features/properties/data/property_filter_options_dto.dart';
import 'package:real_estate_app/features/properties/domain/property_type.dart';

import 'property_fixtures.dart';

void main() {
  group('property DTOs', () {
    test('summaries preserve localized strings, units, IDs and decimals', () {
      final english = PropertySummaryDto.fromJson(summaryJson()).toDomain();
      final arabic = PropertySummaryDto.fromJson({
        ...summaryJson(arabic: true),
        'price': 2750.25,
      }).toDomain();

      expect(english.id, 'rental-022');
      expect(english.title, 'Eastside Staircase Duplex');
      expect(english.address, 'East Austin, Austin, TX');
      expect(english.type, PropertyType.duplex);
      expect(english.price, 2750.0);
      expect(english.rating, 4.6);
      expect(english.currency, 'USD');
      expect(english.pricingPeriod, 'month');
      expect(english.thumbnail, 'https://example.test/front.jpg');
      expect(english.isFeatured, isFalse);
      expect(arabic.id, english.id);
      expect(arabic.title, 'دوبلكس بدرج داخلي في شرق أوستن');
      expect(arabic.address, 'شرق أوستن، أوستن، تكساس');
      expect(arabic.price, 2750.25);
    });

    test('details reuse summary fields and preserve ordered nested data', () {
      final details = PropertyDetailsDto.fromJson(detailsJson(arabic: true))
          .toDomain();

      expect(
        details.summary,
        PropertySummaryDto.fromJson(summaryJson(arabic: true)).toDomain(),
      );
      expect(details.description, 'وحدة للإيجار بثلاث غرف نوم');
      expect(details.bedrooms, 3);
      expect(details.bathrooms, 2);
      expect(details.area, 137.5);
      expect(details.areaUnit, 'sqm');
      expect(details.images, [
        'https://example.test/front.jpg',
        'https://example.test/back.jpg',
      ]);
      expect(details.facilities, [
        'patio',
        'air-conditioning',
        'in-unit-laundry',
      ]);
      expect(details.agent.id, 'agent-austin');
      expect(details.agent.name, 'Jonah Reyes');
      expect(details.agent.avatar, isNull);
      expect(details.location?.latitude, 30.263);
      expect(details.location?.longitude, -97.722);
      expect(details.createdAt, DateTime.utc(2025, 6, 23, 16));
      final review = details.reviews.single;
      expect(review.id, 'rental-022-review-1');
      expect(review.reviewerName, 'Drew Diaz');
      expect(review.rating, 5.0);
      expect(review.comment, 'كان وجود حمام ثانٍ مريحاً.');
      expect(review.date, DateTime.utc(2025, 7, 17, 16));
    });

    test('details accept a non-null avatar and empty arrays', () {
      final details = PropertyDetailsDto.fromJson({
        ...detailsJson(avatar: 'https://example.test/agent.jpg'),
        'images': [],
        'facilities': [],
        'reviews': [],
      }).toDomain();

      expect(details.agent.avatar, 'https://example.test/agent.jpg');
      expect(details.images, isEmpty);
      expect(details.facilities, isEmpty);
      expect(details.reviews, isEmpty);
    });

    test('new property types and facility keys keep their raw values', () {
      final details = PropertyDetailsDto.fromJson({
        ...detailsJson(),
        'type': 'loft',
        'facilities': ['patio', 'new-key'],
      }).toDomain();

      expect(details.summary.typeId, 'loft');
      expect(details.summary.type, isNull);
      expect(details.facilities, ['patio', 'new-key']);
    });

    test('mapped domain collections are snapshots', () {
      final dto = PropertyDetailsDto.fromJson(detailsJson());
      final details = dto.toDomain();
      dto.images.clear();

      expect(details.images, hasLength(2));
      expect(() => details.images.clear(), throwsUnsupportedError);
    });

    test('invalid or missing coordinates preserve the rest of Details', () {
      for (final location in [
        null,
        {'latitude': 91, 'longitude': 30},
        {},
      ]) {
        final json = detailsJson()..remove('location');
        if (location != null) json['location'] = location;
        final details = PropertyDetailsDto.fromJson(json).toDomain();
        expect(details.location, isNull);
        expect(details.summary.address, isNotEmpty);
      }
    });

    for (final (field, value) in <(String, Object?)>[
      ('agent', null),
      ('agent', {'id': 'agent-austin', 'name': 'Jonah Reyes'}),
      ('agent', {'id': 'agent-austin', 'name': 'Jonah Reyes', 'avatar': 1}),
      ('bedrooms', 2.5),
      ('images', [false]),
      ('facilities', ['patio', 42]),
      ('reviews', [null]),
      ('createdAt', 'yesterday'),
    ]) {
      test('rejects malformed detail field $field ($value)', () {
        expect(
          () => PropertyDetailsDto.fromJson({...detailsJson(), field: value}),
          throwsA(anyOf(isA<FormatException>(), isA<TypeError>())),
        );
      });
    }
  });

  group('filter DTOs', () {
    test('maps localized options, units, typed bounds and histogram', () {
      final options = PropertyFilterOptionsDto.fromJson(
        filterOptionsJson(arabic: true),
      ).toDomain();
      expect(options.price.bounds, (min: 975.0, max: 4250.0));
      expect(options.price.currency, 'USD');
      expect(options.price.pricingPeriod, 'month');
      expect(options.area, (min: 26.0, max: 238.25));
      expect(options.areaUnit, 'sqm');
      expect(options.bedrooms, (min: 0, max: 5));
      expect(options.bathrooms, (min: 1, max: 4));
      expect(options.types.single.type, PropertyType.duplex);
      expect(options.types.single.label, 'دوبلكس');
      final bucket = options.price.histogram.first;
      expect((bucket.from, bucket.to, bucket.count), (975.0, 1138.75, 2));
      expect(options.price.histogram, hasLength(2));
    });

    test('accepts null bounds and empty filter arrays', () {
      final options = PropertyFilterOptionsDto.fromJson(
        filterOptionsJson(min: null, max: null, histogram: []),
      ).toDomain();
      expect(options.price.bounds, (min: null, max: null));
      expect(options.area, (min: null, max: null));
      expect(options.bedrooms, (min: null, max: null));
      expect(options.bathrooms, (min: null, max: null));
      expect(options.price.histogram, isEmpty);
      expect(options.types, isEmpty);
    });

    test('preserves equal bounds and a single equal-edge bucket', () {
      final options = PropertyFilterOptionsDto.fromJson(
        filterOptionsJson(
          min: 1250.5,
          max: 1250.5,
          histogram: [
            {'from': 1250.5, 'to': 1250.5, 'count': 3},
          ],
        ),
      ).toDomain();
      expect(options.price.bounds, (min: 1250.5, max: 1250.5));
      final bucket = options.price.histogram.single;
      expect((bucket.from, bucket.to, bucket.count), (1250.5, 1250.5, 3));
    });

    test('preserves unknown type options and labels', () {
      final options = PropertyFilterOptionsDto.fromJson({
        ...filterOptionsJson(),
        'types': [
          {'id': 'loft', 'label': 'Loft'},
        ],
      }).toDomain();
      expect(options.types.single.id, 'loft');
      expect(options.types.single.type, isNull);
      expect(options.types.single.label, 'Loft');
    });

    test('rejects a missing bound even if that bound could be null', () {
      expect(
        () => PropertyFilterOptionsDto.fromJson({
          ...filterOptionsJson(),
          'bedrooms': {'max': null},
        }),
        throwsFormatException,
      );
    });
  });
}
