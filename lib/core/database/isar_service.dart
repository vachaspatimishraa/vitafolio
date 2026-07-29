import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../security/exception_handler.dart';
import '../../data/models/resume_model.dart';
import 'database_logger.dart';

/// Singleton database service for managing the Isar database lifecycle.
///
/// Responsibilities:
/// - Initialize and open the Isar database
/// - Close the database gracefully
/// - Prevent multiple Isar instances
/// - Handle initialization errors
/// - Provide the database instance
///
/// Usage:
/// ```dart
/// await IsarService.instance.initialize();
/// final db = IsarService.instance.isar;
/// ```
class IsarService {
  Isar? _isar;
  bool _initialized = false;

  IsarService._internal();

  static final IsarService instance = IsarService._internal();

  bool get isInitialized => _initialized && _isar != null;

  Isar get isar {
    final currentDb = _isar;
    if (currentDb == null) {
      throw StateError(
        'Isar database has not been initialized. Call initialize() first.',
      );
    }
    return currentDb;
  }

  @visibleForTesting
  set isar(Isar value) {
    _isar = value;
    _initialized = true;
  }

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final databaseDir = p.join(appDir.path, 'databases');

      // Ensure the database directory exists
      final dir = Directory(databaseDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      _isar = await Isar.open([ResumeModelSchema], directory: databaseDir);
      _initialized = true;
      DatabaseLogger.info('Isar database initialized successfully.');
    } catch (e, stackTrace) {
      DatabaseLogger.error(
        'Failed to initialize Isar database. Attempting recovery...',
        err: e,
        st: stackTrace,
      );

      // Recovery attempt: Delete database files and try again
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final databaseDir = Directory(p.join(appDir.path, 'databases'));
        if (await databaseDir.exists()) {
          await databaseDir.delete(recursive: true);
        }
        await databaseDir.create(recursive: true);

        _isar = await Isar.open([
          ResumeModelSchema,
        ], directory: databaseDir.path);
        _initialized = true;
        DatabaseLogger.info(
          'Isar database recovered and initialized successfully.',
        );
      } catch (recoveryError, recoveryStack) {
        DatabaseLogger.error(
          'Isar database recovery failed',
          err: recoveryError,
          st: recoveryStack,
        );
        rethrow;
      }
    }
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
    _initialized = false;
  }

  // --- CRUD Queries ---

  Future<void> saveResume(ResumeModel resume) async {
    await ExceptionHandler.runAsyncSafely(() async {
      final db = isar;
      await db.writeTxn(() async {
        final id = await db.resumeModels.put(resume);
        DatabaseLogger.info('Saved resume with ID $id into Isar');
      });
    }, context: 'IsarService.saveResume');
  }

  Future<ResumeModel?> getResume(int id) async {
    return await ExceptionHandler.runAsyncSafely<ResumeModel?>(() async {
      return isar.resumeModels.get(id);
    }, context: 'IsarService.getResume');
  }

  Future<List<ResumeModel>> getAllResumes() async {
    return await ExceptionHandler.runAsyncSafely(
          () async {
            return isar.resumeModels.where().sortByLastUpdatedDesc().findAll();
          },
          context: 'IsarService.getAllResumes',
          fallback: <ResumeModel>[],
        ) ??
        <ResumeModel>[];
  }

  Future<void> deleteResume(int id) async {
    await ExceptionHandler.runAsyncSafely(() async {
      final db = isar;
      await db.writeTxn(() async {
        final deleted = await db.resumeModels.delete(id);
        DatabaseLogger.info('Deleted resume ID $id: $deleted');
      });
    }, context: 'IsarService.deleteResume');
  }

  Future<List<ResumeModel>> searchResumes(String query) async {
    return await ExceptionHandler.runAsyncSafely(
          () async {
            if (query.isEmpty) {
              return getAllResumes();
            }
            final lowerQuery = query.toLowerCase();

            return isar.resumeModels
                .filter()
                .resumeNameContains(lowerQuery, caseSensitive: false)
                .sortByLastUpdatedDesc()
                .findAll();
          },
          context: 'IsarService.searchResumes',
          fallback: <ResumeModel>[],
        ) ??
        <ResumeModel>[];
  }
}
