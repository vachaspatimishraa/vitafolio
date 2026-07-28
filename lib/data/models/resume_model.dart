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
}
