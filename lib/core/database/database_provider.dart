import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/datasource/isar_service.dart';

/// Provider that gives access to the Isar database instance.
final isarProvider = Provider<Isar>((ref) {
  try {
    return IsarService.instance.isar;
  } catch (e) {
    throw StateError(
      'Isar database has not been initialized.',
    );
  }
});

/// Provider that gives access to the IsarService instance.
final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService.instance;
});
