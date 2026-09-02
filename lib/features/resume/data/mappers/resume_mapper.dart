import 'package:vitafolio/features/resume/data/models/resume_model.dart';
import 'package:vitafolio/features/resume/domain/entities/certification.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/language.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

class ResumeMapper {
  static Resume toDomain(ResumeDbModel model) {
    final domainIdStr = (model.id != null)
        ? model.id.toString()
        : (model.domainId ?? '');
    return Resume(
      id: ResumeId(domainIdStr),
      title: model.title,
      isTitleManuallySet: model.isTitleManuallySet ?? false,
      selectedTemplateId: TemplateId(model.selectedTemplateId),
      fontFamily: model.fontFamily ?? 'roboto',
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      personalDetails: model.personalDetails != null
          ? _personalDetailsToDomain(model.personalDetails!)
          : null,
      summary: model.summary != null ? _summaryToDomain(model.summary!) : null,
      experiences: model.experiences?.map(_experienceToDomain).toList() ?? [],
      projects: model.projects?.map(_projectToDomain).toList() ?? [],
      educations: model.educations?.map(_educationToDomain).toList() ?? [],
      skills: model.skills?.map(_skillToDomain).toList() ?? [],
      certifications:
          model.certifications?.map(_certificationToDomain).toList() ?? [],
      languages: model.languages?.map(_languageToDomain).toList() ?? [],
    );
  }

  static ResumeDbModel toModel(Resume domain) {
    final model = ResumeDbModel()
      ..title = domain.title
      ..isTitleManuallySet = domain.isTitleManuallySet
      ..selectedTemplateId = domain.selectedTemplateId.value
      ..fontFamily = domain.fontFamily
      ..createdAt = domain.createdAt
      ..updatedAt = domain.updatedAt
      ..domainId = domain.id.value
      ..personalDetails = domain.personalDetails != null
          ? _personalDetailsToModel(domain.personalDetails!)
          : null
      ..summary = domain.summary != null
          ? _summaryToModel(domain.summary!)
          : null
      ..experiences = domain.experiences.map(_experienceToModel).toList()
      ..projects = domain.projects.map(_projectToModel).toList()
      ..educations = domain.educations.map(_educationToModel).toList()
      ..skills = domain.skills.map(_skillToModel).toList()
      ..certifications = domain.certifications
          .map(_certificationToModel)
          .toList()
      ..languages = domain.languages.map(_languageToModel).toList();

    if (domain.id.value.isNotEmpty) {
      model.id = int.tryParse(domain.id.value);
    }

    return model;
  }

  static PersonalDetails _personalDetailsToDomain(PersonalDetailsModel model) {
    return PersonalDetails(
      fullName: model.fullName ?? '',
      email: model.email ?? '',
      phoneNumber: model.phoneNumber ?? '',
      address: model.address ?? '',
      jobTitle: model.jobTitle,
      website: model.website,
      linkedinUrl: model.linkedinUrl,
      githubUrl: model.githubUrl,
      profileImagePath: model.profileImagePath,
    );
  }

  static PersonalDetailsModel _personalDetailsToModel(PersonalDetails domain) {
    return PersonalDetailsModel()
      ..fullName = domain.fullName
      ..email = domain.email
      ..phoneNumber = domain.phoneNumber
      ..address = domain.address
      ..jobTitle = domain.jobTitle
      ..website = domain.website
      ..linkedinUrl = domain.linkedinUrl
      ..githubUrl = domain.githubUrl
      ..profileImagePath = domain.profileImagePath;
  }

  static ProfessionalSummary _summaryToDomain(ProfessionalSummaryModel model) {
    return ProfessionalSummary(summaryText: model.summaryText ?? '');
  }

  static ProfessionalSummaryModel _summaryToModel(ProfessionalSummary domain) {
    return ProfessionalSummaryModel()..summaryText = domain.summaryText;
  }

  static Experience _experienceToDomain(ExperienceModel model) {
    return Experience(
      id: model.id ?? '',
      jobTitle: model.jobTitle ?? '',
      company: model.company ?? '',
      location: model.location ?? '',
      startDate: model.startDate ?? '',
      endDate: model.endDate,
      isCurrentRole: model.isCurrentRole ?? false,
      description: model.description ?? '',
    );
  }

  static ExperienceModel _experienceToModel(Experience domain) {
    return ExperienceModel()
      ..id = domain.id
      ..jobTitle = domain.jobTitle
      ..company = domain.company
      ..location = domain.location
      ..startDate = domain.startDate
      ..endDate = domain.endDate
      ..isCurrentRole = domain.isCurrentRole
      ..description = domain.description;
  }

  static Project _projectToDomain(ProjectDbModel model) {
    return Project(
      id: model.id ?? '',
      name: model.name ?? '',
      role: model.role ?? '',
      description: model.description ?? '',
      technologies: model.technologies ?? const [],
      projectUrl: model.projectUrl ?? '',
      startDate: model.startDate,
      endDate: model.endDate,
      isOngoing: model.isOngoing ?? false,
    );
  }

  static ProjectDbModel _projectToModel(Project domain) {
    return ProjectDbModel()
      ..id = domain.id
      ..name = domain.name
      ..role = domain.role
      ..description = domain.description
      ..technologies = domain.technologies
      ..projectUrl = domain.projectUrl
      ..startDate = domain.startDate
      ..endDate = domain.endDate
      ..isOngoing = domain.isOngoing;
  }

  static Education _educationToDomain(EducationModel model) {
    return Education(
      id: model.id ?? '',
      degree: model.degree ?? '',
      fieldOfStudy: model.fieldOfStudy ?? '',
      institution: model.institution ?? '',
      location: model.location ?? '',
      startYear: model.startYear ?? '',
      endYear: model.endYear ?? '',
      isCurrentlyStudying: model.isCurrentlyStudying ?? false,
      grade: model.grade,
      description: model.description,
    );
  }

  static EducationModel _educationToModel(Education domain) {
    return EducationModel()
      ..id = domain.id
      ..degree = domain.degree
      ..fieldOfStudy = domain.fieldOfStudy
      ..institution = domain.institution
      ..location = domain.location
      ..startYear = domain.startYear
      ..endYear = domain.endYear
      ..isCurrentlyStudying = domain.isCurrentlyStudying
      ..grade = domain.grade
      ..description = domain.description;
  }

  static Skill _skillToDomain(SkillModel model) {
    return Skill(
      id: model.id ?? '',
      name: model.name ?? '',
      level: model.level,
    );
  }

  static SkillModel _skillToModel(Skill domain) {
    return SkillModel()
      ..id = domain.id
      ..name = domain.name
      ..level = domain.level;
  }

  static Certification _certificationToDomain(CertificationModel model) {
    return Certification(
      id: model.id ?? '',
      name: model.name ?? '',
      organization: model.organization ?? '',
      issueDate: model.issueDate ?? '',
      expiryDate: model.expiryDate,
      credentialId: model.credentialId,
    );
  }

  static CertificationModel _certificationToModel(Certification domain) {
    return CertificationModel()
      ..id = domain.id
      ..name = domain.name
      ..organization = domain.organization
      ..issueDate = domain.issueDate
      ..expiryDate = domain.expiryDate
      ..credentialId = domain.credentialId;
  }

  static Language _languageToDomain(LanguageModel model) {
    return Language(
      id: model.id ?? '',
      name: model.name ?? '',
      proficiencyLevel: model.proficiencyLevel ?? '',
    );
  }

  static LanguageModel _languageToModel(Language domain) {
    return LanguageModel()
      ..id = domain.id
      ..name = domain.name
      ..proficiencyLevel = domain.proficiencyLevel;
  }
}

