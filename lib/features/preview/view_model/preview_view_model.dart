import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../data/models/resume/resume_model.dart';
import '../../../../data/models/resume_model.dart' as db;
import '../../editor/view_model/editor_view_model.dart';
import '../../../../data/repositories/repository_provider.dart';
import '../../../../data/repositories/resume_repository.dart';
import '../../templates/models/template_model.dart';
import '../../templates/repository/template_repository.dart';
import '../../workflow/models/workflow_state.dart';
import '../../workflow/view_model/workflow_view_model.dart';
import '../renderers/renderer_factory.dart';
import 'preview_state.dart';

export 'preview_state.dart';

class PreviewViewModel extends StateNotifier<PreviewState> {
  final Ref _ref;
  final ResumeRepository _repository;
  final RendererFactory _rendererFactory;
  final Isar? _isar;
  StreamSubscription? _dbSubscription;

  PreviewViewModel(
    this._ref,
    this._repository, [
    this._isar,
    RendererFactory? rendererFactory,
  ])  : _rendererFactory = rendererFactory ?? RendererFactory(),
        super(const PreviewState()) {
    _listenToChanges();
    loadActiveResume();
  }

  void _listenToChanges() {
    // Listen to live database changes from Isar
    if (_isar != null) {
      _dbSubscription = _isar!.resumeModels.watchLazy().listen((_) {
        loadActiveResume();
      });
    }

    // Listen to EditorViewModel state changes to reflect active edits live
    _ref.listen<EditorState>(editorViewModelProvider, (previous, next) {
      if (next.resume != null) {
        final currentResume = state.resume;
        if (currentResume == null || currentResume.id == next.resume!.id) {
          _updateStateWithResume(next.resume!);
        }
      }
    });

    // Listen to WorkflowViewModel changes for real-time live preview synchronization
    _ref.listen<WorkflowState>(workflowViewModelProvider, (previous, next) {
      final currentResume = state.resume;
      if (currentResume != null) {
        final updatedResume = currentResume.copyWith(
          personalInfo: next.personalInfo,
          summary: next.summary,
          education: next.education,
          experience: next.experience,
          skills: next.skills,
          projects: next.projects,
          certifications: next.certifications,
          languages: next.languages,
          templateId: next.selectedTemplateId ?? currentResume.templateId,
        );
        _updateStateWithResume(updatedResume);
      }
    });
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadActiveResume([String? resumeId]) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      String? idToLoad = resumeId;
      if (idToLoad == null || idToLoad.isEmpty) {
        final activeEditorResume = _ref.read(editorViewModelProvider).resume;
        idToLoad = activeEditorResume?.id;
      }

      ResumeModel? resume;
      if (idToLoad != null && idToLoad.isNotEmpty) {
        resume = await _repository.getResume(idToLoad);
      }

      if (resume == null) {
        // Fallback: try loading all resumes and pick the most recent one
        final allResumes = await _repository.getAllResumes();
        if (allResumes.isNotEmpty) {
          allResumes.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
          resume = allResumes.first;
        }
      }

      if (resume != null) {
        _updateStateWithResume(resume);
      } else {
        // Create initial fallback empty preview state if no resume exists in DB yet
        final fallbackResume = ResumeModel(
          id: '',
          title: 'Draft Resume',
          templateId: 'modern_clean',
          status: ResumeStatus.draft,
          lastUpdated: DateTime.now().toIso8601String(),
        );
        _updateStateWithResume(fallbackResume);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      );
    }
  }

  void _updateStateWithResume(ResumeModel resume) {
    final template = _rendererFactory.getTemplate(resume.templateId);
    state = state.copyWith(
      isLoading: false,
      resume: resume,
      selectedTemplate: template,
    );
  }

  Future<void> changeTemplate(String templateId) async {
    final currentResume = state.resume;
    final template = _rendererFactory.getTemplate(templateId);

    state = state.copyWith(selectedTemplate: template);

    // Update workflow view model
    _ref.read(workflowViewModelProvider.notifier).selectTemplate(templateId);

    // Persist template selection to Isar if resume has an ID
    if (currentResume != null && currentResume.id.isNotEmpty) {
      try {
        await _repository.updateSelectedTemplate(currentResume.id, templateId);
        final updatedResume = currentResume.copyWith(templateId: templateId);
        state = state.copyWith(resume: updatedResume);
      } catch (e) {
        state = state.copyWith(
          isError: true,
          errorMessage: 'Failed to save template selection: ${e.toString()}',
        );
      }
    }
  }

  void setScale(double newScale) {
    if (newScale < 0.5) return;
    if (newScale > 3.0) return;
    state = state.copyWith(scale: newScale);
  }

  void resetScale() {
    state = state.copyWith(scale: 1.0);
  }

  void zoomIn() {
    setScale(state.scale + 0.25);
  }

  void zoomOut() {
    setScale(state.scale - 0.25);
  }
}

final previewViewModelProvider =
    StateNotifierProvider<PreviewViewModel, PreviewState>((ref) {
  final repository = ref.watch(resumeRepositoryProvider);
  Isar? isar;
  try {
    isar = ref.watch(isarProvider);
  } catch (_) {}
  return PreviewViewModel(ref, repository, isar);
});
