import 'dart:async';

import 'package:vitafolio/core/database/isar_service.dart';
import 'package:vitafolio/core/security/exception_handler.dart';
import 'package:vitafolio/core/security/release_checker.dart';
import 'package:vitafolio/services/integrity_checker.dart';

/// Service responsible for initializing the application before it starts.
class AppInitializer {
  AppInitializer._();

  static bool _initialized = false;

  /// Initializes the application and performs release & integrity audits.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 1. Critical Database Initialization
      await _initializeDatabase();
      _initialized = true;

      // 2. Non-blocking Background Audits & Security Checks
      ReleaseChecker.verifyReleaseSecurity();
      unawaited(ReleaseChecker.verifyRequiredAssets());
      unawaited(IntegrityChecker.performStartupCheck());
    } catch (e, stackTrace) {
      _initialized = true;
      ExceptionHandler.logError(
        e,
        stackTrace: stackTrace,
        context: 'AppInitializer.initialize',
      );
    }
  }

  /// Initializes the Isar database.
  static Future<void> _initializeDatabase() async {
    try {
      await IsarService.instance.initialize();
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  /// Closes all application resources gracefully.
  static Future<void> dispose() async {
    await IsarService.instance.close();
    _initialized = false;
  }

  static bool get isInitialized => _initialized;
}

class AppInitializationException implements Exception {
  const AppInitializationException(
    this.message, {
    this.originalError,
    this.stackTrace,
  });

  final String message;
  final Exception? originalError;
  final StackTrace? stackTrace;

  @override
  String toString() {
    final buffer = StringBuffer('AppInitializationException: $message');
    if (originalError != null) {
      buffer.write('\nOriginal error: $originalError');
    }
    return buffer.toString();
  }
}
