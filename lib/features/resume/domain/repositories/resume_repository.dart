import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

/// Pure Dart Abstract Repository Contract for Resume management.
/// No infrastructure implementation details, Riverpod, Isar, or Dio dependencies.
abstract class ResumeRepository {
  /// Creates a new resume record.
  Future<Resume> createResume(Resume resume);

  /// Updates an existing resume record.
  Future<Resume> updateResume(Resume resume);

  /// Deletes a resume record by its unique ID.
  Future<void> deleteResume(ResumeId id);

  /// Fetches a single resume record by ID.
  Future<Resume?> getResume(ResumeId id);

  /// Retrieves all existing resume records.
  Future<List<Resume>> getAllResumes();

  /// Imports an existing resume file from bytes/file path.
  Future<Resume> importResume(String filePath);

  /// Parses raw text or file input into structured Resume entity fields.
  Future<Resume> parseResume(String rawText);

  /// Persists selected template assignment for a target resume.
  Future<Resume> saveSelectedTemplate(ResumeId resumeId, TemplateId templateId);

  /// Persists selected font assignment for a target resume.
  Future<Resume> saveSelectedFont(ResumeId resumeId, String fontFamily);

  /// Renders/Generates raw PDF document bytes for a given resume entity.
  Future<List<int>> generateResume(ResumeId resumeId);

  /// Duplicates an existing resume record with a new ID.
  Future<Resume> duplicateResume(ResumeId id, [String? nameSuffix]);
}
