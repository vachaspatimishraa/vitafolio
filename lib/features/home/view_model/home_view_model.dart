import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/database/database_provider.dart';
import '../../../data/models/enums/resume_status.dart';
import '../../../data/models/resume/resume_model.dart';
import '../../../data/models/resume_model.dart' as db;
import '../../../data/repositories/resume_repository.dart';
import '../../../data/repositories/repository_provider.dart';
import 'home_state.dart';

export 'home_state.dart';

// Home ViewModel
class HomeViewModel extends StateNotifier<HomeState> {
  final ResumeRepository _repository;
  final Isar? _isar;
  StreamSubscription? _dbSubscription;

  HomeViewModel(this._repository, [this._isar]) : super(const HomeState()) {
    _listenToDatabaseChanges();
    loadResumes();
  }

  void _listenToDatabaseChanges() {
    if (_isar != null) {
      _dbSubscription = _isar!.resumeModels.watchLazy().listen((_) {
        loadResumes();
      });
    }
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadResumes() async {
    // Only set loading to true on initial fetch if resumes are empty
    if (state.resumes.isEmpty) {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      final resumes = await _repository.getAllResumes();
      final stats = await _repository.getResumeStatistics();

      state = state.copyWith(
        isLoading: false,
        resumes: resumes,
        totalCount: stats['total'] ?? 0,
        draftCount: stats['draft'] ?? 0,
        completedCount: stats['completed'] ?? 0,
        archivedCount: stats['archived'] ?? 0,
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

  void selectResume(ResumeModel resume) {
    state = state.copyWith(selectedResume: resume);
  }

  void clearSelection() {
    state = state.copyWith(clearSelectedResume: true);
  }

  Future<void> renameResume(String id, String newName) async {
    try {
      await _repository.renameResume(id, newName);
      if (_isar == null) {
        await loadResumes();
      }
    } catch (e) {
      state = state.copyWith(
        isError: true,
        errorMessage: 'Failed to rename resume: ${e.toString()}',
      );
    }
  }

  Future<void> duplicateResume(String id) async {
    try {
      await _repository.duplicateResume(id, '(Copy)');
      if (_isar == null) {
        await loadResumes();
      }
    } catch (e) {
      state = state.copyWith(
        isError: true,
        errorMessage: 'Failed to duplicate resume: ${e.toString()}',
      );
    }
  }

  Future<void> deleteResume(String id) async {
    try {
      await _repository.deleteResume(id);
      if (_isar == null) {
        await loadResumes();
      }
    } catch (e) {
      state = state.copyWith(
        isError: true,
        errorMessage: 'Failed to delete resume: ${e.toString()}',
      );
    }
  }
}

// Provider
final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final repository = ref.watch(resumeRepositoryProvider);
  Isar? isar;
  try {
    isar = ref.watch(isarProvider);
  } catch (_) {
    // Graceful fallback if isarProvider is not available in unit tests
  }
  return HomeViewModel(repository, isar);
});
