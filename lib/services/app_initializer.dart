import '../data/datasource/isar_service.dart';

/// Service responsible for initializing the application before it starts.
///
/// Handles:
/// - Database initialization
/// - Configuration setup
/// - Error handling during startup
/// - Global state preparation
class AppInitializer {
  AppInitializer._();

  /// Whether the application has been initialized.
  static bool _initialized = false;

  /// Initializes the application.
  ///
  /// This method should be called before the app starts rendering.
  /// It ensures that all required resources (like the database) are ready.
  ///
  /// Throws [AppInitializationException] if initialization fails.
  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      // Initialize the Isar database
      await _initializeDatabase();

      _initialized = true;
    } catch (e, stackTrace) {
      _initialized = true; // Mark as attempted to prevent retry loops
      throw AppInitializationException(
        'Failed to initialize the application: $e',
        originalError: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }

  /// Initializes the Isar database.
  static Future<void> _initializeDatabase() async {
    try {
      await IsarService.instance.initialize();
    } catch (e) {
      // Re-throw with more context
      throw Exception('Failed to initialize database: $e');
    }
  }

  /// Closes all application resources gracefully.
  ///
  /// This method should be called when the application is shutting down.
  static Future<void> dispose() async {
    await IsarService.instance.close();
    _initialized = false;
  }

  /// Whether the application has been successfully initialized.
  static bool get isInitialized => _initialized;
}

/// Exception thrown when the application fails to initialize.
class AppInitializationException implements Exception {
  /// Creates an [AppInitializationException] with a descriptive message.
  const AppInitializationException(
    this.message, {
    this.originalError,
    this.stackTrace,
  });

  /// Human-readable error description.
  final String message;

  /// The original exception that caused this error, if any.
  final Exception? originalError;

  /// The stack trace from the original error, if available.
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