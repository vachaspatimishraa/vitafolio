import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/failures/resume_failure.dart';
import 'package:vitafolio/features/resume/domain/services/resume_validator.dart';

/// Pure Domain Implementation of [ResumeValidator].
/// Evaluates mandatory validation rules according to product policy:
/// ONLY Full Name and Phone Number are required.
/// All other fields (email, summary, experiences, projects, educations, skills, certifications, languages) are optional.
class ResumeValidatorImpl implements ResumeValidator {
  const ResumeValidatorImpl();

  @override
  bool isComplete(Resume resume) {
    return validate(resume).isEmpty;
  }

  @override
  List<ResumeFailure> validate(Resume resume) {
    final failures = <ResumeFailure>[];

    final details = resume.personalDetails;

    // 1. Full Name (REQUIRED)
    if (details == null || details.fullName.trim().isEmpty) {
      failures.add(
        const ValidationFailure('Full Name is required'),
      );
    }

    // 2. Phone Number (REQUIRED)
    if (details == null || details.phoneNumber.trim().isEmpty) {
      failures.add(
        const ValidationFailure('Phone Number is required'),
      );
    }

    // 3. Email (OPTIONAL, but syntax-validated if non-empty)
    if (details != null &&
        details.email.trim().isNotEmpty &&
        !details.email.contains('@')) {
      failures.add(
        const ValidationFailure('Please enter a valid email address'),
      );
    }

    return failures;
  }
}
