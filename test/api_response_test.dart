import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/network/api_response.dart';

Matcher get malformed => isA<AppFailure>().having(
  (failure) => failure.kind,
  'kind',
  FailureKind.malformedResponse,
);

void main() {
  test('decodes a typed object', () {
    final result = ApiResponse.decode({
      'success': true,
      'data': {'name': 'fixture'},
    }, (value) => (value as Map)['name'] as String);
    expect(result.data, 'fixture');
    expect(result.pagination, isNull);
  });

  test('decodes an array together with pagination', () {
    final result = ApiResponse.decode({
      'success': true,
      'data': ['item'],
      'pagination': {
        'page': 2,
        'limit': 1,
        'total': 2,
        'totalPages': 2,
        'hasNextPage': false,
        'hasPreviousPage': true,
      },
    }, (value) => (value as List).cast<String>());
    expect(result.data, ['item']);
    final page = result.pagination!;
    expect((page.page, page.limit, page.total, page.totalPages), (2, 1, 2, 2));
    expect((page.hasNextPage, page.hasPreviousPage), (false, true));
  });

  test('distinguishes nullable data from an absent data member', () {
    expect(
      ApiResponse.decode<String?>({
        'success': true,
        'data': null,
      }, (value) => value as String?).data,
      isNull,
    );
    expect(
      () => ApiResponse.decode<String?>({
        'success': true,
      }, (value) => value as String?),
      throwsA(malformed),
    );
    expect(
      () => ApiResponse.decode<String>({
        'success': true,
        'data': null,
      }, (value) => value as String),
      throwsA(malformed),
    );
  });

  test('rejects invalid flags, payload types, and pagination', () {
    for (final body in [
      [],
      {'success': 'true', 'data': 'item'},
      {'success': true, 'data': []},
      {'success': true, 'data': 'item', 'pagination': null},
      {
        'success': true,
        'data': 'item',
        'pagination': {'page': -1},
      },
      {
        'success': false,
        'error': {'message': 'Missing code'},
      },
    ]) {
      expect(
        () => ApiResponse.decode<String>(body, (value) => value as String),
        throwsA(malformed),
      );
    }
  });

  test('retains a stable backend code and drops message and details', () {
    expect(
      () => ApiResponse.decode(
        {
          'success': false,
          'error': {
            'code': 'VALIDATION_ERROR',
            'message': 'private payload',
            'details': [
              {'field': 'example', 'message': 'private detail'},
            ],
          },
        },
        (value) => value,
        statusCode: 400,
      ),
      throwsA(
        isA<AppFailure>()
            .having((failure) => failure.kind, 'kind', FailureKind.validation)
            .having((failure) => failure.apiCode, 'code', 'VALIDATION_ERROR')
            .having((failure) => failure.statusCode, 'status', 400)
            .having(
              (failure) => failure.toString(),
              'diagnostic',
              isNot(contains('private')),
            ),
      ),
    );
  });

  test('lets programming errors outside payload decoding propagate intact', () {
    final bug = StateError('programming error');
    expect(
      () => ApiResponse.decode({
        'success': true,
        'data': 'item',
      }, (_) => throw bug),
      throwsA(same(bug)),
    );
  });
}
