import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppProfiler {
  AppProfiler._();

  static final Map<String, Stopwatch> _stopwatches = {};
  static final Map<String, int> _metrics = {};

  /// Starts timing a named section or operation.
  static void start(String name) {
    if (kDebugMode) {
      _stopwatches[name] = Stopwatch()..start();
    }
  }

  /// Stops timing a named section and logs the duration.
  static void stop(String name) {
    if (kDebugMode) {
      final stopwatch = _stopwatches[name];
      if (stopwatch != null) {
        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;
        _metrics[name] = duration;
        developer.log(
          '📊 Profiler [$name]: $duration ms',
          name: 'performance.profiler',
        );
        _stopwatches.remove(name);
      }
    }
  }

  /// Returns the duration of a timed operation, if recorded.
  static int? getMetric(String name) => _metrics[name];

  /// Logs current memory status indicators.
  static void logMemory() {
    if (kDebugMode) {
      developer.log(
        '💾 Profiled memory checkpoint.',
        name: 'performance.memory',
      );
    }
  }
}
