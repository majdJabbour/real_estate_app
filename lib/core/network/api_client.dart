import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../errors/app_failure.dart';
import '../localization/app_locale.dart';
import 'api_response.dart';

part 'api_client.g.dart';

enum ApiAccess { public, protected }

typedef ApiTokenSource = Future<String?> Function();

@Riverpod(keepAlive: true)
ApiTokenSource apiTokenSource(Ref ref) =>
    () async => null;

@Riverpod(keepAlive: true)
Future<String?> Function(String) accountApiTokenSource(Ref ref) =>
    (_) => ref.read(apiTokenSourceProvider)();

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final base = ref.watch(appConfigProvider).apiBaseUrl;
  final client = Dio(
    BaseOptions(
      baseUrl: base.toString(),
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );
  var localeRevision = 0;
  ref.listen(appLocaleProvider, (previous, next) => localeRevision++);

  bool isStale(RequestOptions request) {
    final sentAt = request.extra[_localeRevisionKey];
    return sentAt is int && sentAt != localeRevision;
  }

  client.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) async {
        if (!ref.mounted) {
          handler.reject(_cancelled(request));
          return;
        }
        request.headers.removeWhere(
          (name, _) => name.toLowerCase() == 'authorization',
        );
        if (request.extra[_accessKey] == ApiAccess.protected) {
          try {
            final uri = request.uri;
            if (uri.scheme != base.scheme ||
                uri.authority != base.authority ||
                !uri.path.startsWith(base.path)) {
              handler.reject(_requestFailure(request, FailureKind.forbidden));
              return;
            }
            request.followRedirects = false;
            final accountId = request.extra[_accountKey] as String?;
            final token = accountId == null
                ? await ref.read(apiTokenSourceProvider)()
                : await ref.read(accountApiTokenSourceProvider)(accountId);
            if (!ref.mounted || (request.cancelToken?.isCancelled ?? false)) {
              handler.reject(_cancelled(request));
              return;
            }
            if (token == null || !_bearerToken.hasMatch(token)) {
              handler.reject(
                _requestFailure(request, FailureKind.unauthorized),
              );
              return;
            }
            request.headers['Authorization'] = 'Bearer $token';
          } on AppFailure catch (failure) {
            handler.reject(
              DioException(requestOptions: request, error: failure),
            );
            return;
          } catch (error, stack) {
            handler.reject(
              DioException(
                requestOptions: request,
                error: AppFailure(
                  FailureKind.unexpected,
                  diagnosticType: error.runtimeType,
                ),
                stackTrace: stack,
              ),
            );
            return;
          }
        }
        request.headers['Accept-Language'] = ref.read(appLocaleProvider).code;
        if (request.extra[_localeSensitiveKey] != false) {
          request.extra[_localeRevisionKey] = localeRevision;
        }
        handler.next(request);
      },
      onResponse: (response, handler) {
        if (isStale(response.requestOptions)) {
          handler.reject(_cancelled(response.requestOptions));
        } else {
          handler.next(response);
        }
      },
      onError: (error, handler) {
        handler.next(
          isStale(error.requestOptions)
              ? _cancelled(error.requestOptions)
              : error,
        );
      },
    ),
  );
  ref.onDispose(() => client.close(force: true));
  return client;
}

const _accessKey = 'app.apiAccess';
const _accountKey = 'app.accountId';
const _localeSensitiveKey = 'app.localeSensitive';
const _localeRevisionKey = 'app.localeRevision';
final _bearerToken = RegExp(r'^[A-Za-z0-9._~+/=-]+$');

DioException _requestFailure(RequestOptions request, FailureKind kind) =>
    DioException(requestOptions: request, error: AppFailure(kind));

DioException _cancelled(RequestOptions request) =>
    DioException(requestOptions: request, type: DioExceptionType.cancel);

Future<ApiResponse<T>> requestApi<T>(
  Dio client,
  String endpoint, {
  required T Function(Object?) decodeData,
  required ApiAccess access,
  String? accountId,
  bool localeSensitive = true,
  String method = 'GET',
  Map<String, Object?>? queryParameters,
  Object? data,
  CancelToken? cancelToken,
}) async {
  try {
    final response = await client.request<Object?>(
      endpoint,
      queryParameters: queryParameters,
      data: data,
      cancelToken: cancelToken,
      options: Options(
        method: method,
        extra: {
          _accessKey: access,
          _accountKey: accountId,
          _localeSensitiveKey: localeSensitive,
        },
      ),
    );
    return ApiResponse.decode(
      response.data,
      decodeData,
      statusCode: response.statusCode,
    );
  } on DioException catch (error) {
    Error.throwWithStackTrace(mapDioFailure(error), error.stackTrace);
  }
}

AppFailure mapDioFailure(DioException error) {
  if (error.error case final AppFailure failure) return failure;
  if (error.type == DioExceptionType.badResponse) {
    return apiFailure(
      statusCode: error.response?.statusCode,
      code: apiErrorCode(error.response?.data),
    );
  }
  final kind = switch (error.type) {
    DioExceptionType.cancel => FailureKind.cancelled,
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => FailureKind.timeout,
    DioExceptionType.connectionError ||
    DioExceptionType.badCertificate => FailureKind.connection,
    _ when error.error is FormatException => FailureKind.malformedResponse,
    _ => FailureKind.unexpected,
  };
  return AppFailure(
    kind,
    statusCode: error.response?.statusCode,
    diagnosticType: error.error?.runtimeType,
  );
}
