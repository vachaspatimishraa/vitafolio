import 'package:isar/isar.dart';
import 'embedded/personal_information.dart';
import 'embedded/professional_summary.dart';
import 'embedded/education_model.dart';
import 'embedded/experience_model.dart';
import 'embedded/skill_model.dart';
import 'embedded/project_model.dart';
import 'embedded/certification_model.dart';
import 'embedded/language_model.dart';
import 'embedded/template_selection.dart';
import 'enums/resume_status.dart';

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

  @enumerated
  @Index()
  var status = ResumeStatus.draft;

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
    this.status = ResumeStatus.draft,
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
    ResumeStatus? status,
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
      status: status ?? this.status,
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
