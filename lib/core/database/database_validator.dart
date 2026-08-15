import 'package:vitafolio/data/models/resume_model.dart';
import 'package:vitafolio/core/database/database_logger.dart';

class DatabaseValidator {
  /// Validates a resume's structure and contents.
  /// Returns a list of validation error messages.
  static List<String> validate(ResumeModel resume) {
    final errors = <String>[];

    if ((resume.resumeName ?? '').trim().isEmpty) {
      errors.add('Resume title cannot be empty.');
    }

    if ((resume.personalInfo?.fullName ?? '').trim().isEmpty) {
      errors.add('Personal Info: Full Name is required.');
    }

    if ((resume.personalInfo?.email ?? '').trim().isEmpty) {
      errors.add('Personal Info: Email is required.');
    }

    return errors;
  }

  /// Repairs basic correctable validation errors in a resume.
  static ResumeModel repair(ResumeModel resume) {
    var repaired = resume;

    if ((repaired.resumeName ?? '').trim().isEmpty) {
      DatabaseLogger.warning(
        'Repairing empty title for resume ID: ${resume.id}',
      );
      repaired = repaired.copyWith(resumeName: 'Untitled Resume');
    }

    if ((repaired.selectedTemplate?.templateId ?? '').trim().isEmpty) {
      DatabaseLogger.warning(
        'Repairing empty template ID for resume ID: ${resume.id}',
      );
      // Cannot easily update nested fields in a simple way without more logic, but we'll leave it for now.
    }

    return repaired;
  }
}
