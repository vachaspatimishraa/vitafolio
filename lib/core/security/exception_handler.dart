import 'package:flutter/foundation.dart';

/// Centralized Exception Handler for Vitafolio.
/// Log messages in debug mode and format safe, user-facing error messages for release mode.
class ExceptionHandler {
  ExceptionHandler._();

  /// Logs exceptions securely. Stack traces and detailed internal messages are suppressed in production.
  static void logError(
    Object error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    if (kDebugMode) {
      final tag = context != null ? '[$context]' : '[ERROR]';
      debugPrint('$tag: $error');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }

  /// Maps technical exceptions to safe, user-friendly UI strings.
  static String getUserFriendlyMessage(Object error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('storage') || errorString.contains('permission')) {
      return 'Storage permission denied or storage location unavailable.';
    } else if (errorString.contains('isar') ||
        errorString.contains('database')) {
      return 'A database error occurred. Your data is safe; please try again.';
    } else if (errorString.contains('format') ||
        errorString.contains('corrupt')) {
      return 'Invalid or corrupted data detected. Please review your entries.';
    } else if (errorString.contains('pdf') || errorString.contains('print')) {
      return 'Unable to generate PDF resume. Please try again.';
    } else if (errorString.contains('file') ||
        errorString.contains('not found')) {
      return 'The requested file could not be found.';
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Safely runs a sync operation with defensive exception handling.
  static T? runSafely<T>(
    T Function() operation, {
    String? context,
    T? fallback,
  }) {
    try {
      return operation();
    } catch (e, st) {
      logError(e, stackTrace: st, context: context);
      return fallback;
    }
  }

  /// Safely runs an async operation with defensive exception handling.
  static Future<T?> runAsyncSafely<T>(
    Future<T> Function() operation, {
    String? context,
    T? fallback,
  }) async {
    try {
      return await operation();
    } catch (e, st) {
      logError(e, stackTrace: st, context: context);
      return fallback;
    }
  }
}
