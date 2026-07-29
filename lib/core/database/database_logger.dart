import 'package:flutter/foundation.dart';

class DatabaseLogger {
  static void log(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kReleaseMode) return;

    final prefix = tag != null ? '[$tag]' : '[Database]';
    final logMessage = '$prefix $message';

    if (error != null) {
      debugPrint('$logMessage | Error: $error');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    } else {
      debugPrint(logMessage);
    }
  }

  static void info(String message, {String? tag}) =>
      log(message, tag: tag ?? 'INFO');
  static void warning(String message, {String? tag}) =>
      log('⚠️ $message', tag: tag ?? 'WARN');
  static void error(
    String message, {
    String? tag,
    Object? err,
    StackTrace? st,
  }) => log('❌ $message', tag: tag ?? 'ERROR', error: err, stackTrace: st);
}
