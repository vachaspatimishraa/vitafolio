import 'package:isar/isar.dart';
import 'package:vitafolio/features/resume/data/models/resume_model.dart';

abstract class ResumeLocalDataSource {
  Future<ResumeDbModel> createResume(ResumeDbModel resume);
  Future<ResumeDbModel> updateResume(ResumeDbModel resume);
  Future<void> deleteResume(int id);
  Future<ResumeDbModel?> getResume(int id);
  Future<List<ResumeDbModel>> getAllResumes();
  Future<void> saveSelectedTemplate(int resumeId, String templateId);
  Future<void> saveSelectedFont(int resumeId, String fontFamily);
  Future<ResumeDbModel> duplicateResume(int id, [String? nameSuffix]);
}

class ResumeLocalDataSourceImpl implements ResumeLocalDataSource {
  final Isar? isar;

  ResumeLocalDataSourceImpl(this.isar);

  @override
  Future<ResumeDbModel> createResume(ResumeDbModel resume) async {
    if (isar == null) return resume;
    await isar!.writeTxn(() async {
      resume.id = await isar!.collection<ResumeDbModel>().put(resume);
    });
    return resume;
  }

  @override
  Future<ResumeDbModel> updateResume(ResumeDbModel resume) async {
    if (isar == null) return resume;
    await isar!.writeTxn(() async {
      await isar!.collection<ResumeDbModel>().put(resume);
    });
    return resume;
  }

  @override
  Future<void> deleteResume(int id) async {
    if (isar == null) return;
    await isar!.writeTxn(() async {
      await isar!.collection<ResumeDbModel>().delete(id);
    });
  }

  @override
  Future<ResumeDbModel?> getResume(int id) async {
    if (isar == null) return null;
    return await isar!.collection<ResumeDbModel>().get(id);
  }

  @override
  Future<List<ResumeDbModel>> getAllResumes() async {
    if (isar == null) return [];
    return await isar!.collection<ResumeDbModel>().where().findAll();
  }

  @override
  Future<void> saveSelectedTemplate(int resumeId, String templateId) async {
    if (isar == null) return;
    final resume = await isar!.collection<ResumeDbModel>().get(resumeId);
    if (resume != null) {
      resume.selectedTemplateId = templateId;
      await updateResume(resume);
    }
  }

  @override
  Future<void> saveSelectedFont(int resumeId, String fontFamily) async {
    if (isar == null) return;
    final resume = await isar!.collection<ResumeDbModel>().get(resumeId);
    if (resume != null) {
      resume.fontFamily = fontFamily;
      await updateResume(resume);
    }
  }

  @override
  Future<ResumeDbModel> duplicateResume(int id, [String? nameSuffix]) async {
    final existing = await getResume(id);
    if (existing == null) {
      throw Exception('Resume not found for duplication');
    }

    final suffix = nameSuffix ?? ' (Copy)';
    final newModel = ResumeDbModel()
      ..title = '${existing.title}$suffix'
      ..selectedTemplateId = existing.selectedTemplateId
      ..personalDetails = existing.personalDetails
      ..summary = existing.summary
      ..experiences = existing.experiences
      ..educations = existing.educations
      ..skills = existing.skills
      ..certifications = existing.certifications
      ..languages = existing.languages
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    return await createResume(newModel);
  }
}


