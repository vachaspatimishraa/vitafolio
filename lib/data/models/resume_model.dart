import 'package:isar/isar.dart';
import 'package:vitafolio/data/models/embedded/personal_information.dart';
import 'package:vitafolio/data/models/embedded/professional_summary.dart';
import 'package:vitafolio/data/models/embedded/education_model.dart';
import 'package:vitafolio/data/models/embedded/experience_model.dart';
import 'package:vitafolio/data/models/embedded/skill_model.dart';
import 'package:vitafolio/data/models/embedded/project_model.dart';
import 'package:vitafolio/data/models/embedded/certification_model.dart';
import 'package:vitafolio/data/models/embedded/language_model.dart';
import 'package:vitafolio/data/models/embedded/template_selection.dart';

part 'resume_model.g.dart';

@collection
class ResumeModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? resumeName;

  @Index()
  DateTime? createdDate;

  @Index()
  DateTime? lastUpdated;

  TemplateSelection? selectedTemplate;
  PersonalInformation? personalInfo;
  ProfessionalSummary? professionalSummary;
  List<EducationModel>? education;
  List<ExperienceModel>? experience;
  List<SkillModel>? skills;
  List<ProjectModel>? projects;
  List<CertificationModel>? certifications;
  List<LanguageModel>? languages;

  ResumeModel({
    this.id = Isar.autoIncrement,
    this.resumeName,
    this.createdDate,
    this.lastUpdated,
    this.selectedTemplate,
    this.personalInfo,
    this.professionalSummary,
    this.education,
    this.experience,
    this.skills,
    this.projects,
    this.certifications,
    this.languages,
  });

  ResumeModel copyWith({
    Id? id,
    String? resumeName,
    DateTime? createdDate,
    DateTime? lastUpdated,
    TemplateSelection? selectedTemplate,
    PersonalInformation? personalInfo,
    ProfessionalSummary? professionalSummary,
    List<EducationModel>? education,
    List<ExperienceModel>? experience,
    List<SkillModel>? skills,
    List<ProjectModel>? projects,
    List<CertificationModel>? certifications,
    List<LanguageModel>? languages,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      resumeName: resumeName ?? this.resumeName,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      personalInfo: personalInfo ?? this.personalInfo,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
    );
  }
}
