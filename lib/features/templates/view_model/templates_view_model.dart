import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/template_model.dart';
import '../repository/template_repository.dart';

enum TemplateCategory {
  all,
  modern,
  classic,
  minimal,
  professional,
  executive,
  creative,
  atsFriendly;

  String get label {
    switch (this) {
      case TemplateCategory.all:
        return 'All';
      case TemplateCategory.modern:
        return 'Modern';
      case TemplateCategory.classic:
        return 'Classic';
      case TemplateCategory.minimal:
        return 'Minimal';
      case TemplateCategory.professional:
        return 'Professional';
      case TemplateCategory.executive:
        return 'Executive';
      case TemplateCategory.creative:
        return 'Creative';
      case TemplateCategory.atsFriendly:
        return 'ATS Friendly';
    }
  }
}

class TemplatesState {
  final List<TemplateModel> templates;
  final String searchQuery;
  final TemplateCategory selectedCategory;
  final String? selectedTemplateId;
  final bool isLoading;

  const TemplatesState({
    this.templates = const [],
    this.searchQuery = '',
    this.selectedCategory = TemplateCategory.all,
    this.selectedTemplateId,
    this.isLoading = false,
  });

  TemplatesState copyWith({
    List<TemplateModel>? templates,
    String? searchQuery,
    TemplateCategory? selectedCategory,
    String? selectedTemplateId,
    bool? isLoading,
  }) {
    return TemplatesState(
      templates: templates ?? this.templates,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<TemplateModel> get filteredTemplates {
    return templates.where((t) {
      final query = searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty ||
          t.name.toLowerCase().contains(query) ||
          t.category.toLowerCase().contains(query);
      
      final matchesCategory = selectedCategory == TemplateCategory.all ||
          t.category.toLowerCase() == selectedCategory.label.toLowerCase() ||
          (selectedCategory == TemplateCategory.atsFriendly && t.isAtsFriendly);
      
      return matchesSearch && matchesCategory;
    }).toList();
  }
}

class TemplatesViewModel extends StateNotifier<TemplatesState> {
  final TemplateRepository _repository = TemplateRepository();

  TemplatesViewModel() : super(const TemplatesState()) {
    _loadTemplates();
  }

  void _loadTemplates() {
    state = state.copyWith(isLoading: true);
    final list = _repository.getAllTemplates();
    state = state.copyWith(templates: list, isLoading: false);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(TemplateCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void selectTemplate(String id) {
    state = state.copyWith(selectedTemplateId: id);
  }

  void resetFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedCategory: TemplateCategory.all,
    );
  }
}

final templatesViewModelProvider =
    StateNotifierProvider<TemplatesViewModel, TemplatesState>((ref) {
  return TemplatesViewModel();
});
