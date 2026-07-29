import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/templates/models/resume_template.dart' as core;
import '../../../core/templates/repository/template_repository.dart' as core_repo;
import '../../preview/view_model/preview_view_model.dart';
import '../../workflow/view_model/workflow_view_model.dart';

enum TemplateCategory {
  all,
  ats,
  professional,
  executive,
  academic;

  String get label {
    switch (this) {
      case TemplateCategory.all:
        return 'All';
      case TemplateCategory.ats:
        return 'ATS';
      case TemplateCategory.professional:
        return 'Professional';
      case TemplateCategory.executive:
        return 'Executive';
      case TemplateCategory.academic:
        return 'Academic';
    }
  }
}

class TemplatesState {
  final List<core.ResumeTemplate> templates;
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
    List<core.ResumeTemplate>? templates,
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

  List<core.ResumeTemplate> get filteredTemplates {
    return templates.where((t) {
      final query = searchQuery.toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          t.name.toLowerCase().contains(query) ||
          t.description.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == TemplateCategory.all ||
          t.category.name.toLowerCase() == selectedCategory.name.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();
  }
}

class TemplatesViewModel extends StateNotifier<TemplatesState> {
  final Ref _ref;
  final core_repo.TemplateRepository _repository = core_repo.TemplateRepository();

  TemplatesViewModel(this._ref) : super(const TemplatesState()) {
    _loadTemplates();
  }

  void _loadTemplates() {
    state = state.copyWith(isLoading: true);
    final list = _repository.getTemplates();
    final currentSelectedId = _ref.read(workflowViewModelProvider).selectedTemplateId ??
        _ref.read(previewViewModelProvider).selectedTemplate?.id ??
        _repository.defaultTemplate().id;

    state = state.copyWith(
      templates: list,
      selectedTemplateId: currentSelectedId,
      isLoading: false,
    );
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
      return TemplatesViewModel(ref);
    });
