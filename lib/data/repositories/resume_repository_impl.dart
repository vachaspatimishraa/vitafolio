import 'package:isar/isar.dart';
import 'package:vitafolio/data/datasource/isar_data_source.dart';
import 'package:vitafolio/data/models/resume_model.dart';
import 'package:vitafolio/data/models/embedded/template_selection.dart';
import 'package:vitafolio/data/repositories/resume_repository.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final IsarDataSource? _dataSource;
  final Isar? _isar;

  ResumeRepositoryImpl(this._dataSource, this._isar);

  @override
  Future<ResumeModel> createResume(ResumeModel resume) async {
    resume.createdDate = DateTime.now();
    resume.lastUpdated = DateTime.now();

    final db = _isar;
    if (db == null) return resume;
    await db.writeTxn(() async {
      final generatedId = await db.resumeModels.put(resume);
      resume.id = generatedId;
    });

    return resume;
  }

  @override
  Future<ResumeModel?> getResume(int id) async {
    final db = _isar;
    if (db == null) return null;
    return await db.resumeModels.get(id);
  }

  @override
  Future<List<ResumeModel>> getAllResumes() async {
    final db = _isar;
    if (db == null) return [];
    return await db.resumeModels.where().findAll();
  }

  @override
  Future<void> updateResume(ResumeModel resume) async {
    final db = _isar;
    if (db == null) return;
    resume.lastUpdated = DateTime.now();
    await db.writeTxn(() async {
      await db.resumeModels.put(resume);
    });
  }

  @override
  Future<void> deleteResume(int id) async {
    final db = _isar;
    if (db == null) return;
    await db.writeTxn(() async {
      await db.resumeModels.delete(id);
    });
  }

  @override
  Future<ResumeModel> duplicateResume(int id, String defaultSuffix) async {
    final original = await getResume(id);
    if (original == null) {
      throw Exception('Original resume not found');
    }

    final duplicate = original.copyWith(
      id: Isar.autoIncrement,
      resumeName: '${original.resumeName} $defaultSuffix',
      createdDate: DateTime.now(),
      lastUpdated: DateTime.now(),
    );

    final db = _isar;
    if (db == null) return duplicate;
    await db.writeTxn(() async {
      final generatedId = await db.resumeModels.put(duplicate);
      duplicate.id = generatedId;
    });

    return duplicate;
  }

  @override
  Future<void> renameResume(int id, String newName) async {
    final existing = await getResume(id);
    if (existing == null) {
      throw Exception('Resume not found');
    }

    existing.resumeName = newName;
    existing.lastUpdated = DateTime.now();

    final db = _isar;
    if (db == null) return;
    await db.writeTxn(() async {
      await db.resumeModels.put(existing);
    });
  }

  @override
  Future<List<ResumeModel>> searchResumes(String query) async {
    final ds = _dataSource;
    if (ds == null) return [];
    return await ds.searchResumes(query);
  }

  @override
  Future<List<ResumeModel>> sortResumes(
    List<ResumeModel> resumes,
    String sortBy,
  ) async {
    final sorted = List<ResumeModel>.from(resumes);
    if (sortBy == 'name') {
      sorted.sort(
        (a, b) => (a.resumeName ?? '').toLowerCase().compareTo(
          (b.resumeName ?? '').toLowerCase(),
        ),
      );
    } else if (sortBy == 'lastUpdated') {
      sorted.sort(
        (a, b) => (b.lastUpdated ?? DateTime.now()).compareTo(
          a.lastUpdated ?? DateTime.now(),
        ),
      );
    }
    return sorted;
  }

  @override
  Future<Map<String, int>> getResumeStatistics() async {
    final all = await getAllResumes();
    return {
      'total': all.length,
    };
  }

  @override
  Future<bool> checkResumeExists(int id) async {
    final resume = await getResume(id);
    return resume != null;
  }

  @override
  Future<void> updateSelectedTemplate(int id, String templateId) async {
    final resume = await getResume(id);
    if (resume != null) {
      resume.selectedTemplate = TemplateSelection()..templateId = templateId;
      await updateResume(resume);
    }
  }
}
