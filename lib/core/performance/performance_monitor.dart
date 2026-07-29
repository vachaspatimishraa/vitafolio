import 'package:flutter/foundation.dart';
import '../database/database_logger.dart';

class PerformanceMonitor {
  PerformanceMonitor._();

  /// Traces the execution time of a synchronous function.
  static T trace<T>(String operationName, T Function() fn) {
    final stopwatch = Stopwatch()..start();
    try {
      final result = fn();
      stopwatch.stop();
      _logSuccess(operationName, stopwatch.elapsedMilliseconds);
      return result;
    } catch (e) {
      stopwatch.stop();
      _logFailure(operationName, stopwatch.elapsedMilliseconds, e);
      rethrow;
    }
  }

  /// Traces the execution time of an asynchronous function.
  static Future<T> traceAsync<T>(
    String operationName,
    Future<T> Function() fn,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await fn();
      stopwatch.stop();
      _logSuccess(operationName, stopwatch.elapsedMilliseconds);
      return result;
    } catch (e) {
      stopwatch.stop();
      _logFailure(operationName, stopwatch.elapsedMilliseconds, e);
      rethrow;
    }
  }

  static void _logSuccess(String operationName, int ms) {
    final message = '⏱️ $operationName completed in $ms ms';
    if (kDebugMode) {
      debugPrint(message);
    }
    try {
      DatabaseLogger.info(message);
    } catch (_) {}
  }

  static void _logFailure(String operationName, int ms, Object error) {
    final message = '⏱️ $operationName failed after $ms ms with error: $error';
    if (kDebugMode) {
      debugPrint(message);
    }
    try {
      DatabaseLogger.warning(message);
    } catch (_) {}
  }
}
