import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/templates/view_model/templates_view_model.dart';
import 'package:vitafolio/features/templates/widgets/template_grid.dart';
import 'package:vitafolio/features/templates/widgets/template_search_bar.dart';
import 'package:vitafolio/features/templates/widgets/category_filter.dart';
import 'package:vitafolio/features/templates/widgets/empty_template_view.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/constants/app_strings.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templatesViewModelProvider);
    final hasTemplates = state.filteredTemplates.isNotEmpty;
    final hasActiveFilters =
        state.searchQuery.isNotEmpty ||
        state.selectedCategory != TemplateCategory.all;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.templates)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            child: Column(
              children: [
                const TemplateSearchBar(),
                const SizedBox(height: AppSpacing.md),
                const CategoryFilter(),
              ],
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasTemplates
                ? const TemplateGrid()
                : EmptyTemplateView(
                    query: state.searchQuery,
                    onReset: hasActiveFilters
                        ? () => ref
                              .read(templatesViewModelProvider.notifier)
                              .resetFilters()
                        : null,
                  ),
          ),
        ],
      ),
    );
  }
}
