import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class ProjectsListState {
  final List<Project> projects;
  final bool isLoading;
  final String? errorMessage;

  const ProjectsListState({
    this.projects = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ProjectsListState copyWith({
    List<Project>? projects,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProjectsListState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ProjectsViewModel extends StateNotifier<ProjectsListState> {
  final Ref _ref;
  final GetResume _getResume;
  final UpdateResume _updateResume;

  ProjectsViewModel(this._ref, this._getResume, this._updateResume)
      : super(const ProjectsListState()) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final resume = await _getResume(activeId);
      if (resume != null) {
        state = state.copyWith(
          projects: resume.projects,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load projects',
      );
    }
  }

  Future<void> save() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId == null) return;

    try {
      final resume = await _getResume(activeId);
      if (resume != null) {
        final updatedResume = resume.copyWith(
          projects: state.projects,
          updatedAt: DateTime.now(),
        );
        await _updateResume(updatedResume);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to save projects');
      rethrow;
    }
  }

  Future<void> addProject(Project project) async {
    state = state.copyWith(
      projects: [...state.projects, project],
    );
    await save();
  }

  Future<void> updateProject(Project project) async {
    state = state.copyWith(
      projects: state.projects
          .map((p) => p.id == project.id ? project : p)
          .toList(),
    );
    await save();
  }

  Future<void> deleteProject(String id) async {
    state = state.copyWith(
      projects: state.projects.where((p) => p.id != id).toList(),
    );
    await save();
  }
}

final projectsViewModelProvider = StateNotifierProvider.autoDispose<
    ProjectsViewModel, ProjectsListState>((ref) {
  ref.watch(activeResumeIdProvider);
  final getResume = ref.watch(getResumeUseCaseProvider);
  final updateResume = ref.watch(updateResumeUseCaseProvider);
  return ProjectsViewModel(ref, getResume, updateResume);
});
