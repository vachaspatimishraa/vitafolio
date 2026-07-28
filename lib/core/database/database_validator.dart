import '../../data/models/resume/resume_model.dart';
import 'database_logger.dart';

class DatabaseValidator {
  /// Validates a resume's structure and contents.
  /// Returns a list of validation error messages.
  static List<String> validate(ResumeModel resume) {
    final errors = <String>[];

    if (resume.title.trim().isEmpty) {
      errors.add('Resume title cannot be empty.');
    }

    if (resume.personalInfo.fullName.trim().isEmpty) {
      errors.add('Personal Info: Full Name is required.');
    }

    if (resume.personalInfo.email.trim().isEmpty) {
      errors.add('Personal Info: Email is required.');
    }

    return errors;
  }

  /// Repairs basic correctable validation errors in a resume.
  static ResumeModel repair(ResumeModel resume) {
    var repaired = resume;

    if (repaired.title.trim().isEmpty) {
      DatabaseLogger.warning('Repairing empty title for resume ID: ${resume.id}');
      repaired = repaired.copyWith(title: 'Untitled Resume');
    }

    if (repaired.templateId.trim().isEmpty) {
      DatabaseLogger.warning('Repairing empty template ID for resume ID: ${resume.id}');
      repaired = repaired.copyWith(templateId: 'modern_clean');
    }

    return repaired;
  }
}
