import 'package:vitafolio/features/resume/domain/entities/resume.dart';

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
  final List<Resume> resumes;
  final Resume? selectedResume;
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

  List<Resume> get filteredResumes {
    List<Resume> result = List.from(resumes);

    // Apply filter
    switch (selectedFilter) {
      case FilterOption.all:
      case FilterOption.draft:
      case FilterOption.completed:
      case FilterOption.archived:
        break;
    }

    // Apply search
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((r) {
        final titleMatch = r.title.toLowerCase().contains(query);
        final nameMatch = (r.personalDetails?.fullName ?? '')
            .toLowerCase()
            .contains(query);
        final jobTitleMatch = (r.personalDetails?.jobTitle ?? '')
            .toLowerCase()
            .contains(query);
        return titleMatch || nameMatch || jobTitleMatch;
      }).toList();
    }

    // Apply sort
    switch (selectedSort) {
      case SortOption.recentlyUpdated:
        result.sort(
          (a, b) => b.updatedAt.compareTo(a.updatedAt),
        );
        break;
      case SortOption.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.alphabeticalAZ:
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case SortOption.alphabeticalZA:
        result.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
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
    List<Resume>? resumes,
    Resume? selectedResume,
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
