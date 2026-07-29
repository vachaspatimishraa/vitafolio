import 'dart:convert';
import '../../data/repositories/resume_repository.dart';
import '../../data/models/resume_model.dart';
import '../../data/models/embedded/personal_information.dart';
import '../../data/models/embedded/professional_summary.dart';
import '../../data/models/embedded/education_model.dart';
import '../../data/models/embedded/experience_model.dart';
import '../../data/models/embedded/skill_model.dart';
import '../../data/models/embedded/project_model.dart';
import '../../data/models/embedded/certification_model.dart';
import '../../data/models/embedded/language_model.dart';
import '../../data/models/embedded/template_selection.dart';
import '../../data/models/enums/resume_status.dart';
import '../../data/models/enums/language_proficiency.dart';
import '../../data/models/enums/employment_type.dart';
import '../database/database_logger.dart';

class BackupService {
  final ResumeRepository _repository;

  BackupService(this._repository);

  /// Exports all resumes into a single JSON string.
  Future<String> exportBackup() async {
    try {
      DatabaseLogger.info('Starting backup export...');
      final resumes = await _repository.getAllResumes();
      
      final list = resumes.map((r) => _serializeResume(r)).toList();
      final backupMap = {
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'resumes': list,
      };

      DatabaseLogger.info('Backup export completed successfully.');
      return jsonEncode(backupMap);
    } catch (e, stackTrace) {
      DatabaseLogger.error('Failed to export backup', err: e, st: stackTrace);
      rethrow;
    }
  }

  /// Imports resumes from a backup JSON string.
  Future<void> importBackup(String backupJson) async {
    try {
      DatabaseLogger.info('Starting backup import...');
      final Map<String, dynamic> backupMap = jsonDecode(backupJson);
      
      final resumesList = backupMap['resumes'] as List<dynamic>;
      for (final raw in resumesList) {
        final resume = _deserializeResume(raw as Map<String, dynamic>);
        final exists = await _repository.checkResumeExists(resume.id);
        if (exists) {
          await _repository.updateResume(resume);
        } else {
          await _repository.createResume(resume);
        }
      }
      DatabaseLogger.info('Backup import completed successfully.');
    } catch (e, stackTrace) {
      DatabaseLogger.error('Failed to import backup', err: e, st: stackTrace);
      rethrow;
    }
  }

  Map<String, dynamic> _serializeResume(ResumeModel r) {
    return {
      'id': r.id,
      'resumeName': r.resumeName,
      'createdDate': r.createdDate?.toIso8601String(),
      'lastUpdated': r.lastUpdated?.toIso8601String(),
      'status': r.status.name,
      'selectedTemplate': r.selectedTemplate == null ? null : {
        'templateId': r.selectedTemplate!.templateId,
        'templateName': r.selectedTemplate!.templateName,
        'category': r.selectedTemplate!.category,
        'isAtsFriendly': r.selectedTemplate!.isAtsFriendly,
        'themeColor': r.selectedTemplate!.themeColor,
      },
      'personalInfo': r.personalInfo == null ? null : {
        'fullName': r.personalInfo!.fullName,
        'jobTitle': r.personalInfo!.jobTitle,
        'email': r.personalInfo!.email,
        'phone': r.personalInfo!.phone,
        'linkedIn': r.personalInfo!.linkedIn,
        'github': r.personalInfo!.github,
        'portfolioWebsite': r.personalInfo!.portfolioWebsite,
      },
      'professionalSummary': r.professionalSummary?.summary,
      'education': r.education?.map((e) => {
        'id': e.id,
        'school': e.school,
        'degree': e.degree,
        'fieldOfStudy': e.fieldOfStudy,
        'grade': e.grade,
        'startDate': e.startDate?.toIso8601String(),
        'endDate': e.endDate?.toIso8601String(),
        'isCurrentlyStudying': e.isCurrentlyStudying,
      }).toList(),
      'experience': r.experience?.map((e) => {
        'id': e.id,
        'company': e.company,
        'position': e.position,
        'location': e.location,
        'employmentType': e.employmentType.name,
        'startDate': e.startDate?.toIso8601String(),
        'endDate': e.endDate?.toIso8601String(),
        'isCurrentlyWorking': e.isCurrentlyWorking,
        'description': e.description,
      }).toList(),
      'skills': r.skills?.map((e) => {
        'id': e.id,
        'name': e.name,
        'category': e.category,
      }).toList(),
      'projects': r.projects?.map((e) => {
        'id': e.id,
        'projectName': e.projectName,
        'description': e.description,
        'technologies': e.technologies,
        'githubUrl': e.githubUrl,
        'liveDemoUrl': e.liveDemoUrl,
      }).toList(),
      'certifications': r.certifications?.map((e) => {
        'id': e.id,
        'certificateName': e.certificateName,
        'organization': e.organization,
        'issueDate': e.issueDate?.toIso8601String(),
        'credentialUrl': e.credentialUrl,
      }).toList(),
      'languages': r.languages?.map((e) => {
        'id': e.id,
        'language': e.language,
        'proficiency': e.proficiency.name,
      }).toList(),
    };
  }

  ResumeModel _deserializeResume(Map<String, dynamic> map) {
    final statusStr = map['status'] as String;
    final status = ResumeStatus.values.firstWhere(
      (s) => s.name == statusStr,
      orElse: () => ResumeStatus.draft,
    );

    final templateMap = map['selectedTemplate'] as Map<String, dynamic>?;
    TemplateSelection? selectedTemplate;
    if (templateMap != null) {
      selectedTemplate = TemplateSelection()
        ..templateId = templateMap['templateId'] as String?
        ..templateName = templateMap['templateName'] as String?
        ..category = templateMap['category'] as String?
        ..isAtsFriendly = templateMap['isAtsFriendly'] as bool?
        ..themeColor = templateMap['themeColor'] as String?;
    }

    final personalMap = map['personalInfo'] as Map<String, dynamic>?;
    PersonalInformation? personalInfo;
    if (personalMap != null) {
      personalInfo = PersonalInformation(
        fullName: personalMap['fullName'] as String?,
        jobTitle: personalMap['jobTitle'] as String?,
        email: personalMap['email'] as String?,
        phone: personalMap['phone'] as String?,
        linkedIn: personalMap['linkedIn'] as String?,
        github: personalMap['github'] as String?,
        portfolioWebsite: personalMap['portfolioWebsite'] as String?,
      );
    }

    return ResumeModel(
      id: map['id'] as int,
      resumeName: map['resumeName'] as String?,
      createdDate: map['createdDate'] != null ? DateTime.tryParse(map['createdDate'] as String) : null,
      lastUpdated: map['lastUpdated'] != null ? DateTime.tryParse(map['lastUpdated'] as String) : null,
      status: status,
      selectedTemplate: selectedTemplate,
      personalInfo: personalInfo,
      professionalSummary: map['professionalSummary'] != null
          ? ProfessionalSummary(summary: map['professionalSummary'] as String?)
          : null,
      education: (map['education'] as List<dynamic>?)?.map((e) {
        final m = e as Map<String, dynamic>;
        return EducationModel(
          id: m['id'] as String?,
          school: m['school'] as String?,
          degree: m['degree'] as String?,
          fieldOfStudy: m['fieldOfStudy'] as String?,
          grade: m['grade'] as String?,
          startDate: m['startDate'] != null ? DateTime.tryParse(m['startDate'] as String) : null,
          endDate: m['endDate'] != null ? DateTime.tryParse(m['endDate'] as String) : null,
          isCurrentlyStudying: m['isCurrentlyStudying'] as bool?,
        );
      }).toList(),
      experience: (map['experience'] as List<dynamic>?)?.map((e) {
        final m = e as Map<String, dynamic>;
        final empTypeStr = m['employmentType'] as String?;
        final empType = EmploymentType.values.firstWhere(
          (t) => t.name == empTypeStr,
          orElse: () => EmploymentType.fullTime,
        );
        return ExperienceModel(
          id: m['id'] as String?,
          company: m['company'] as String?,
          position: m['position'] as String?,
          location: m['location'] as String?,
          employmentType: empType,
          startDate: m['startDate'] != null ? DateTime.tryParse(m['startDate'] as String) : null,
          endDate: m['endDate'] != null ? DateTime.tryParse(m['endDate'] as String) : null,
          isCurrentlyWorking: m['isCurrentlyWorking'] as bool?,
          description: m['description'] as String?,
        );
      }).toList(),
      skills: (map['skills'] as List<dynamic>?)?.map((e) {
        final m = e as Map<String, dynamic>;
        return SkillModel(
          id: m['id'] as String?,
          name: m['name'] as String?,
          category: m['category'] as String?,
        );
      }).toList(),
      projects: (map['projects'] as List<dynamic>?)?.map((e) {
        final m = e as Map<String, dynamic>;
        return ProjectModel(
          id: m['id'] as String?,
          projectName: m['projectName'] as String?,
          description: m['description'] as String?,
          technologies: m['technologies'] as String?,
          githubUrl: m['githubUrl'] as String?,
          liveDemoUrl: m['liveDemoUrl'] as String?,
        );
      }).toList(),
      certifications: (map['certifications'] as List<dynamic>?)?.map((e) {
        final m = e as Map<String, dynamic>;
        return CertificationModel(
          id: m['id'] as String?,
          certificateName: m['certificateName'] as String?,
          organization: m['organization'] as String?,
          issueDate: m['issueDate'] != null ? DateTime.tryParse(m['issueDate'] as String) : null,
          credentialUrl: m['credentialUrl'] as String?,
        );
      }).toList(),
      languages: (map['languages'] as List<dynamic>?)?.map((e) {
        final m = e as Map<String, dynamic>;
        final profStr = m['proficiency'] as String?;
        final prof = LanguageProficiency.values.firstWhere(
          (p) => p.name == profStr,
          orElse: () => LanguageProficiency.beginner,
        );
        return LanguageModel(
          id: m['id'] as String?,
          language: m['language'] as String?,
          proficiency: prof,
        );
      }).toList(),
    );
  }
}
