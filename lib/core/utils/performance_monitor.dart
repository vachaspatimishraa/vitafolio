import '../database/database_logger.dart';

class PerformanceMonitor {
  /// Traces the execution time of a synchronous function.
  static T trace<T>(String operationName, T Function() fn) {
    final stopwatch = Stopwatch()..start();
    try {
      final result = fn();
      stopwatch.stop();
      DatabaseLogger.info('⏱️ $operationName completed in ${stopwatch.elapsedMilliseconds} ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      DatabaseLogger.warning('⏱️ $operationName failed after ${stopwatch.elapsedMilliseconds} ms');
      rethrow;
    }
  }

  /// Traces the execution time of an asynchronous function.
  static Future<T> traceAsync<T>(String operationName, Future<T> Function() fn) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await fn();
      stopwatch.stop();
      DatabaseLogger.info('⏱️ $operationName completed in ${stopwatch.elapsedMilliseconds} ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      DatabaseLogger.warning('⏱️ $operationName failed after ${stopwatch.elapsedMilliseconds} ms');
      rethrow;
    }
  }
}
