import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart';
import 'package:vitafolio/core/templates/repository/template_repository.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class TemplateSelectionState {
  final List<ResumeTemplate> templates;
  final String selectedTemplateId;
  final bool isLoading;
  final String? errorMessage;

  const TemplateSelectionState({
    required this.templates,
    this.selectedTemplateId = 'ats',
    this.isLoading = false,
    this.errorMessage,
  });

  TemplateSelectionState copyWith({
    List<ResumeTemplate>? templates,
    String? selectedTemplateId,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TemplateSelectionState(
      templates: templates ?? this.templates,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TemplateSelectionViewModel
    extends StateNotifier<TemplateSelectionState> {
  final Ref _ref;
  final GetResume _getResume;
  final UpdateResume _updateResume;
  final TemplateRepository _templateRepo;

  TemplateSelectionViewModel(
    this._ref,
    this._getResume,
    this._updateResume,
    this._templateRepo,
  ) : super(
          TemplateSelectionState(
            templates: _templateRepo.getTemplates(),
            selectedTemplateId: _templateRepo.defaultTemplate().id,
          ),
        ) {
    _init();
  }

  Future<void> _init() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId != null && activeId.value.isNotEmpty) {
      state = state.copyWith(isLoading: true);
      try {
        final resume = await _getResume(activeId);
        final restoredId = (resume != null && resume.selectedTemplateId.value.isNotEmpty)
            ? resume.selectedTemplateId.value
            : _templateRepo.defaultTemplate().id;

        state = state.copyWith(
          selectedTemplateId: restoredId,
          isLoading: false,
        );
      } catch (e) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load template selection',
        );
      }
    } else {
      state = state.copyWith(
        selectedTemplateId: _templateRepo.defaultTemplate().id,
        isLoading: false,
      );
    }
  }

  void selectTemplate(String templateId) {
    state = state.copyWith(
      templates: _templateRepo.getTemplates(),
      selectedTemplateId: templateId,
    );
  }

  Future<bool> saveSelection() async {
    final templateToSave = state.selectedTemplateId;
    state = state.copyWith(
      selectedTemplateId: templateToSave,
      isLoading: true,
      errorMessage: null,
    );

    try {
      final activeId = _ref.read(activeResumeIdProvider);
      // ignore: avoid_print
      print('[TEMPLATE_SELECTION] Selected Template ID to save: $templateToSave');
      // ignore: avoid_print
      print('[TEMPLATE_SELECTION] Active Resume ID: ${activeId?.value}');

      if (activeId != null && activeId.value.isNotEmpty) {
        final resume = await _getResume(activeId);
        if (resume != null) {
          final updatedResume = resume.copyWith(
            selectedTemplateId: TemplateId(templateToSave),
            updatedAt: DateTime.now(),
          );
          await _updateResume(updatedResume);

          // Verification reload from DB
          final reloaded = await _getResume(activeId);
          // ignore: avoid_print
          print('[TEMPLATE_SELECTION_VERIFY] Reloaded Resume ID: ${reloaded?.id.value}');
          // ignore: avoid_print
          print('[TEMPLATE_SELECTION_VERIFY] Reloaded selectedTemplateId: ${reloaded?.selectedTemplateId.value}');

          if (mounted) {
            state = state.copyWith(isLoading: false);
          }
          return true;
        }
      }

      // Fallback: Create active resume if none exists
      final newResume = await _ref.read(createResumeUseCaseProvider).call(
            Resume(
              id: const ResumeId(''),
              title: 'Untitled Resume',
              selectedTemplateId: TemplateId(templateToSave),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
      _ref.read(activeResumeIdProvider.notifier).state = newResume.id;
      // ignore: avoid_print
      print('[TEMPLATE_SELECTION_NEW] Created new Resume ID: ${newResume.id.value} with selectedTemplateId: ${newResume.selectedTemplateId.value}');

      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
      return true;
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to save template selection: ${e.toString()}',
        );
      }
      return false;
    }
  }
}

final templateSelectionViewModelProvider = StateNotifierProvider.autoDispose<
    TemplateSelectionViewModel, TemplateSelectionState>((ref) {
  ref.watch(activeResumeIdProvider);
  final getResume = ref.watch(getResumeUseCaseProvider);
  final updateResume = ref.watch(updateResumeUseCaseProvider);
  final templateRepo = TemplateRepository();
  return TemplateSelectionViewModel(
    ref,
    getResume,
    updateResume,
    templateRepo,
  );
});
