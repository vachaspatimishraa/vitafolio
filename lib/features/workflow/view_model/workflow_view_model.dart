import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/resume_model.dart';
import '../../../data/models/embedded/personal_information.dart';
import '../../../data/models/embedded/education_model.dart';
import '../../../data/models/embedded/experience_model.dart';
import '../../../data/models/embedded/project_model.dart';
import '../../../data/models/embedded/certification_model.dart';
import '../../../data/models/embedded/language_model.dart';
import '../models/workflow_state.dart';

class WorkflowViewModel extends StateNotifier<WorkflowState> {
  WorkflowViewModel() : super(WorkflowState.initial());

  static const int summaryCharacterLimit = 500;

  static const List<String> skillSuggestions = <String>[
    'Flutter',
    'Dart',
    'Riverpod',
    'Firebase',
    'Python',
    'REST APIs',
    'Git',
    'Figma',
  ];

  void createNewResume() {
    state = WorkflowState.initial();
  }

  void loadExistingResume(ResumeModel resume) {
    state = state.copyWith(
      resumeName: resume.resumeName ?? '',
      personalInfo: resume.personalInfo ?? PersonalInformation(),
      summary: resume.professionalSummary?.summary ?? '',
      education: resume.education ?? [],
      experience: resume.experience ?? [],
      skills: resume.skills?.map((s) => s.name ?? '').toList() ?? [],
      projects: resume.projects ?? [],
      certifications: resume.certifications ?? [],
      languages: resume.languages ?? [],
      selectedTemplateId: resume.selectedTemplate?.templateId,
      hasUnsavedChanges: false,
      currentStep: WorkflowStep.editing,
    );
  }

  void updateResumeName(String name) {
    state = state.copyWith(resumeName: name, hasUnsavedChanges: true);
  }

  void updatePersonalInfo(PersonalInformation info) {
    state = state.copyWith(personalInfo: info, hasUnsavedChanges: true);
  }

  void updateSummary(String summary) {
    state = state.copyWith(summary: summary, hasUnsavedChanges: true);
  }

  void updateEducation(int index, EducationModel entry) {
    final list = [...state.education];
    list[index] = entry;
    state = state.copyWith(education: list, hasUnsavedChanges: true);
  }

  void addEducation() {
    state = state.copyWith(
      education: [
        ...state.education,
        EducationModel(id: 'education-${state.education.length}'),
      ],
      hasUnsavedChanges: true,
    );
  }

  void removeEducation(int index) {
    if (state.education.length <= 1) return;
    final list = [...state.education]..removeAt(index);
    state = state.copyWith(education: list, hasUnsavedChanges: true);
  }

  void updateExperience(int index, ExperienceModel entry) {
    final list = [...state.experience];
    list[index] = entry;
    state = state.copyWith(experience: list, hasUnsavedChanges: true);
  }

  void addExperience() {
    state = state.copyWith(
      experience: [
        ...state.experience,
        ExperienceModel(id: 'experience-${state.experience.length}'),
      ],
      hasUnsavedChanges: true,
    );
  }

  void removeExperience(int index) {
    if (state.experience.length <= 1) return;
    final list = [...state.experience]..removeAt(index);
    state = state.copyWith(experience: list, hasUnsavedChanges: true);
  }

  void updateProject(int index, ProjectModel entry) {
    final list = [...state.projects];
    list[index] = entry;
    state = state.copyWith(projects: list, hasUnsavedChanges: true);
  }

  void addProject() {
    state = state.copyWith(
      projects: [
        ...state.projects,
        ProjectModel(id: 'project-${state.projects.length}'),
      ],
      hasUnsavedChanges: true,
    );
  }

  void removeProject(int index) {
    if (state.projects.length <= 1) return;
    final list = [...state.projects]..removeAt(index);
    state = state.copyWith(projects: list, hasUnsavedChanges: true);
  }

  void updateCertification(int index, CertificationModel entry) {
    final list = [...state.certifications];
    list[index] = entry;
    state = state.copyWith(certifications: list, hasUnsavedChanges: true);
  }

  void addCertification() {
    state = state.copyWith(
      certifications: [
        ...state.certifications,
        CertificationModel(id: 'certification-${state.certifications.length}'),
      ],
      hasUnsavedChanges: true,
    );
  }

  void removeCertification(int index) {
    if (state.certifications.length <= 1) return;
    final list = [...state.certifications]..removeAt(index);
    state = state.copyWith(certifications: list, hasUnsavedChanges: true);
  }

  void updateLanguage(int index, LanguageModel entry) {
    final list = [...state.languages];
    list[index] = entry;
    state = state.copyWith(languages: list, hasUnsavedChanges: true);
  }

  void addLanguage() {
    state = state.copyWith(
      languages: [
        ...state.languages,
        LanguageModel(id: 'language-${state.languages.length}'),
      ],
      hasUnsavedChanges: true,
    );
  }

  void removeLanguage(int index) {
    if (state.languages.length <= 1) return;
    final list = [...state.languages]..removeAt(index);
    state = state.copyWith(languages: list, hasUnsavedChanges: true);
  }

  void addSkill(String skill) {
    if (skill.trim().isEmpty || state.skills.contains(skill)) return;
    state = state.copyWith(
      skills: [...state.skills, skill],
      hasUnsavedChanges: true,
    );
  }

  void removeSkill(String skill) {
    final list = [...state.skills]..remove(skill);
    state = state.copyWith(skills: list, hasUnsavedChanges: true);
  }

  void selectTemplate(String templateId) {
    state = state.copyWith(
      selectedTemplateId: templateId,
      hasUnsavedChanges: true,
    );
  }

  void markUnsavedChanges(bool value) {
    state = state.copyWith(hasUnsavedChanges: value);
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidUrl(String url) {
    if (url.trim().isEmpty) return true;
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  bool isValidPhone(String phone) {
    if (phone.trim().isEmpty) return true;
    return RegExp(r'^\+?[0-9\s-]{7,15}$').hasMatch(phone.trim());
  }

  void resetState() {
    state = WorkflowState.initial();
  }
}

final workflowViewModelProvider =
    StateNotifierProvider<WorkflowViewModel, WorkflowState>((ref) {
      return WorkflowViewModel();
    });
