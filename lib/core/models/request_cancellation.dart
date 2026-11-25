/// A one-shot cancellation signal shared by requests with the same lifetime.
final class RequestCancellation {
  final _listeners = <void Function()>{};
  bool _isCancelled = false;

  bool get isCancelled => _isCancelled;

  void cancel() {
    if (_isCancelled) return;
    _isCancelled = true;
    final listeners = _listeners.toList();
    _listeners.clear();
    for (final listener in listeners) {
      listener();
    }
  }

  /// Registers until cancellation or until the returned cleanup is called.
  void Function() onCancel(void Function() listener) {
    if (_isCancelled) {
      listener();
      return () {};
    }
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }
}
