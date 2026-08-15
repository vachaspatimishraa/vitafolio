import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/services/resume_completion_calculator.dart';

/// Pure Domain Implementation of [ResumeCompletionCalculator].
/// Computes step-by-step progress and section completion metrics for a [Resume] across all 9 builder sections.
class ResumeCompletionCalculatorImpl implements ResumeCompletionCalculator {
  const ResumeCompletionCalculatorImpl();

  @override
  double calculateProgress(Resume resume) {
    final completed = completedSections(resume);
    return completed / totalSections();
  }

  @override
  int completedSections(Resume resume) {
    int count = 0;

    // 1. Document Title / Identity
    if (resume.title.trim().isNotEmpty) {
      count++;
    }

    // 2. Selected Template ID
    if (resume.selectedTemplateId.value.trim().isNotEmpty) {
      count++;
    }

    // 3. Personal Details
    if (resume.personalDetails != null &&
        resume.personalDetails!.fullName.trim().isNotEmpty &&
        resume.personalDetails!.email.trim().isNotEmpty &&
        resume.personalDetails!.phoneNumber.trim().isNotEmpty) {
      count++;
    }

    // 4. Professional Summary
    if (resume.summary != null &&
        resume.summary!.summaryText.trim().isNotEmpty) {
      count++;
    }

    // 5. Work Experience
    if (resume.experiences.isNotEmpty &&
        resume.experiences.every(
          (exp) =>
              exp.jobTitle.trim().isNotEmpty && exp.company.trim().isNotEmpty,
        )) {
      count++;
    }

    // 6. Projects
    if (resume.projects.isNotEmpty &&
        resume.projects.every(
          (p) => p.name.trim().isNotEmpty && p.description.trim().isNotEmpty,
        )) {
      count++;
    }

    // 7. Education
    if (resume.educations.isNotEmpty &&
        resume.educations.every(
          (edu) =>
              edu.degree.trim().isNotEmpty && edu.institution.trim().isNotEmpty,
        )) {
      count++;
    }

    // 8. Skills
    if (resume.skills.isNotEmpty &&
        resume.skills.every((skill) => skill.name.trim().isNotEmpty)) {
      count++;
    }

    // 9. Certifications
    if (resume.certifications.isNotEmpty &&
        resume.certifications.every(
          (cert) =>
              cert.name.trim().isNotEmpty &&
              cert.organization.trim().isNotEmpty,
        )) {
      count++;
    }

    // 10. Languages
    if (resume.languages.isNotEmpty &&
        resume.languages.every(
          (lang) =>
              lang.name.trim().isNotEmpty &&
              lang.proficiencyLevel.trim().isNotEmpty,
        )) {
      count++;
    }

    return count;
  }

  @override
  int totalSections() => 10;
}

