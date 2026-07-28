import 'dart:async';

class AutoSaveService {
  final Future<void> Function() onSave;
  final Duration delay;
  Timer? _timer;

  AutoSaveService({
    required this.onSave,
    this.delay = const Duration(milliseconds: 800),
  });

  void trigger() {
    _timer?.cancel();
    _timer = Timer(delay, () async {
      await onSave();
    });
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}
