import '../models/resume/resume_model.dart';
import '../models/enums/resume_status.dart';

abstract class ResumeRepository {
  Future<ResumeModel> createResume(ResumeModel resume);
  Future<ResumeModel?> getResume(String id);
  Future<List<ResumeModel>> getAllResumes();
  Future<void> updateResume(ResumeModel resume);
  Future<void> deleteResume(String id);
  Future<ResumeModel> duplicateResume(String id, String defaultSuffix);
  Future<void> renameResume(String id, String newName);
  Future<List<ResumeModel>> searchResumes(String query);
  Future<List<ResumeModel>> filterResumes(ResumeStatus status);
  Future<List<ResumeModel>> sortResumes(List<ResumeModel> resumes, String sortBy);
  Future<Map<String, int>> getResumeStatistics();
  Future<bool> checkResumeExists(String id);
  Future<void> updateSelectedTemplate(String resumeId, String templateId);
}
