import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../data/models/resume_model.dart';
import '../../../../data/models/embedded/template_selection.dart';
import '../../../../data/repositories/resume_repository.dart';
import '../../../../data/repositories/repository_provider.dart';
import '../../../core/templates/repository/template_repository.dart'
    as core_repo;
import '../../workflow/models/workflow_state.dart';
import '../../workflow/view_model/workflow_view_model.dart';
import 'preview_state.dart';

export 'preview_state.dart';

class PreviewViewModel extends StateNotifier<PreviewState> {
  final Ref _ref;
  final ResumeRepository _repository;
  final core_repo.TemplateRepository _templateRepository;
  final Isar? _isar;
  StreamSubscription? _dbSubscription;

  PreviewViewModel(
    this._ref,
    this._repository, [
    this._isar,
    core_repo.TemplateRepository? templateRepository,
  ]) : _templateRepository =
           templateRepository ?? core_repo.TemplateRepository(),
       super(const PreviewState()) {
    _listenToChanges();
    loadActiveResume();
  }

  void _listenToChanges() {
    // Listen to live database changes from Isar
    if (_isar != null) {
      _dbSubscription = _isar.resumeModels.watchLazy().listen((_) {
        loadActiveResume();
      });
    }

    // Listen to WorkflowViewModel changes for real-time live preview synchronization
    _ref.listen<WorkflowState>(workflowViewModelProvider, (previous, next) {
      final currentResume = state.resume;
      if (currentResume != null) {
        // Here you would sync fields if needed.
        _updateStateWithResume(currentResume);
      }
    });
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadActiveResume([int? resumeId]) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      int? idToLoad = resumeId;

      ResumeModel? resume;
      if (idToLoad != null) {
        resume = await _repository.getResume(idToLoad);
      }

      if (resume == null) {
        final allResumes = await _repository.getAllResumes();
        if (allResumes.isNotEmpty) {
          resume = allResumes.first;
        }
      }

      if (resume != null) {
        _updateStateWithResume(resume);
      } else {
        state = state.copyWith(isLoading: false);
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
    final template = _templateRepository.getTemplate(
      resume.selectedTemplate?.templateId ?? 'ats_professional',
    );
    state = state.copyWith(
      isLoading: false,
      resume: resume,
      selectedTemplate: template,
    );
  }

  Future<void> changeTemplate(String templateId) async {
    final template = _templateRepository.getTemplate(templateId);

    // Update workflow view model
    _ref.read(workflowViewModelProvider.notifier).selectTemplate(templateId);

    ResumeModel? currentResume = state.resume;

    if (currentResume == null) {
      try {
        final allResumes = await _repository.getAllResumes();
        if (allResumes.isNotEmpty) {
          currentResume = allResumes.first;
        }
      } catch (_) {}
    }

    if (currentResume != null) {
      try {
        currentResume.selectedTemplate = TemplateSelection()
          ..templateId = templateId;
        await _repository.updateResume(currentResume);
      } catch (e) {
        state = state.copyWith(
          isError: true,
          errorMessage: 'Failed to save template selection: ${e.toString()}',
        );
      }
    } else {
      final newResume = ResumeModel(
        resumeName: 'My Resume',
        selectedTemplate: TemplateSelection()..templateId = templateId,
      );
      try {
        final created = await _repository.createResume(newResume);
        currentResume = created;
      } catch (_) {}
    }

    state = state.copyWith(resume: currentResume, selectedTemplate: template);
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
      final isar = ref.watch(isarProvider);
      return PreviewViewModel(ref, repository, isar);
    });
