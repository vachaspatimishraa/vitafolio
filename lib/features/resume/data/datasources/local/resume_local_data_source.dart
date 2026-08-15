import 'package:vitafolio/features/resume/data/dto/resume_dto.dart';

/// Abstract contract for local persistent data storage.
abstract class ResumeLocalDataSource {
  /// Saves a new resume DTO record.
  Future<void> saveResume(ResumeDto resumeDto);

  /// Updates an existing resume DTO record.
  Future<void> updateResume(ResumeDto resumeDto);

  /// Deletes a resume DTO record by ID.
  Future<void> deleteResume(String id);

  /// Fetches a single resume DTO record by ID.
  Future<ResumeDto?> getResume(String id);

  /// Retrieves all resume DTO records.
  Future<List<ResumeDto>> getAllResumes();
}
