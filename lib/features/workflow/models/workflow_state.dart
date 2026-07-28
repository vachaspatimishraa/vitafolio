import 'package:flutter/material.dart';

/// Represents the current step in the resume workflow.
enum WorkflowStep {
  creating,
  editing,
  previewing,
  templateSelection,
}

/// Immutable model representing the personal information section of a resume.
@immutable
class ResumePersonalInfo {
  final String fullName;
  final String jobTitle;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String country;
  final String linkedIn;
  final String github;
  final String portfolio;

  const ResumePersonalInfo({
    this.fullName = '',
    this.jobTitle = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.linkedIn = '',
    this.github = '',
    this.portfolio = '',
  });

  ResumePersonalInfo copyWith({
    String? fullName,
    String? jobTitle,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? country,
    String? linkedIn,
    String? github,
    String? portfolio,
  }) {
    return ResumePersonalInfo(
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      linkedIn: linkedIn ?? this.linkedIn,
      github: github ?? this.github,
      portfolio: portfolio ?? this.portfolio,
    );
  }
}

/// Immutable model representing a single resume entry.
@immutable
class ResumeEntry {
  final String id;
  final String title;
  final String subtitle;
  final String location;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final String description;
  final String extra;
  final String url;
  final String proficiency;

  const ResumeEntry({
    String? id,
    this.title = '',
    this.subtitle = '',
    this.location = '',
    this.startDate = '',
    this.endDate = '',
    this.isCurrent = false,
    this.description = '',
    this.extra = '',
    this.url = '',
    this.proficiency = '',
  }) : id = id ?? '';

  ResumeEntry copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? location,
    String? startDate,
    String? endDate,
    bool? isCurrent,
    String? description,
    String? extra,
    String? url,
    String? proficiency,
  }) {
    return ResumeEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      description: description ?? this.description,
      extra: extra ?? this.extra,
      url: url ?? this.url,
      proficiency: proficiency ?? this.proficiency,
    );
  }
}

/// The single source of truth for the entire resume workflow.
@immutable
class WorkflowState {
  final ResumePersonalInfo personalInfo;
  final String summary;
  final List<ResumeEntry> education;
  final List<ResumeEntry> experience;
  final List<String> skills;
  final List<ResumeEntry> projects;
  final List<ResumeEntry> certifications;
  final List<ResumeEntry> languages;

  final String? selectedTemplateId;
  final bool hasUnsavedChanges;
  final WorkflowStep currentStep;
  final bool isLoading;
  final bool isValid;

  const WorkflowState({
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
    return const WorkflowState(
      personalInfo: ResumePersonalInfo(),
      summary: '',
      education: [ResumeEntry(id: 'education-0')],
      experience: [ResumeEntry(id: 'experience-0')],
      skills: <String>[],
      projects: [ResumeEntry(id: 'project-0')],
      certifications: [ResumeEntry(id: 'certification-0')],
      languages: [ResumeEntry(id: 'language-0', proficiency: 'Intermediate')],
      selectedTemplateId: null,
      hasUnsavedChanges: false,
      currentStep: WorkflowStep.creating,
      isLoading: false,
      isValid: false,
    );
  }

  WorkflowState copyWith({
    ResumePersonalInfo? personalInfo,
    String? summary,
    List<ResumeEntry>? education,
    List<ResumeEntry>? experience,
    List<String>? skills,
    List<ResumeEntry>? projects,
    List<ResumeEntry>? certifications,
    List<ResumeEntry>? languages,
    String? selectedTemplateId,
    bool? hasUnsavedChanges,
    WorkflowStep? currentStep,
    bool? isLoading,
    bool? isValid,
  }) {
    return WorkflowState(
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
