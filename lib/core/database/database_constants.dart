import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:vitafolio/features/resume/data/models/resume_model.dart';

/// Centralized database configuration constants.
///
/// All database-related constants are defined here to keep configuration
/// in one place and support future schema migrations without refactoring.
abstract final class DatabaseConstants {
  /// The name of the Isar database instance.
  static const String databaseName = 'vitafolio';

  /// Whether Isar Inspector should be enabled.
  ///
  /// Enabled only in debug mode. Never enabled in release builds.
  static bool get enableInspector => kDebugMode;

  /// Current database schema version.
  ///
  /// Increment this when making breaking schema changes to trigger migrations.
  static const int schemaVersion = 1;

  /// List of all collection schemas to be registered with Isar.
  ///
  /// Add new collections here as they are implemented.
  /// This list is consumed by [IsarService] during initialization.
  static List<CollectionSchema<dynamic>> get collections => [
    ResumeDbModelSchema,
  ];
}
