import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class SkillsState {
  final List<String> skills;
  final String? selectedSkill;
  final String selectedProficiency;
  final bool isLoading;
  final String? errorMessage;

  const SkillsState({
    this.skills = const [],
    this.selectedSkill,
    this.selectedProficiency = 'Intermediate',
    this.isLoading = false,
    this.errorMessage,
  });

  SkillsState copyWith({
    List<String>? skills,
    String? selectedSkill,
    String? selectedProficiency,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SkillsState(
      skills: skills ?? this.skills,
      selectedSkill: selectedSkill ?? this.selectedSkill,
      selectedProficiency: selectedProficiency ?? this.selectedProficiency,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class SkillsViewModel extends StateNotifier<SkillsState> {
  final Ref _ref;
  final GetResume _getResume;
  final UpdateResume _updateResume;

  SkillsViewModel(this._ref, this._getResume, this._updateResume)
      : super(const SkillsState()) {
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
          skills: resume.skills.map((s) => s.name).toList(),
          selectedSkill: resume.skills.isNotEmpty ? resume.skills.first.name : null,
          selectedProficiency: resume.skills.isNotEmpty ? (resume.skills.first.level ?? 'Intermediate') : 'Intermediate',
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load skills',
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
          skills: state.skills
              .map((s) => Skill(
                    id: s,
                    name: s,
                    level: s == state.selectedSkill ? state.selectedProficiency : null,
                  ))
              .toList(),
          updatedAt: DateTime.now(),
        );
        await _updateResume(updatedResume);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to save skills');
    }
  }

  void addSkill(String skill) {
    final trimmed = skill.trim();
    if (trimmed.isNotEmpty && !state.skills.contains(trimmed)) {
      state = state.copyWith(
        skills: [...state.skills, trimmed],
        selectedSkill: trimmed,
      );
      _save();
    }
  }

  void removeSkill(String skill) {
    final updated = state.skills.where((s) => s != skill).toList();
    state = state.copyWith(
      skills: updated,
      selectedSkill: updated.isNotEmpty ? updated.last : null,
    );
    _save();
  }

  void selectSkill(String skill) {
    state = state.copyWith(selectedSkill: skill);
  }

  void setProficiency(String proficiency) {
    state = state.copyWith(selectedProficiency: proficiency);
    _save();
  }
}

final skillsViewModelProvider =
    StateNotifierProvider.autoDispose<SkillsViewModel, SkillsState>((ref) {
  ref.watch(activeResumeIdProvider);
  final getResume = ref.watch(getResumeUseCaseProvider);
  final updateResume = ref.watch(updateResumeUseCaseProvider);
  return SkillsViewModel(ref, getResume, updateResume);
});
