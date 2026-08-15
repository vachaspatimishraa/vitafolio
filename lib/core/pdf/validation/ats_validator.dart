import 'package:vitafolio/data/models/resume_model.dart';

class AtsValidationResult {
  final bool isAtsFriendly;
  final List<String> issues;
  final List<String> recommendations;
  final int atsScore; // 0 - 100

  const AtsValidationResult({
    required this.isAtsFriendly,
    required this.issues,
    required this.recommendations,
    required this.atsScore,
  });
}

/// Validates ATS (Applicant Tracking System) friendliness of a resume before PDF generation.
class AtsValidator {
  static AtsValidationResult validate(ResumeModel resume) {
    final issues = <String>[];
    final recommendations = <String>[];
    int score = 100;

    final fullName = resume.personalInfo?.fullName?.trim() ?? '';
    if (fullName.isEmpty) {
      issues.add('Full name is missing.');
      score -= 20;
    }

    final email = resume.personalInfo?.email?.trim() ?? '';
    if (email.isEmpty) {
      issues.add('Contact email is missing.');
      score -= 15;
    }

    final phone = resume.personalInfo?.phone?.trim() ?? '';
    if (phone.isEmpty) {
      recommendations.add('Consider adding a contact phone number.');
      score -= 5;
    }

    final summary = resume.professionalSummary?.summary?.trim() ?? '';
    if (summary.isEmpty) {
      recommendations.add(
        'A professional summary improves ATS keyword matching.',
      );
      score -= 10;
    }

    if (resume.experience == null || resume.experience!.isEmpty) {
      recommendations.add(
        'Including work experience helps ATS calculate relevance.',
      );
      score -= 10;
    }

    if (resume.skills == null || resume.skills!.isEmpty) {
      issues.add('No skills listed. Skills are critical for ATS indexing.');
      score -= 20;
    }

    // Ensure score bounds
    score = score.clamp(0, 100);

    return AtsValidationResult(
      isAtsFriendly: issues.isEmpty && score >= 70,
      issues: issues,
      recommendations: recommendations,
      atsScore: score,
    );
  }
}
