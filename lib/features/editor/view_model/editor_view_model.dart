import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/resume/resume_model.dart' as domain;
import '../../../../features/workflow/models/workflow_state.dart';
import '../../../../features/workflow/view_model/workflow_view_model.dart';
import '../../../../data/repositories/resume_repository.dart';
import '../../../../data/repositories/repository_provider.dart';
import '../services/autosave_service.dart';
import 'editor_state.dart';

export 'editor_state.dart';

class EditorViewModel extends StateNotifier<EditorState> {
  final Ref _ref;
  final ResumeRepository _repository;
  late final AutoSaveService _autoSaveService;

  EditorViewModel(this._ref, this._repository) : super(const EditorState()) {
    _autoSaveService = AutoSaveService(onSave: _performSave);

    // Watch workflow changes and trigger auto-save when editing and changes occur
    _ref.listen<WorkflowState>(workflowViewModelProvider, (previous, next) {
      if (next.currentStep == WorkflowStep.editing && next.hasUnsavedChanges) {
        _onWorkflowChanged();
      }
    });
  }

  void _onWorkflowChanged() {
    state = state.copyWith(
      saveStatus: SaveStatus.unsaved,
      hasUnsavedChanges: true,
    );
    _autoSaveService.trigger();
  }

  Future<void> loadResume(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      final resume = await _repository.getResume(id);
      if (resume != null) {
        state = state.copyWith(
          resume: resume,
          isLoading: false,
          saveStatus: SaveStatus.saved,
          hasUnsavedChanges: false,
        );
        _ref.read(workflowViewModelProvider.notifier).loadExistingResume(resume);
      } else {
        state = state.copyWith(
          isLoading: false,
          saveStatus: SaveStatus.error,
          errorMessage: 'Resume not found',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        saveStatus: SaveStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> createNewDraft() async {
    state = state.copyWith(isLoading: true);
    try {
      final newResume = domain.ResumeModel(
        id: '',
        title: 'Untitled Resume',
        lastUpdated: DateTime.now().toIso8601String(),
        status: domain.ResumeStatus.draft,
      );
      final created = await _repository.createResume(newResume);
      state = state.copyWith(
        resume: created,
        isLoading: false,
        saveStatus: SaveStatus.saved,
        hasUnsavedChanges: false,
      );
      _ref.read(workflowViewModelProvider.notifier).loadExistingResume(created);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        saveStatus: SaveStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _performSave() async {
    final workflowState = _ref.read(workflowViewModelProvider);
    final currentResume = state.resume;
    if (currentResume == null) return;

    final updatedResume = currentResume.copyWith(
      personalInfo: workflowState.personalInfo,
      summary: workflowState.summary,
      education: workflowState.education,
      experience: workflowState.experience,
      skills: workflowState.skills,
      projects: workflowState.projects,
      certifications: workflowState.certifications,
      languages: workflowState.languages,
      templateId: workflowState.selectedTemplateId ?? 'modern_clean',
    );

    // Optimization: Skip database writes if data is unchanged
    if (!_hasChanges(updatedResume, currentResume)) {
      state = state.copyWith(
        saveStatus: SaveStatus.saved,
        hasUnsavedChanges: false,
      );
      _ref.read(workflowViewModelProvider.notifier).markUnsavedChanges(false);
      return;
    }

    state = state.copyWith(saveStatus: SaveStatus.saving);

    try {
      await _repository.updateResume(updatedResume);
      _ref.read(workflowViewModelProvider.notifier).markUnsavedChanges(false);
      state = state.copyWith(
        resume: updatedResume,
        saveStatus: SaveStatus.saved,
        hasUnsavedChanges: false,
      );
    } catch (e) {
      state = state.copyWith(
        saveStatus: SaveStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  bool _hasChanges(domain.ResumeModel updated, domain.ResumeModel current) {
    if (updated.title != current.title) return true;
    if (updated.templateId != current.templateId) return true;
    if (updated.summary != current.summary) return true;
    if (updated.status != current.status) return true;
    if (!_isPersonalInfoEqual(updated.personalInfo, current.personalInfo)) return true;
    if (!_isEntryListEqual(updated.education, current.education)) return true;
    if (!_isEntryListEqual(updated.experience, current.experience)) return true;
    if (!_isEntryListEqual(updated.projects, current.projects)) return true;
    if (!_isEntryListEqual(updated.certifications, current.certifications)) return true;
    if (!_isEntryListEqual(updated.languages, current.languages)) return true;
    if (!_isStringListEqual(updated.skills, current.skills)) return true;
    return false;
  }

  bool _isPersonalInfoEqual(ResumePersonalInfo a, ResumePersonalInfo b) {
    return a.fullName == b.fullName &&
        a.jobTitle == b.jobTitle &&
        a.email == b.email &&
        a.phone == b.phone &&
        a.address == b.address &&
        a.city == b.city &&
        a.state == b.state &&
        a.country == b.country &&
        a.linkedIn == b.linkedIn &&
        a.github == b.github &&
        a.portfolio == b.portfolio;
  }

  bool _isEntryListEqual(List<ResumeEntry> a, List<ResumeEntry> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      final x = a[i];
      final y = b[i];
      if (x.id != y.id ||
          x.title != y.title ||
          x.subtitle != y.subtitle ||
          x.location != y.location ||
          x.startDate != y.startDate ||
          x.endDate != y.endDate ||
          x.isCurrent != y.isCurrent ||
          x.description != y.description ||
          x.extra != y.extra ||
          x.url != y.url ||
          x.proficiency != y.proficiency) {
        return false;
      }
    }
    return true;
  }

  bool _isStringListEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool validate() {
    final workflowState = _ref.read(workflowViewModelProvider);
    final errors = <String>[];

    if (state.resume?.title.trim().isEmpty ?? true) {
      errors.add('Resume name is required');
    }
    if (workflowState.personalInfo.fullName.trim().isEmpty) {
      errors.add('Full name is required');
    }
    if (workflowState.personalInfo.email.trim().isEmpty) {
      errors.add('Email is required');
    }

    state = state.copyWith(validationErrors: errors);
    return errors.isEmpty;
  }

  Future<void> renameActiveResume(String newName) async {
    final currentResume = state.resume;
    if (currentResume == null) return;

    final updated = currentResume.copyWith(title: newName);
    state = state.copyWith(
      resume: updated,
      saveStatus: SaveStatus.unsaved,
      hasUnsavedChanges: true,
    );
    
    // Auto-save handles renaming immediately
    _autoSaveService.trigger();
  }

  Future<void> resetState() async {
    await createNewDraft();
  }

  @override
  void dispose() {
    _autoSaveService.dispose();
    super.dispose();
  }
}

final editorViewModelProvider =
    StateNotifierProvider<EditorViewModel, EditorState>((ref) {
  final repository = ref.watch(resumeRepositoryProvider);
  return EditorViewModel(ref, repository);
});
