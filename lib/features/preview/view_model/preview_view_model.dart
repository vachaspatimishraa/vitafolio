import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:vitafolio/core/database/database_provider.dart';
import 'package:vitafolio/data/models/resume_model.dart';
import 'package:vitafolio/data/models/embedded/professional_summary.dart';
import 'package:vitafolio/data/models/embedded/skill_model.dart';
import 'package:vitafolio/data/models/embedded/template_selection.dart';
import 'package:vitafolio/data/repositories/resume_repository.dart';
import 'package:vitafolio/data/repositories/repository_provider.dart';
import 'package:vitafolio/core/templates/repository/template_repository.dart'
    as core_repo;
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';
import 'package:vitafolio/features/preview/view_model/preview_state.dart';

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
      final workflowState = _ref.read(workflowViewModelProvider);
      final int? idToLoad = resumeId ?? workflowState.resumeId;

      ResumeModel? resume;
      if (idToLoad != null) {
        resume = await _repository.getResume(idToLoad);
      }

      if (resume != null) {
        _updateStateWithResume(resume);
      } else {
        final template = _templateRepository.getTemplate(
          workflowState.selectedTemplateId ?? 'ats_professional',
        );
        final unsavedResume = ResumeModel(
          resumeName: workflowState.resumeName.isNotEmpty
              ? workflowState.resumeName
              : 'My Resume',
          personalInfo: workflowState.personalInfo,
          professionalSummary: ProfessionalSummary()
            ..summary = workflowState.summary,
          education: workflowState.education,
          experience: workflowState.experience,
          skills: workflowState.skills
              .map((s) => SkillModel()..name = s)
              .toList(),
          projects: workflowState.projects,
          certifications: workflowState.certifications,
          languages: workflowState.languages,
          selectedTemplate: TemplateSelection()
            ..templateId =
                workflowState.selectedTemplateId ?? 'ats_professional',
        );
        state = state.copyWith(
          isLoading: false,
          resume: unsavedResume,
          selectedTemplate: template,
        );
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
    final workflowState = _ref.read(workflowViewModelProvider);

    final int? targetId = workflowState.resumeId ?? state.resume?.id;
    ResumeModel? currentResume;
    if (targetId != null) {
      currentResume = await _repository.getResume(targetId);
    }

    if (currentResume != null) {
      try {
        currentResume.selectedTemplate = TemplateSelection()
          ..templateId = templateId;
        // Preserve current user-entered section data from workflow or existing resume
        if (workflowState.personalInfo.fullName?.isNotEmpty ?? false) {
          currentResume.personalInfo = workflowState.personalInfo;
        }
        if (workflowState.summary.isNotEmpty) {
          currentResume.professionalSummary = ProfessionalSummary()
            ..summary = workflowState.summary;
        }
        if (workflowState.education.isNotEmpty) {
          currentResume.education = workflowState.education;
        }
        if (workflowState.experience.isNotEmpty) {
          currentResume.experience = workflowState.experience;
        }
        if (workflowState.skills.isNotEmpty) {
          currentResume.skills = workflowState.skills
              .map((s) => SkillModel()..name = s)
              .toList();
        }
        if (workflowState.projects.isNotEmpty) {
          currentResume.projects = workflowState.projects;
        }
        if (workflowState.certifications.isNotEmpty) {
          currentResume.certifications = workflowState.certifications;
        }
        if (workflowState.languages.isNotEmpty) {
          currentResume.languages = workflowState.languages;
        }

        await _repository.updateResume(currentResume);
      } catch (e) {
        state = state.copyWith(
          isError: true,
          errorMessage: 'Failed to save template selection: ${e.toString()}',
        );
      }
    } else {
      final newResume = ResumeModel(
        resumeName: workflowState.resumeName.isNotEmpty
            ? workflowState.resumeName
            : 'My Resume',
        personalInfo: workflowState.personalInfo,
        professionalSummary: ProfessionalSummary()
          ..summary = workflowState.summary,
        education: workflowState.education,
        experience: workflowState.experience,
        skills: workflowState.skills
            .map((s) => SkillModel()..name = s)
            .toList(),
        projects: workflowState.projects,
        certifications: workflowState.certifications,
        languages: workflowState.languages,
        selectedTemplate: TemplateSelection()..templateId = templateId,
      );
      try {
        final created = await _repository.createResume(newResume);
        currentResume = created;
        _ref.read(workflowViewModelProvider.notifier).setResumeId(created.id);
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
