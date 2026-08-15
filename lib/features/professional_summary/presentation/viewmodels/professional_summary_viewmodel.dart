import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class ProfessionalSummaryState {
  final String summary;
  final bool isLoading;
  final String? errorMessage;

  const ProfessionalSummaryState({
    this.summary = '',
    this.isLoading = false,
    this.errorMessage,
  });

  ProfessionalSummaryState copyWith({
    String? summary,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfessionalSummaryState(
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ProfessionalSummaryViewModel extends StateNotifier<ProfessionalSummaryState> {
  final Ref _ref;
  final GetResume _getResume;
  final UpdateResume _updateResume;

  ProfessionalSummaryViewModel(this._ref, this._getResume, this._updateResume)
      : super(const ProfessionalSummaryState()) {
    _load();
  }

  Future<void> _load() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final resume = await _getResume(activeId);
      if (resume != null && resume.summary != null) {
        state = state.copyWith(
          summary: resume.summary!.summaryText,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load summary',
      );
    }
  }

  void setSummary(String newSummary) {
    state = state.copyWith(summary: newSummary);
  }

  void useSampleSummary() {
    const sample =
        'Results-driven Software Engineer with over 4 years of experience building high-performance web and mobile applications. Proven expertise in Flutter, Dart, RESTful APIs, and Agile methodologies.';
    state = state.copyWith(summary: sample);
  }

  Future<bool> save() async {
    state = state.copyWith(isLoading: true);
    try {
      final activeId = _ref.read(activeResumeIdProvider);
      Resume? resume;
      if (activeId != null && activeId.value.isNotEmpty) {
        resume = await _getResume(activeId);
      }

      final summaryEntity = ProfessionalSummary(summaryText: state.summary);

      if (resume != null) {
        final updatedResume = resume.copyWith(
          summary: summaryEntity,
          updatedAt: DateTime.now(),
        );
        await _updateResume(updatedResume);
      } else {
        final newResume = await _ref.read(createResumeUseCaseProvider).call(
              Resume(
                id: const ResumeId(''),
                title: 'Untitled Resume',
                selectedTemplateId: const TemplateId('modern_clean'),
                summary: summaryEntity,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
        _ref.read(activeResumeIdProvider.notifier).state = newResume.id;
      }
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
      return true;
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to save summary',
        );
      }
      return false;
    }
  }
}

final professionalSummaryViewModelProvider = StateNotifierProvider.autoDispose<
    ProfessionalSummaryViewModel, ProfessionalSummaryState>((ref) {
  ref.watch(activeResumeIdProvider);
  final getResume = ref.watch(getResumeUseCaseProvider);
  final updateResume = ref.watch(updateResumeUseCaseProvider);
  return ProfessionalSummaryViewModel(ref, getResume, updateResume);
});
