import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef AdapterResponse = FutureOr<ResponseBody> Function(
  RequestOptions request,
  Future<void>? cancellation,
);

final class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.respond);

  final AdapterResponse respond;
  final requests = <RequestOptions>[];
  final sentBodies = <List<int>>[];
  bool closed = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (requestStream != null) {
      sentBodies.add(await requestStream.expand((chunk) => chunk).toList());
    }
    return respond(options, cancelFuture);
  }

  @override
  void close({bool force = false}) => closed = true;
}
