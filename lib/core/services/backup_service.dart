import 'dart:convert';
import '../../data/repositories/resume_repository.dart';
import '../../data/models/resume/resume_model.dart';
import '../../features/workflow/models/workflow_state.dart';
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
        // Create as a new resume or update existing
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
      'title': r.title,
      'templateId': r.templateId,
      'lastUpdated': r.lastUpdated,
      'status': r.status.name,
      'summary': r.summary,
      'personalInfo': {
        'fullName': r.personalInfo.fullName,
        'jobTitle': r.personalInfo.jobTitle,
        'email': r.personalInfo.email,
        'phone': r.personalInfo.phone,
        'address': r.personalInfo.address,
        'city': r.personalInfo.city,
        'state': r.personalInfo.state,
        'country': r.personalInfo.country,
        'linkedIn': r.personalInfo.linkedIn,
        'github': r.personalInfo.github,
        'portfolio': r.personalInfo.portfolio,
      },
      'education': r.education.map((e) => _serializeEntry(e)).toList(),
      'experience': r.experience.map((e) => _serializeEntry(e)).toList(),
      'skills': r.skills,
      'projects': r.projects.map((e) => _serializeEntry(e)).toList(),
      'certifications': r.certifications.map((e) => _serializeEntry(e)).toList(),
      'languages': r.languages.map((e) => _serializeEntry(e)).toList(),
    };
  }

  ResumeModel _deserializeResume(Map<String, dynamic> map) {
    final personalMap = map['personalInfo'] as Map<String, dynamic>;
    final statusStr = map['status'] as String;
    final status = ResumeStatus.values.firstWhere(
      (s) => s.name == statusStr,
      orElse: () => ResumeStatus.draft,
    );

    return ResumeModel(
      id: map['id'] as String,
      title: map['title'] as String,
      templateId: map['templateId'] as String? ?? 'modern_clean',
      lastUpdated: map['lastUpdated'] as String,
      status: status,
      summary: map['summary'] as String? ?? '',
      personalInfo: ResumePersonalInfo(
        fullName: personalMap['fullName'] as String? ?? '',
        jobTitle: personalMap['jobTitle'] as String? ?? '',
        email: personalMap['email'] as String? ?? '',
        phone: personalMap['phone'] as String? ?? '',
        address: personalMap['address'] as String? ?? '',
        city: personalMap['city'] as String? ?? '',
        state: personalMap['state'] as String? ?? '',
        country: personalMap['country'] as String? ?? '',
        linkedIn: personalMap['linkedIn'] as String? ?? '',
        github: personalMap['github'] as String? ?? '',
        portfolio: personalMap['portfolio'] as String? ?? '',
      ),
      education: (map['education'] as List<dynamic>?)?.map((e) => _deserializeEntry(e)).toList() ?? const [],
      experience: (map['experience'] as List<dynamic>?)?.map((e) => _deserializeEntry(e)).toList() ?? const [],
      skills: (map['skills'] as List<dynamic>?)?.cast<String>() ?? const [],
      projects: (map['projects'] as List<dynamic>?)?.map((e) => _deserializeEntry(e)).toList() ?? const [],
      certifications: (map['certifications'] as List<dynamic>?)?.map((e) => _deserializeEntry(e)).toList() ?? const [],
      languages: (map['languages'] as List<dynamic>?)?.map((e) => _deserializeEntry(e)).toList() ?? const [],
    );
  }

  Map<String, dynamic> _serializeEntry(ResumeEntry e) {
    return {
      'id': e.id,
      'title': e.title,
      'subtitle': e.subtitle,
      'location': e.location,
      'startDate': e.startDate,
      'endDate': e.endDate,
      'isCurrent': e.isCurrent,
      'description': e.description,
      'extra': e.extra,
      'url': e.url,
      'proficiency': e.proficiency,
    };
  }

  ResumeEntry _deserializeEntry(dynamic raw) {
    final e = raw as Map<String, dynamic>;
    return ResumeEntry(
      id: e['id'] as String?,
      title: e['title'] as String? ?? '',
      subtitle: e['subtitle'] as String? ?? '',
      location: e['location'] as String? ?? '',
      startDate: e['startDate'] as String? ?? '',
      endDate: e['endDate'] as String? ?? '',
      isCurrent: e['isCurrent'] as bool? ?? false,
      description: e['description'] as String? ?? '',
      extra: e['extra'] as String? ?? '',
      url: e['url'] as String? ?? '',
      proficiency: e['proficiency'] as String? ?? '',
    );
  }
}
