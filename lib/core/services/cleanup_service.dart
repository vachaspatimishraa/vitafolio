import '../../data/repositories/resume_repository.dart';
import '../database/database_validator.dart';
import '../database/database_logger.dart';

class CleanupService {
  final ResumeRepository _repository;

  CleanupService(this._repository);

  /// Iterates through all resumes, validates them, and removes/repairs invalid ones.
  Future<void> performCleanup() async {
    try {
      DatabaseLogger.info('Starting database cleanup routine...');
      final resumes = await _repository.getAllResumes();
      
      for (final resume in resumes) {
        // Run validations
        final errors = DatabaseValidator.validate(resume);
        if (errors.isNotEmpty) {
          DatabaseLogger.warning('Validation warnings for resume ${resume.id}: ${errors.join(", ")}');
          
          // Attempt to repair
          final repaired = DatabaseValidator.repair(resume);
          await _repository.updateResume(repaired);
          DatabaseLogger.info('Repaired and updated resume ${resume.id}');
        }
      }
      DatabaseLogger.info('Database cleanup completed successfully.');
    } catch (e, stackTrace) {
      DatabaseLogger.error('Failed to execute database cleanup', err: e, st: stackTrace);
    }
  }
}
