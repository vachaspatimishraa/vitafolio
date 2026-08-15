import 'package:vitafolio/data/models/embedded/certification_model.dart';
import 'package:vitafolio/data/models/embedded/education_model.dart';
import 'package:vitafolio/data/models/embedded/experience_model.dart';
import 'package:vitafolio/data/models/embedded/language_model.dart';
import 'package:vitafolio/data/models/embedded/project_model.dart';
import 'package:vitafolio/data/models/embedded/skill_model.dart';

/// Centralized helper for checking section visibility and filtering non-empty items.
class PdfSectionHelper {
  /// Checks if string content (e.g. summary) is non-empty.
  static bool hasSummary(String? summary) {
    return summary != null && summary.trim().isNotEmpty;
  }

  /// Checks if experience list has any valid experience entries.
  static bool hasExperience(List<ExperienceModel>? experiences) {
    if (experiences == null || experiences.isEmpty) return false;
    return experiences.any(
      (e) =>
          (e.company?.trim().isNotEmpty ?? false) ||
          (e.position?.trim().isNotEmpty ?? false) ||
          (e.description?.trim().isNotEmpty ?? false),
    );
  }

  /// Filters valid experience entries.
  static List<ExperienceModel> validExperiences(
    List<ExperienceModel>? experiences,
  ) {
    if (experiences == null) return [];
    return experiences
        .where(
          (e) =>
              (e.company?.trim().isNotEmpty ?? false) ||
              (e.position?.trim().isNotEmpty ?? false) ||
              (e.description?.trim().isNotEmpty ?? false),
        )
        .toList();
  }

  /// Checks if education list has any valid education entries.
  static bool hasEducation(List<EducationModel>? education) {
    if (education == null || education.isEmpty) return false;
    return education.any(
      (e) =>
          (e.school?.trim().isNotEmpty ?? false) ||
          (e.degree?.trim().isNotEmpty ?? false) ||
          (e.fieldOfStudy?.trim().isNotEmpty ?? false),
    );
  }

  /// Filters valid education entries.
  static List<EducationModel> validEducation(List<EducationModel>? education) {
    if (education == null) return [];
    return education
        .where(
          (e) =>
              (e.school?.trim().isNotEmpty ?? false) ||
              (e.degree?.trim().isNotEmpty ?? false) ||
              (e.fieldOfStudy?.trim().isNotEmpty ?? false),
        )
        .toList();
  }

  /// Checks if skills list (either `List<SkillModel>` or `List<String>`) has valid skills.
  static bool hasSkills(dynamic skills) {
    if (skills == null) return false;
    if (skills is List<SkillModel>) {
      return skills.any((s) => s.name?.trim().isNotEmpty ?? false);
    }
    if (skills is List<String>) {
      return skills.any((s) => s.trim().isNotEmpty);
    }
    return false;
  }

  /// Filters valid skills from `List<SkillModel>`.
  static List<SkillModel> validSkillModels(List<SkillModel>? skills) {
    if (skills == null) return [];
    return skills.where((s) => s.name?.trim().isNotEmpty ?? false).toList();
  }

  /// Filters valid skill strings.
  static List<String> validSkillStrings(List<String>? skills) {
    if (skills == null) return [];
    return skills.where((s) => s.trim().isNotEmpty).toList();
  }

  /// Checks if projects list has any valid project entries.
  static bool hasProjects(List<ProjectModel>? projects) {
    if (projects == null || projects.isEmpty) return false;
    return projects.any(
      (p) =>
          (p.projectName?.trim().isNotEmpty ?? false) ||
          (p.description?.trim().isNotEmpty ?? false),
    );
  }

  /// Filters valid project entries.
  static List<ProjectModel> validProjects(List<ProjectModel>? projects) {
    if (projects == null) return [];
    return projects
        .where(
          (p) =>
              (p.projectName?.trim().isNotEmpty ?? false) ||
              (p.description?.trim().isNotEmpty ?? false),
        )
        .toList();
  }

  /// Checks if certifications list has any valid certification entries.
  static bool hasCertifications(List<CertificationModel>? certifications) {
    if (certifications == null || certifications.isEmpty) return false;
    return certifications.any(
      (c) =>
          (c.certificateName?.trim().isNotEmpty ?? false) ||
          (c.organization?.trim().isNotEmpty ?? false),
    );
  }

  /// Filters valid certification entries.
  static List<CertificationModel> validCertifications(
    List<CertificationModel>? certifications,
  ) {
    if (certifications == null) return [];
    return certifications
        .where(
          (c) =>
              (c.certificateName?.trim().isNotEmpty ?? false) ||
              (c.organization?.trim().isNotEmpty ?? false),
        )
        .toList();
  }

  /// Checks if languages list has any valid language entries.
  static bool hasLanguages(List<LanguageModel>? languages) {
    if (languages == null || languages.isEmpty) return false;
    return languages.any((l) => l.language?.trim().isNotEmpty ?? false);
  }

  /// Filters valid language entries.
  static List<LanguageModel> validLanguages(List<LanguageModel>? languages) {
    if (languages == null) return [];
    return languages
        .where((l) => l.language?.trim().isNotEmpty ?? false)
        .toList();
  }
}
