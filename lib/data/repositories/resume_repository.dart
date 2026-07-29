import '../models/resume_model.dart';
import '../models/enums/resume_status.dart';

abstract interface class ResumeRepository {
  Future<ResumeModel> createResume(ResumeModel resume);
  Future<ResumeModel?> getResume(int id);
  Future<List<ResumeModel>> getAllResumes();
  Future<void> updateResume(ResumeModel resume);
  Future<void> deleteResume(int id);
  Future<ResumeModel> duplicateResume(int id, String defaultSuffix);
  Future<void> renameResume(int id, String newName);
  Future<List<ResumeModel>> searchResumes(String query);
  Future<List<ResumeModel>> filterResumes(ResumeStatus status);
  Future<List<ResumeModel>> sortResumes(
    List<ResumeModel> resumes,
    String sortBy,
  );
  Future<Map<String, int>> getResumeStatistics();
  Future<bool> checkResumeExists(int id);
  Future<void> updateSelectedTemplate(int id, String templateId);
}
