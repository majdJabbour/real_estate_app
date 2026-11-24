enum FailureKind {
  connection,
  timeout,
  validation,
  unauthorized,
  forbidden,
  notFound,
  rateLimited,
  server,
  serviceUnavailable,
  malformedResponse,
  cancelled,
  unexpected,
}

final class AppFailure implements Exception {
  const AppFailure(
    this.kind, {
    this.statusCode,
    this.apiCode,
    this.diagnosticType,
  });

  final FailureKind kind;
  final int? statusCode;
  final String? apiCode;

  /// The exception type is safe to inspect without retaining HTTP payloads.
  final Type? diagnosticType;

  @override
  String toString() => 'AppFailure(${kind.name}, status: $statusCode)';
}
