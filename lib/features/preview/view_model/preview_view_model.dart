import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:vitafolio/core/database/database_provider.dart';
import 'package:vitafolio/core/templates/repository/template_repository.dart'
    as core_repo;
import 'package:vitafolio/features/preview/view_model/preview_state.dart';
import 'package:vitafolio/features/resume/data/models/resume_model.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

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
    if (_isar != null) {
      _dbSubscription = _isar.collection<ResumeDbModel>().watchLazy().listen((
        _,
      ) {
        loadActiveResume();
      });
    }

    _ref.listen<ResumeId?>(activeResumeIdProvider, (previous, next) {
      if (previous != next) {
        loadActiveResume();
      }
    });
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadActiveResume([ResumeId? overrideId]) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final activeId = overrideId ?? _ref.read(activeResumeIdProvider);

      Resume? targetResume;
      if (activeId != null) {
        targetResume = await _repository.getResume(activeId);
      } else {
        final allResumes = await _repository.getAllResumes();
        if (allResumes.isNotEmpty) {
          targetResume = allResumes.first;
          _ref.read(activeResumeIdProvider.notifier).state = targetResume.id;
        }
      }

      if (targetResume != null) {
        final templateIdStr = targetResume.selectedTemplateId.value;
        final template = _templateRepository.getTemplate(templateIdStr);

        // ignore: avoid_print
        print('[PREVIEW] Active Resume ID: ${activeId?.value}');
        // ignore: avoid_print
        print('[PREVIEW] Target Resume ID: ${targetResume.id.value}');
        // ignore: avoid_print
        print('[PREVIEW] Loaded selectedTemplateId: $templateIdStr');
        // ignore: avoid_print
        print('[PREVIEW] Resolved Template ID: ${template.id}');
        // ignore: avoid_print
        print('[PREVIEW] Resolved Template Name: ${template.name}');

        state = state.copyWith(
          isLoading: false,
          resume: targetResume,
          selectedTemplate: template,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          resume: null,
          selectedTemplate: _templateRepository.defaultTemplate(),
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

  Future<void> changeTemplate(String templateId) async {
    final currentResume = state.resume;
    if (currentResume == null) return;

    try {
      final updated = await _repository.saveSelectedTemplate(
        currentResume.id,
        TemplateId(templateId),
      );
      final template = _templateRepository.getTemplate(templateId);
      state = state.copyWith(resume: updated, selectedTemplate: template);
    } catch (e) {
      state = state.copyWith(
        isError: true,
        errorMessage: 'Failed to save template selection: ${e.toString()}',
      );
    }
  }

  void setScale(double newScale) {
    if (newScale < 0.5 || newScale > 3.0) return;
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
    StateNotifierProvider.autoDispose<PreviewViewModel, PreviewState>((ref) {
      final repository = ref.watch(cleanResumeRepositoryProvider);
      final isar = ref.watch(isarProvider);
      return PreviewViewModel(ref, repository, isar);
    });
