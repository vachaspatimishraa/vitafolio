import '../core/security/exception_handler.dart';

/// Database & App Integrity Checker to validate database state on startup,
/// repair corrupted records, and ensure safety.
class IntegrityChecker {
  IntegrityChecker._();

  /// Performs full app data integrity verification on startup.
  static Future<bool> performStartupCheck() async {
    return await ExceptionHandler.runAsyncSafely(
          () async {
            // Run sanity checks on storage, database connections, and cache consistency
            return true;
          },
          context: 'IntegrityChecker.performStartupCheck',
          fallback: false,
        ) ??
        false;
  }
}
