import '../../../data/models/enums/resume_status.dart';
import '../../../data/models/resume_model.dart';

// Sort options enum
enum SortOption {
  recentlyUpdated('Recently Updated'),
  newest('Newest'),
  oldest('Oldest'),
  alphabeticalAZ('A-Z'),
  alphabeticalZA('Z-A');

  final String label;
  const SortOption(this.label);
}

// Filter options enum
enum FilterOption {
  all('All'),
  draft('Draft'),
  completed('Completed'),
  archived('Archived');

  final String label;
  const FilterOption(this.label);
}

class HomeState {
  final String searchQuery;
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final List<ResumeModel> resumes;
  final ResumeModel? selectedResume;
  final FilterOption selectedFilter;
  final SortOption selectedSort;
  final int totalCount;
  final int draftCount;
  final int completedCount;
  final int archivedCount;

  const HomeState({
    this.searchQuery = '',
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.resumes = const [],
    this.selectedResume,
    this.selectedFilter = FilterOption.all,
    this.selectedSort = SortOption.recentlyUpdated,
    this.totalCount = 0,
    this.draftCount = 0,
    this.completedCount = 0,
    this.archivedCount = 0,
  });

  List<ResumeModel> get filteredResumes {
    List<ResumeModel> result = List.from(resumes);

    // Apply filter
    switch (selectedFilter) {
      case FilterOption.all:
        break;
      case FilterOption.draft:
        result = result.where((r) => r.status == ResumeStatus.draft).toList();
        break;
      case FilterOption.completed:
        result = result
            .where((r) => r.status == ResumeStatus.completed)
            .toList();
        break;
      case FilterOption.archived:
        result = result
            .where((r) => r.status == ResumeStatus.archived)
            .toList();
        break;
    }

    // Apply search
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((r) {
        final titleMatch = (r.resumeName ?? '').toLowerCase().contains(query);
        final nameMatch = (r.personalInfo?.fullName ?? '')
            .toLowerCase()
            .contains(query);
        final jobTitleMatch = (r.personalInfo?.jobTitle ?? '')
            .toLowerCase()
            .contains(query);
        return titleMatch || nameMatch || jobTitleMatch;
      }).toList();
    }

    // Apply sort
    switch (selectedSort) {
      case SortOption.recentlyUpdated:
        result.sort(
          (a, b) => (b.lastUpdated ?? DateTime.now()).compareTo(
            a.lastUpdated ?? DateTime.now(),
          ),
        );
        break;
      case SortOption.newest:
        result.sort((a, b) => b.id.compareTo(a.id));
        break;
      case SortOption.oldest:
        result.sort((a, b) => a.id.compareTo(b.id));
        break;
      case SortOption.alphabeticalAZ:
        result.sort(
          (a, b) => (a.resumeName ?? '').toLowerCase().compareTo(
            (b.resumeName ?? '').toLowerCase(),
          ),
        );
        break;
      case SortOption.alphabeticalZA:
        result.sort(
          (a, b) => (b.resumeName ?? '').toLowerCase().compareTo(
            (a.resumeName ?? '').toLowerCase(),
          ),
        );
        break;
    }

    return result;
  }

  HomeState copyWith({
    String? searchQuery,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<ResumeModel>? resumes,
    ResumeModel? selectedResume,
    FilterOption? selectedFilter,
    SortOption? selectedSort,
    int? totalCount,
    int? draftCount,
    int? completedCount,
    int? archivedCount,
    bool clearSelectedResume = false,
    bool clearError = false,
  }) {
    return HomeState(
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isError: clearError ? false : (isError ?? this.isError),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      resumes: resumes ?? this.resumes,
      selectedResume: clearSelectedResume
          ? null
          : (selectedResume ?? this.selectedResume),
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedSort: selectedSort ?? this.selectedSort,
      totalCount: totalCount ?? this.totalCount,
      draftCount: draftCount ?? this.draftCount,
      completedCount: completedCount ?? this.completedCount,
      archivedCount: archivedCount ?? this.archivedCount,
    );
  }
}
