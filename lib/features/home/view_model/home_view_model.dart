import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';
import 'package:vitafolio/features/home/view_model/home_state.dart';

export 'home_state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final ResumeRepository _repository;

  HomeViewModel(this._repository) : super(const HomeState()) {
    loadResumes();
  }

  Future<void> loadResumes() async {
    if (state.resumes.isEmpty) {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      final resumes = await _repository.getAllResumes();
      
      final total = resumes.length;
      final draftCount = resumes.where((r) => r.title.toLowerCase().contains('draft')).length;

      state = state.copyWith(
        isLoading: false,
        resumes: resumes,
        totalCount: total,
        draftCount: draftCount,
        completedCount: total - draftCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshResumes() async {
    await loadResumes();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilter(FilterOption filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void setSort(SortOption sort) {
    state = state.copyWith(selectedSort: sort);
  }

  void selectResume(Resume resume) {
    state = state.copyWith(selectedResume: resume);
  }

  void clearSelection() {
    state = state.copyWith(clearSelectedResume: true);
  }

  Future<void> deleteResume(String id) async {
    try {
      await _repository.deleteResume(ResumeId(id));
      await loadResumes();
    } catch (e) {
      state = state.copyWith(
        isError: true,
        errorMessage: 'Failed to delete resume: $e',
      );
    }
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final repository = ref.watch(cleanResumeRepositoryProvider);
  return HomeViewModel(repository);
});
