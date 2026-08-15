import 'package:vitafolio/features/resume/domain/entities/certification.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/language.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

/// Pure Dart immutable Root Entity representing a complete Resume.
class Resume {
  final ResumeId id;
  final String title;
  final bool isTitleManuallySet;
  final TemplateId selectedTemplateId;
  final PersonalDetails? personalDetails;
  final ProfessionalSummary? summary;
  final List<Experience> experiences;
  final List<Project> projects;
  final List<Education> educations;
  final List<Skill> skills;
  final List<Certification> certifications;
  final List<Language> languages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Resume({
    required this.id,
    required this.title,
    this.isTitleManuallySet = false,
    required this.selectedTemplateId,
    this.personalDetails,
    this.summary,
    this.experiences = const [],
    this.projects = const [],
    this.educations = const [],
    this.skills = const [],
    this.certifications = const [],
    this.languages = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Resume copyWith({
    ResumeId? id,
    String? title,
    bool? isTitleManuallySet,
    TemplateId? selectedTemplateId,
    PersonalDetails? personalDetails,
    ProfessionalSummary? summary,
    List<Experience>? experiences,
    List<Project>? projects,
    List<Education>? educations,
    List<Skill>? skills,
    List<Certification>? certifications,
    List<Language>? languages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Resume(
      id: id ?? this.id,
      title: title ?? this.title,
      isTitleManuallySet: isTitleManuallySet ?? this.isTitleManuallySet,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      personalDetails: personalDetails ?? this.personalDetails,
      summary: summary ?? this.summary,
      experiences: experiences ?? this.experiences,
      projects: projects ?? this.projects,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resume &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          selectedTemplateId == other.selectedTemplateId &&
          personalDetails == other.personalDetails &&
          summary == other.summary &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      selectedTemplateId.hashCode ^
      personalDetails.hashCode ^
      summary.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

