import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:vitafolio/core/database/isar_service.dart';
import 'package:vitafolio/data/datasource/isar_data_source.dart';

/// Provider that gives access to the Isar database instance.
///
/// **Usage:**
/// ```dart
/// final isar = ref.watch(isarProvider);
/// ```
///
/// **Important:** This provider assumes the database has been initialized.
/// Use [AppInitializer] to initialize the database before accessing this provider.
final isarProvider = Provider<Isar>((ref) {
  try {
    return IsarService.instance.isar;
  } catch (e) {
    // If the database hasn't been initialized, throw a descriptive error
    throw StateError(
      'Isar database has not been initialized. '
      'Ensure AppInitializer.initialize() is called before accessing this provider.',
    );
  }
});

/// Provider that gives access to the IsarService instance.
///
/// **Usage:**
/// ```dart
/// final isarService = ref.watch(isarServiceProvider);
/// ```
final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService.instance;
});

/// Provider that gives access to the IsarDataSource.
///
/// **Usage:**
/// ```dart
/// final dataSource = ref.watch(isarDataSourceProvider);
/// ```
final isarDataSourceProvider = Provider<IsarDataSource>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarDataSource(isar);
});
