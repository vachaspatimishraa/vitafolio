import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/resume_model.dart';
import '../../../data/models/embedded/personal_information.dart';
import '../../../data/models/embedded/education_model.dart';
import '../../../data/models/embedded/experience_model.dart';
import '../../../data/models/embedded/project_model.dart';
import '../../../data/models/embedded/certification_model.dart';
import '../../../data/models/embedded/language_model.dart';

@immutable
class EditorState {
  final String resumeName;
  final PersonalInformation personalInfo;
  final String summary;
  final List<EducationModel> education;
  final List<ExperienceModel> experience;
  final List<String> skills;
  final List<ProjectModel> projects;
  final List<CertificationModel> certifications;
  final List<LanguageModel> languages;
  final bool hasUnsavedChanges;
  final bool isValid;

  const EditorState({
    required this.resumeName,
    required this.personalInfo,
    required this.summary,
    required this.education,
    required this.experience,
    required this.skills,
    required this.projects,
    required this.certifications,
    required this.languages,
    required this.hasUnsavedChanges,
    required this.isValid,
  });

  factory EditorState.initial() {
    return EditorState(
      resumeName: '',
      personalInfo: PersonalInformation(),
      summary: '',
      education: [EducationModel(id: 'education-0')],
      experience: [ExperienceModel(id: 'experience-0')],
      skills: [],
      projects: [ProjectModel(id: 'project-0')],
      certifications: [CertificationModel(id: 'certification-0')],
      languages: [LanguageModel(id: 'language-0')],
      hasUnsavedChanges: false,
      isValid: false,
    );
  }

  EditorState copyWith({
    String? resumeName,
    PersonalInformation? personalInfo,
    String? summary,
    List<EducationModel>? education,
    List<ExperienceModel>? experience,
    List<String>? skills,
    List<ProjectModel>? projects,
    List<CertificationModel>? certifications,
    List<LanguageModel>? languages,
    bool? hasUnsavedChanges,
    bool? isValid,
  }) {
    return EditorState(
      resumeName: resumeName ?? this.resumeName,
      personalInfo: personalInfo ?? this.personalInfo,
      summary: summary ?? this.summary,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      isValid: isValid ?? this.isValid,
    );
  }
}

class EditorViewModel extends StateNotifier<EditorState> {
  EditorViewModel() : super(EditorState.initial());

  void loadResume(ResumeModel resume) {
    state = state.copyWith(
      resumeName: resume.resumeName ?? '',
      personalInfo: resume.personalInfo ?? PersonalInformation(),
      summary: resume.professionalSummary?.summary ?? '',
      education: resume.education ?? [EducationModel()],
      experience: resume.experience ?? [ExperienceModel()],
      skills: resume.skills?.map((s) => s.name ?? '').toList() ?? [],
      projects: resume.projects ?? [ProjectModel()],
      certifications: resume.certifications ?? [CertificationModel()],
      languages: resume.languages ?? [LanguageModel()],
      hasUnsavedChanges: false,
    );
  }

  bool isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
  }

  bool isValidUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return true;
    }
    final uri = Uri.tryParse(trimmed);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  bool isValidPhone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return true;
    }
    return RegExp(r'^[0-9+()\-\s]{7,}$').hasMatch(trimmed);
  }

  void resetState() {
    state = EditorState.initial();
  }
}

final editorViewModelProvider =
    StateNotifierProvider<EditorViewModel, EditorState>((ref) {
      return EditorViewModel();
    });
