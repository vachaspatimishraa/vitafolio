import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../core/database/database_logger.dart';
import '../models/resume_model.dart';
import '../models/embedded/personal_information.dart';

class IsarService {
  Isar? _isar;
  bool _initialized = false;

  IsarService._internal();

  static final IsarService instance = IsarService._internal();

  // Unnamed constructor for testing
  IsarService(this._isar) {
    _initialized = true;
  }

  bool get isInitialized => _initialized && _isar != null;

  Isar get isar => _isar!;

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

      _isar = await Isar.open(
        [ResumeModelSchema],
        directory: databaseDir,
      );
      _initialized = true;
      DatabaseLogger.info('Isar database initialized successfully.');
    } catch (e, stackTrace) {
      DatabaseLogger.error('Failed to initialize Isar database. Attempting recovery...', err: e, st: stackTrace);
      
      // Recovery attempt: Delete database files and try again
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final databaseDir = Directory(p.join(appDir.path, 'databases'));
        if (await databaseDir.exists()) {
          await databaseDir.delete(recursive: true);
        }
        await databaseDir.create(recursive: true);

        _isar = await Isar.open(
          [ResumeModelSchema],
          directory: databaseDir.path,
        );
        _initialized = true;
        DatabaseLogger.info('Isar database recovered and initialized successfully.');
      } catch (recoveryError, recoveryStack) {
        DatabaseLogger.error('Isar database recovery failed', err: recoveryError, st: recoveryStack);
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
    final db = isar;
    await db.writeTxn(() async {
      final id = await db.resumeModels.put(resume);
      DatabaseLogger.info('Saved resume with ID $id into Isar');
    });
  }

  Future<ResumeModel?> getResume(int id) async {
    return isar.resumeModels.get(id);
  }

  Future<List<ResumeModel>> getAllResumes() async {
    return isar.resumeModels.where().sortByLastUpdatedDesc().findAll();
  }

  Future<void> deleteResume(int id) async {
    final db = isar;
    await db.writeTxn(() async {
      final deleted = await db.resumeModels.delete(id);
      DatabaseLogger.info('Deleted resume ID $id: $deleted');
    });
  }

  Future<List<ResumeModel>> searchResumes(String query) async {
    if (query.isEmpty) {
      return getAllResumes();
    }
    final lowerQuery = query.toLowerCase();
    
    return isar.resumeModels
        .filter()
        .resumeNameContains(lowerQuery, caseSensitive: false)
        .sortByLastUpdatedDesc()
        .findAll();
  }
}

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit;
    hash *= 0x100000001b3;
  }
  return hash.toSigned(64);
}