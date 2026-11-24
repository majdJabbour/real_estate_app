import '../errors/app_failure.dart';

final class ApiResponse<T> {
  const ApiResponse({required this.data, this.pagination});

  final T data;
  final ApiPagination? pagination;

  static ApiResponse<T> decode<T>(
    Object? body,
    T Function(Object?) decodeData, {
    int? statusCode,
  }) {
    final errorCode = apiErrorCode(body);
    if (errorCode != null) {
      throw apiFailure(statusCode: statusCode, code: errorCode);
    }
    if (body case {'success': true, 'data': final Object? data}
        when data != null || null is T) {
      try {
        final pagination = body.containsKey('pagination')
            ? ApiPagination.decode(body['pagination'])
            : null;
        return ApiResponse(data: decodeData(data), pagination: pagination);
      } catch (error, stack) {
        if (error is! FormatException && error is! TypeError) rethrow;
        Error.throwWithStackTrace(
          AppFailure(
            FailureKind.malformedResponse,
            statusCode: statusCode,
            diagnosticType: error.runtimeType,
          ),
          stack,
        );
      }
    }
    throw AppFailure(FailureKind.malformedResponse, statusCode: statusCode);
  }
}

final class ApiPagination {
  const ApiPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  static ApiPagination decode(Object? value) => switch (value) {
    {
      'page': final int page,
      'limit': final int limit,
      'total': final int total,
      'totalPages': final int totalPages,
      'hasNextPage': final bool hasNextPage,
      'hasPreviousPage': final bool hasPreviousPage,
    }
        when page > 0 && limit > 0 && total >= 0 && totalPages >= 0 =>
      ApiPagination(
        page: page,
        limit: limit,
        total: total,
        totalPages: totalPages,
        hasNextPage: hasNextPage,
        hasPreviousPage: hasPreviousPage,
      ),
    _ => throw const FormatException('Invalid API pagination.'),
  };
}

final _stableCode = RegExp(r'^[A-Z][A-Z0-9_]{0,63}$');

String? apiErrorCode(Object? body) => switch (body) {
  {'success': false, 'error': {'code': final String code, 'message': String()}}
      when _stableCode.hasMatch(code) =>
    code,
  _ => null,
};

AppFailure apiFailure({int? statusCode, String? code}) {
  final kind = switch (statusCode) {
    400 || 422 => FailureKind.validation,
    401 => FailureKind.unauthorized,
    403 => FailureKind.forbidden,
    404 => FailureKind.notFound,
    429 => FailureKind.rateLimited,
    503 => FailureKind.serviceUnavailable,
    final int code when code >= 500 && code < 600 => FailureKind.server,
    _ => switch (code) {
      'VALIDATION_ERROR' => FailureKind.validation,
      'UNAUTHORIZED' => FailureKind.unauthorized,
      'FORBIDDEN' => FailureKind.forbidden,
      'PROPERTY_NOT_FOUND' => FailureKind.notFound,
      'RATE_LIMIT_EXCEEDED' => FailureKind.rateLimited,
      'SERVICE_UNAVAILABLE' => FailureKind.serviceUnavailable,
      'INTERNAL_SERVER_ERROR' => FailureKind.server,
      _ => FailureKind.unexpected,
    },
  };
  return AppFailure(kind, statusCode: statusCode, apiCode: code);
}
