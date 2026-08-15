import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/resume/domain/entities/language.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class MockLanguageItem {
  final String id;
  final String language;
  final String level;

  const MockLanguageItem({
    required this.id,
    required this.language,
    required this.level,
  });

  factory MockLanguageItem.fromDomain(Language domain) {
    return MockLanguageItem(
      id: domain.id,
      language: domain.name,
      level: domain.proficiencyLevel,
    );
  }

  Language toDomain() {
    return Language(
      id: id,
      name: language,
      proficiencyLevel: level,
    );
  }
}

class LanguagesListState {
  final List<MockLanguageItem> languages;
  final bool isLoading;
  final String? errorMessage;

  const LanguagesListState({
    this.languages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  LanguagesListState copyWith({
    List<MockLanguageItem>? languages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LanguagesListState(
      languages: languages ?? this.languages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LanguagesViewModel extends StateNotifier<LanguagesListState> {
  final Ref _ref;
  final GetResume _getResume;
  final UpdateResume _updateResume;

  LanguagesViewModel(this._ref, this._getResume, this._updateResume)
      : super(const LanguagesListState()) {
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
          languages: resume.languages
              .map(MockLanguageItem.fromDomain)
              .toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load languages',
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
          languages: state.languages.map((l) => l.toDomain()).toList(),
          updatedAt: DateTime.now(),
        );
        await _updateResume(updatedResume);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to save languages');
    }
  }

  void deleteLanguage(String id) {
    state = state.copyWith(
      languages: state.languages.where((item) => item.id != id).toList(),
    );
    _save();
  }

  void addLanguage(MockLanguageItem item) {
    state = state.copyWith(
      languages: [...state.languages, item],
    );
    _save();
  }

  void updateLanguage(MockLanguageItem item) {
    state = state.copyWith(
      languages: state.languages
          .map((l) => l.id == item.id ? item : l)
          .toList(),
    );
    _save();
  }
}

final languagesViewModelProvider = StateNotifierProvider.autoDispose<
    LanguagesViewModel, LanguagesListState>((ref) {
  ref.watch(activeResumeIdProvider);
  final getResume = ref.watch(getResumeUseCaseProvider);
  final updateResume = ref.watch(updateResumeUseCaseProvider);
  return LanguagesViewModel(ref, getResume, updateResume);
});
