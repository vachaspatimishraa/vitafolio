import 'package:flutter/material.dart';
import '../../../data/models/embedded/personal_information.dart';
import '../../../data/models/embedded/education_model.dart';
import '../../../data/models/embedded/experience_model.dart';
import '../../../data/models/embedded/project_model.dart';
import '../../../data/models/embedded/certification_model.dart';
import '../../../data/models/embedded/language_model.dart';

/// Represents the current step in the resume workflow.
enum WorkflowStep { creating, editing, previewing, templateSelection }

/// The single source of truth for the entire resume workflow.
@immutable
class WorkflowState {
  final String resumeName;
  final PersonalInformation personalInfo;
  final String summary;
  final List<EducationModel> education;
  final List<ExperienceModel> experience;
  final List<String> skills;
  final List<ProjectModel> projects;
  final List<CertificationModel> certifications;
  final List<LanguageModel> languages;

  final String? selectedTemplateId;
  final bool hasUnsavedChanges;
  final WorkflowStep currentStep;
  final bool isLoading;
  final bool isValid;

  const WorkflowState({
    this.resumeName = '',
    required this.personalInfo,
    required this.summary,
    required this.education,
    required this.experience,
    required this.skills,
    required this.projects,
    required this.certifications,
    required this.languages,
    this.selectedTemplateId,
    this.hasUnsavedChanges = false,
    this.currentStep = WorkflowStep.creating,
    this.isLoading = false,
    this.isValid = false,
  });

  factory WorkflowState.initial() {
    return WorkflowState(
      resumeName: '',
      personalInfo: PersonalInformation(),
      summary: '',
      education: [EducationModel(id: 'education-0')],
      experience: [ExperienceModel(id: 'experience-0')],
      skills: <String>[],
      projects: [ProjectModel(id: 'project-0')],
      certifications: [CertificationModel(id: 'certification-0')],
      languages: [LanguageModel(id: 'language-0')],
      selectedTemplateId: 'modern_clean',
      hasUnsavedChanges: false,
      currentStep: WorkflowStep.creating,
      isLoading: false,
      isValid: false,
    );
  }

  WorkflowState copyWith({
    String? resumeName,
    PersonalInformation? personalInfo,
    String? summary,
    List<EducationModel>? education,
    List<ExperienceModel>? experience,
    List<String>? skills,
    List<ProjectModel>? projects,
    List<CertificationModel>? certifications,
    List<LanguageModel>? languages,
    String? selectedTemplateId,
    bool? hasUnsavedChanges,
    WorkflowStep? currentStep,
    bool? isLoading,
    bool? isValid,
  }) {
    return WorkflowState(
      resumeName: resumeName ?? this.resumeName,
      personalInfo: personalInfo ?? this.personalInfo,
      summary: summary ?? this.summary,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
    );
  }
}
