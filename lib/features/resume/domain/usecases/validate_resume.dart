import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/failures/resume_failure.dart';
import 'package:vitafolio/features/resume/domain/services/resume_validator.dart';

/// Use case for executing domain validation rules against a Resume entity.
class ValidateResume {
  final ResumeValidator validator;

  const ValidateResume(this.validator);

  List<ResumeFailure> call(Resume resume) {
    return validator.validate(resume);
  }

  bool isComplete(Resume resume) {
    return validator.isComplete(resume);
  }
}
