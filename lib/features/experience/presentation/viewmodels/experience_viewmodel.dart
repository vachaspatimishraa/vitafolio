import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class MockExperienceItem {
  final String id;
  final String title;
  final String company;
  final String employmentType;
  final String dateRange;
  final String location;
  final bool isCurrent;
  final String responsibilities;

  const MockExperienceItem({
    required this.id,
    required this.title,
    required this.company,
    required this.employmentType,
    required this.dateRange,
    required this.location,
    required this.isCurrent,
    required this.responsibilities,
  });

  factory MockExperienceItem.fromDomain(Experience domain) {
    return MockExperienceItem(
      id: domain.id,
      title: domain.jobTitle,
      company: domain.company,
      employmentType: 'Full-Time', // Mapping logic if needed
      dateRange: '${domain.startDate} - ${domain.endDate ?? 'Present'}',
      location: domain.location,
      isCurrent: domain.isCurrentRole,
      responsibilities: domain.description,
    );
  }

  Experience toDomain() {
    final dates = dateRange.split(' - ');
    return Experience(
      id: id,
      jobTitle: title,
      company: company,
      location: location,
      startDate: dates.isNotEmpty ? dates[0] : '',
      endDate: (dates.length > 1 && dates[1] != 'Present') ? dates[1] : null,
      isCurrentRole: isCurrent,
      description: responsibilities,
    );
  }
}

class ExperienceListState {
  final List<MockExperienceItem> experiences;
  final bool isLoading;
  final String? errorMessage;

  const ExperienceListState({
    this.experiences = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ExperienceListState copyWith({
    List<MockExperienceItem>? experiences,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ExperienceListState(
      experiences: experiences ?? this.experiences,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ExperienceViewModel extends StateNotifier<ExperienceListState> {
  final Ref _ref;
  final GetResume _getResume;
  final UpdateResume _updateResume;

  ExperienceViewModel(this._ref, this._getResume, this._updateResume)
      : super(const ExperienceListState()) {
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
          experiences: resume.experiences
              .map(MockExperienceItem.fromDomain)
              .toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load experiences',
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
          experiences: state.experiences.map((e) => e.toDomain()).toList(),
          updatedAt: DateTime.now(),
        );
        await _updateResume(updatedResume);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to save experiences');
    }
  }

  void deleteExperience(String id) {
    state = state.copyWith(
      experiences: state.experiences.where((item) => item.id != id).toList(),
    );
    _save();
  }

  void addExperience(MockExperienceItem item) {
    state = state.copyWith(
      experiences: [...state.experiences, item],
    );
    _save();
  }

  void updateExperience(MockExperienceItem item) {
    state = state.copyWith(
      experiences: state.experiences
          .map((e) => e.id == item.id ? item : e)
          .toList(),
    );
    _save();
  }
}

final experienceViewModelProvider = StateNotifierProvider.autoDispose<
    ExperienceViewModel, ExperienceListState>((ref) {
  ref.watch(activeResumeIdProvider);
  final getResume = ref.watch(getResumeUseCaseProvider);
  final updateResume = ref.watch(updateResumeUseCaseProvider);
  return ExperienceViewModel(ref, getResume, updateResume);
});
