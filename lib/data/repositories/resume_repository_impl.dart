import 'package:isar/isar.dart';
import '../datasource/isar_service.dart';
import '../models/enums/employment_type.dart';
import '../models/enums/language_proficiency.dart';
import '../models/resume_model.dart' as db;
import '../models/resume/resume_model.dart' as domain;
import '../models/embedded/personal_information.dart' as db_personal;
import '../models/embedded/professional_summary.dart' as db_summary;
import '../models/embedded/education_model.dart' as db_edu;
import '../models/embedded/experience_model.dart' as db_exp;
import '../models/embedded/skill_model.dart' as db_skill;
import '../models/embedded/project_model.dart' as db_proj;
import '../models/embedded/certification_model.dart' as db_cert;
import '../models/embedded/language_model.dart' as db_lang;
import '../models/embedded/template_selection.dart' as db_temp;
import '../../features/workflow/models/workflow_state.dart';
import 'resume_repository.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final IsarService _isarService;
  final Isar _isar;

  ResumeRepositoryImpl(this._isarService, this._isar);

  @override
  Future<domain.ResumeModel> createResume(domain.ResumeModel resume) async {
    final dbModel = _toDbModel(resume);
    await _isarService.saveResume(dbModel);
    return _toDomainModel(dbModel);
  }

  @override
  Future<domain.ResumeModel?> getResume(String id) async {
    final intId = int.tryParse(id);
    if (intId == null) return null;
    final dbModel = await _isarService.getResume(intId);
    if (dbModel == null) return null;
    return _toDomainModel(dbModel);
  }

  @override
  Future<List<domain.ResumeModel>> getAllResumes() async {
    final dbResumes = await _isarService.getAllResumes();
    return dbResumes.map(_toDomainModel).toList();
  }

  @override
  Future<void> updateResume(domain.ResumeModel resume) async {
    final dbModel = _toDbModel(resume);
    await _isarService.saveResume(dbModel);
  }

  @override
  Future<void> deleteResume(String id) async {
    final intId = int.tryParse(id);
    if (intId != null) {
      await _isarService.deleteResume(intId);
    }
  }

  @override
  Future<domain.ResumeModel> duplicateResume(String id, String defaultSuffix) async {
    final original = await getResume(id);
    if (original == null) {
      throw Exception('Original resume not found');
    }
    final duplicated = original.copyWith(
      id: '',
      title: '${original.title} $defaultSuffix'.trim(),
      status: domain.ResumeStatus.draft,
      lastUpdated: DateTime.now().toIso8601String(),
    );
    return createResume(duplicated);
  }

  @override
  Future<void> renameResume(String id, String newName) async {
    final resume = await getResume(id);
    if (resume != null) {
      final updated = resume.copyWith(
        title: newName,
        lastUpdated: DateTime.now().toIso8601String(),
      );
      await updateResume(updated);
    }
  }

  @override
  Future<List<domain.ResumeModel>> searchResumes(String query) async {
    final dbResumes = await _isarService.searchResumes(query);
    return dbResumes.map(_toDomainModel).toList();
  }

  @override
  Future<List<domain.ResumeModel>> filterResumes(domain.ResumeStatus status) async {
    final all = await getAllResumes();
    return all.where((r) => r.status == status).toList();
  }

  @override
  Future<List<domain.ResumeModel>> sortResumes(
      List<domain.ResumeModel> resumes, String sortBy) async {
    final sorted = [...resumes];
    if (sortBy == 'name') {
      sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else if (sortBy == 'lastUpdated') {
      sorted.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    }
    return sorted;
  }

  @override
  Future<Map<String, int>> getResumeStatistics() async {
    final all = await getAllResumes();
    int draftCount = 0;
    int completedCount = 0;
    for (final r in all) {
      if (r.status == domain.ResumeStatus.draft) {
        draftCount++;
      } else if (r.status == domain.ResumeStatus.completed) {
        completedCount++;
      }
    }
    return {
      'total': all.length,
      'draft': draftCount,
      'completed': completedCount,
    };
  }

  @override
  Future<bool> checkResumeExists(String id) async {
    final resume = await getResume(id);
    return resume != null;
  }

  @override
  Future<void> updateSelectedTemplate(String resumeId, String templateId) async {
    final resume = await getResume(resumeId);
    if (resume != null) {
      final updated = resume.copyWith(
        templateId: templateId,
        lastUpdated: DateTime.now().toIso8601String(),
      );
      await updateResume(updated);
    }
  }

  // --- Mappings ---

  db.ResumeModel _toDbModel(domain.ResumeModel domainModel) {
    final dbModel = db.ResumeModel();
    final parsedId = int.tryParse(domainModel.id);
    if (parsedId != null) {
      dbModel.id = parsedId;
    }
    dbModel.resumeName = domainModel.title;
    dbModel.lastUpdated = DateTime.tryParse(domainModel.lastUpdated) ?? DateTime.now();
    dbModel.status = domainModel.status;

    dbModel.selectedTemplate = db_temp.TemplateSelection()
      ..templateId = domainModel.templateId;

    dbModel.personalInfo = db_personal.PersonalInformation()
      ..fullName = domainModel.personalInfo.fullName
      ..jobTitle = domainModel.personalInfo.jobTitle
      ..email = domainModel.personalInfo.email
      ..phone = domainModel.personalInfo.phone
      ..address = domainModel.personalInfo.address
      ..city = domainModel.personalInfo.city
      ..state = domainModel.personalInfo.state
      ..country = domainModel.personalInfo.country
      ..linkedIn = domainModel.personalInfo.linkedIn
      ..github = domainModel.personalInfo.github;

    dbModel.professionalSummary = db_summary.ProfessionalSummary()
      ..summary = domainModel.summary;

    dbModel.education = domainModel.education.map((e) {
      return db_edu.EducationModel()
        ..school = e.title
        ..degree = e.subtitle
        ..fieldOfStudy = e.location
        ..grade = e.extra
        ..startDate = DateTime.tryParse(e.startDate)
        ..endDate = DateTime.tryParse(e.endDate)
        ..isCurrentlyStudying = e.isCurrent;
    }).toList();

    dbModel.experience = domainModel.experience.map((e) {
      return db_exp.ExperienceModel()
        ..company = e.title
        ..position = e.subtitle
        ..location = e.location
        ..startDate = DateTime.tryParse(e.startDate)
        ..endDate = DateTime.tryParse(e.endDate)
        ..isCurrentlyWorking = e.isCurrent
        ..description = e.description
        ..employmentType = _toDbEmploymentType(e.extra);
    }).toList();

    dbModel.skills = domainModel.skills.map((s) {
      return db_skill.SkillModel()
        ..name = s;
    }).toList();

    dbModel.projects = domainModel.projects.map((e) {
      return db_proj.ProjectModel()
        ..projectName = e.title
        ..description = e.description
        ..technologies = e.subtitle
        ..githubUrl = e.url
        ..liveDemoUrl = e.extra;
    }).toList();

    dbModel.certifications = domainModel.certifications.map((e) {
      return db_cert.CertificationModel()
        ..certificateName = e.title
        ..organization = e.subtitle
        ..issueDate = DateTime.tryParse(e.startDate)
        ..credentialUrl = e.url;
    }).toList();

    dbModel.languages = domainModel.languages.map((e) {
      return db_lang.LanguageModel()
        ..language = e.title
        ..proficiency = _toDbLanguageProficiency(e.proficiency);
    }).toList();

    return dbModel;
  }

  domain.ResumeModel _toDomainModel(db.ResumeModel dbModel) {
    return domain.ResumeModel(
      id: dbModel.id.toString(),
      title: dbModel.resumeName ?? 'Untitled Resume',
      templateId: dbModel.selectedTemplate?.templateId ?? 'modern_clean',
      lastUpdated: dbModel.lastUpdated?.toIso8601String() ?? DateTime.now().toIso8601String(),
      status: dbModel.status,
      personalInfo: ResumePersonalInfo(
        fullName: dbModel.personalInfo?.fullName ?? '',
        jobTitle: dbModel.personalInfo?.jobTitle ?? '',
        email: dbModel.personalInfo?.email ?? '',
        phone: dbModel.personalInfo?.phone ?? '',
        address: dbModel.personalInfo?.address ?? '',
        city: dbModel.personalInfo?.city ?? '',
        state: dbModel.personalInfo?.state ?? '',
        country: dbModel.personalInfo?.country ?? '',
        linkedIn: dbModel.personalInfo?.linkedIn ?? '',
        github: dbModel.personalInfo?.github ?? '',
        portfolio: '',
      ),
      summary: dbModel.professionalSummary?.summary ?? '',
      education: dbModel.education?.map((e) {
        return ResumeEntry(
          title: e.school ?? '',
          subtitle: e.degree ?? '',
          location: e.fieldOfStudy ?? '',
          extra: e.grade ?? '',
          startDate: e.startDate?.toIso8601String() ?? '',
          endDate: e.endDate?.toIso8601String() ?? '',
          isCurrent: e.isCurrentlyStudying ?? false,
        );
      }).toList() ?? [],
      experience: dbModel.experience?.map((e) {
        return ResumeEntry(
          title: e.company ?? '',
          subtitle: e.position ?? '',
          location: e.location ?? '',
          startDate: e.startDate?.toIso8601String() ?? '',
          endDate: e.endDate?.toIso8601String() ?? '',
          isCurrent: e.isCurrentlyWorking ?? false,
          description: e.description ?? '',
          extra: e.employmentType.name,
        );
      }).toList() ?? [],
      skills: dbModel.skills?.map((s) => s.name ?? '').where((s) => s.isNotEmpty).toList() ?? [],
      projects: dbModel.projects?.map((e) {
        return ResumeEntry(
          title: e.projectName ?? '',
          description: e.description ?? '',
          subtitle: e.technologies ?? '',
          url: e.githubUrl ?? '',
          extra: e.liveDemoUrl ?? '',
        );
      }).toList() ?? [],
      certifications: dbModel.certifications?.map((e) {
        return ResumeEntry(
          title: e.certificateName ?? '',
          subtitle: e.organization ?? '',
          startDate: e.issueDate?.toIso8601String() ?? '',
          url: e.credentialUrl ?? '',
        );
      }).toList() ?? [],
      languages: dbModel.languages?.map((e) {
        return ResumeEntry(
          title: e.language ?? '',
          proficiency: e.proficiency.name,
        );
      }).toList() ?? [],
    );
  }

  EmploymentType _toDbEmploymentType(String typeStr) {
    for (final val in EmploymentType.values) {
      if (val.name == typeStr) {
        return val;
      }
    }
    return EmploymentType.fullTime;
  }

  LanguageProficiency _toDbLanguageProficiency(String profStr) {
    for (final val in LanguageProficiency.values) {
      if (val.name == profStr) {
        return val;
      }
    }
    return LanguageProficiency.beginner;
  }
}
