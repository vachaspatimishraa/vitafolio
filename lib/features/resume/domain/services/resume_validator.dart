import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/failures/resume_failure.dart';

/// Abstract Domain Service Contract defining domain validation behavior.
/// Validates required fields, empty sections, format constraints, and template assignment.
abstract class ResumeValidator {
  /// Checks whether a resume entity contains all required information.
  bool isComplete(Resume resume);

  /// Validates a resume entity and returns a list of domain validation failures (if any).
  List<ResumeFailure> validate(Resume resume);
}
