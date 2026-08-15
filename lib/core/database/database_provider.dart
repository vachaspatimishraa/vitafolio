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
final isarProvider = Provider<Isar?>((ref) {
  return IsarService.instance.isInitialized ? IsarService.instance.isar : null;
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
final isarDataSourceProvider = Provider<IsarDataSource?>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) return null;
  return IsarDataSource(isar);
});
