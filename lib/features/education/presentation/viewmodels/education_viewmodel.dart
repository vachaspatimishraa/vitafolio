import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class MockEducationItem {
  final String id;
  final String degree;
  final String fieldOfStudy;
  final String institution;
  final String dateRange;
  final String grade;
  final String description;

  const MockEducationItem({
    required this.id,
    required this.degree,
    required this.fieldOfStudy,
    required this.institution,
    required this.dateRange,
    required this.grade,
    required this.description,
  });

  factory MockEducationItem.fromDomain(Education domain) {
    final range = DateRangeFormatter.formatEducation(
      startYear: domain.startYear,
      endYear: domain.endYear,
      isCurrentlyStudying: domain.isCurrentlyStudying,
      separator: ' - ',
    );
    return MockEducationItem(
      id: domain.id,
      degree: domain.degree,
      fieldOfStudy: domain.fieldOfStudy,
      institution: domain.institution,
      dateRange: range,
      grade: domain.grade ?? '',
      description: '', // If domain entity has description, map it here
    );
  }

  Education toDomain() {
    final isPursuing = dateRange.contains('Pursuing') || dateRange.contains('Present');
    String start = '';
    String end = '';
    if (dateRange.contains(' - ')) {
      final dates = dateRange.split(' - ');
      start = dates[0].trim();
      end = dates.length > 1 ? dates[1].trim() : '';
    } else if (dateRange.contains(' – ')) {
      final dates = dateRange.split(' – ');
      start = dates[0].trim();
      end = dates.length > 1 ? dates[1].trim() : '';
    } else {
      if (isPursuing) {
        start = dateRange.replaceAll('Pursuing', '').replaceAll('Present', '').trim();
      } else {
        start = dateRange.trim();
      }
    }

    return Education(
      id: id,
      degree: degree,
      fieldOfStudy: fieldOfStudy,
      institution: institution,
      location: '', // Add location if needed
      startYear: start,
      endYear: isPursuing ? '' : end,
      grade: grade,
      isCurrentlyStudying: isPursuing,
    );
  }
}

class EducationListState {
  final List<MockEducationItem> educations;
  final bool isLoading;
  final String? errorMessage;

  const EducationListState({
    this.educations = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  EducationListState copyWith({
    List<MockEducationItem>? educations,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EducationListState(
      educations: educations ?? this.educations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class EducationViewModel extends StateNotifier<EducationListState> {
  final Ref _ref;
  final GetResume _getResume;
  final UpdateResume _updateResume;

  EducationViewModel(this._ref, this._getResume, this._updateResume)
      : super(const EducationListState()) {
    _load();
  }

  Future<void> _load() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final resume = await _getResume(activeId);
      if (resume != null) {
        state = state.copyWith(
          educations: resume.educations
              .map(MockEducationItem.fromDomain)
              .toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load education',
      );
    }
  }

  Future<void> _save() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId == null) return;

    try {
      final resume = await _getResume(activeId);
      if (resume != null) {
        final updatedResume = resume.copyWith(
          educations: state.educations.map((e) => e.toDomain()).toList(),
          updatedAt: DateTime.now(),
        );
        await _updateResume(updatedResume);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to save education');
    }
  }

  void deleteEducation(String id) {
    state = state.copyWith(
      educations: state.educations.where((item) => item.id != id).toList(),
    );
    _save();
  }

  void addEducation(MockEducationItem item) {
    state = state.copyWith(
      educations: [...state.educations, item],
    );
    _save();
  }

  void updateEducation(MockEducationItem item) {
    state = state.copyWith(
      educations: state.educations
          .map((e) => e.id == item.id ? item : e)
          .toList(),
    );
    _save();
  }
}

final educationViewModelProvider = StateNotifierProvider.autoDispose<
    EducationViewModel, EducationListState>((ref) {
  ref.watch(activeResumeIdProvider);
  final getResume = ref.watch(getResumeUseCaseProvider);
  final updateResume = ref.watch(updateResumeUseCaseProvider);
  return EducationViewModel(ref, getResume, updateResume);
});
