import 'package:isar/isar.dart';
import '../datasource/isar_data_source.dart';
import '../models/resume_model.dart';
import '../models/enums/resume_status.dart';
import 'resume_repository.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final IsarDataSource _dataSource;
  final Isar _isar;

  ResumeRepositoryImpl(this._dataSource, this._isar);

  @override
  Future<ResumeModel> createResume(ResumeModel resume) async {
    resume.createdDate = DateTime.now();
    resume.lastUpdated = DateTime.now();

    await _isar.writeTxn(() async {
      final generatedId = await _isar.resumeModels.put(resume);
      resume.id = generatedId;
    });

    return resume;
  }

  @override
  Future<ResumeModel?> getResume(int id) async {
    return await _isar.resumeModels.get(id);
  }

  @override
  Future<List<ResumeModel>> getAllResumes() async {
    return await _isar.resumeModels.where().findAll();
  }

  @override
  Future<void> updateResume(ResumeModel resume) async {
    resume.lastUpdated = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.resumeModels.put(resume);
    });
  }

  @override
  Future<void> deleteResume(int id) async {
    await _isar.writeTxn(() async {
      await _isar.resumeModels.delete(id);
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
      status: ResumeStatus.draft,
    );

    await _isar.writeTxn(() async {
      final generatedId = await _isar.resumeModels.put(duplicate);
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

    await _isar.writeTxn(() async {
      await _isar.resumeModels.put(existing);
    });
  }

  @override
  Future<List<ResumeModel>> searchResumes(String query) async {
    return await _dataSource.searchResumes(query);
  }

  @override
  Future<List<ResumeModel>> filterResumes(ResumeStatus status) async {
    return await _isar.resumeModels.filter().statusEqualTo(status).findAll();
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
    int draftCount = 0;
    int completedCount = 0;
    for (final r in all) {
      if (r.status == ResumeStatus.draft) {
        draftCount++;
      } else if (r.status == ResumeStatus.completed) {
        completedCount++;
      }
    }
    return {
      'total': all.length,
      'draft': draftCount,
      'completed': completedCount,
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
      // Need a way to set templateId on the embedded object
      // For now, assume we just update the whole resume
      await updateResume(resume);
    }
  }
}
