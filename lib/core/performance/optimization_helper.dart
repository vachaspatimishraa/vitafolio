import 'dart:async';

/// A utility to debounce executions of functions.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    cancel();
  }
}

/// A utility to throttle executions of functions.
class Throttler {
  final Duration delay;
  bool _isActive = true;
  Timer? _timer;

  Throttler({required this.delay});

  void run(void Function() action) {
    if (_isActive) {
      _isActive = false;
      action();
      _timer = Timer(delay, () {
        _isActive = true;
      });
    }
  }

  void cancel() {
    _timer?.cancel();
    _isActive = true;
  }

  void dispose() {
    _timer?.cancel();
  }
}
