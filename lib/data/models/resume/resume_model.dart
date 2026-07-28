import '../enums/resume_status.dart';
import '../../../../features/workflow/models/workflow_state.dart';

export '../enums/resume_status.dart';

class ResumeModel {
  final String id;
  final String title;
  final String templateId;
  final String lastUpdated;
  final ResumeStatus status;
  final ResumePersonalInfo personalInfo;
  final String summary;
  final List<ResumeEntry> education;
  final List<ResumeEntry> experience;
  final List<String> skills;
  final List<ResumeEntry> projects;
  final List<ResumeEntry> certifications;
  final List<ResumeEntry> languages;

  const ResumeModel({
    required this.id,
    required this.title,
    this.templateId = 'modern_clean',
    required this.lastUpdated,
    required this.status,
    this.personalInfo = const ResumePersonalInfo(),
    this.summary = '',
    this.education = const [],
    this.experience = const [],
    this.skills = const [],
    this.projects = const [],
    this.certifications = const [],
    this.languages = const [],
  });

  ResumeModel copyWith({
    String? id,
    String? title,
    String? templateId,
    String? lastUpdated,
    ResumeStatus? status,
    ResumePersonalInfo? personalInfo,
    String? summary,
    List<ResumeEntry>? education,
    List<ResumeEntry>? experience,
    List<String>? skills,
    List<ResumeEntry>? projects,
    List<ResumeEntry>? certifications,
    List<ResumeEntry>? languages,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      templateId: templateId ?? this.templateId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      status: status ?? this.status,
      personalInfo: personalInfo ?? this.personalInfo,
      summary: summary ?? this.summary,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
    );
  }
}
