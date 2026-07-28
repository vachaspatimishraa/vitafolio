import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/empty_states/empty_state.dart';
import '../../../shared/widgets/loaders/loading_indicator.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../editor/view_model/editor_view_model.dart';
import '../view_model/home_view_model.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/search_bar.dart';
import '../widgets/filter_bar.dart';
import '../widgets/sort_menu.dart';
import '../widgets/statistics_section.dart';
import '../widgets/section_title.dart';
import '../widgets/resume_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: state.isLoading
            ? _buildLoadingState()
            : state.isError
                ? _buildErrorState(context, ref, state.errorMessage)
                : _buildContent(context, ref, state),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          final isSmall = MediaQuery.of(context).size.width < 480;
          return FloatingActionButton.extended(
            onPressed: () {
              ref.read(editorViewModelProvider.notifier).resetState();
              context.push(AppRoutes.editor);
            },
            icon: const Icon(Icons.add),
            label: Text(isSmall ? 'Create' : AppStrings.createResume),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: LoadingIndicator(),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppStrings.somethingWentWrong,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error ?? AppStrings.failedToLoadResumes,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: AppStrings.retry,
              onPressed: () {
                ref.read(homeViewModelProvider.notifier).loadResumes();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, HomeState state) {
    return RefreshIndicator(
      onRefresh: () => ref.read(homeViewModelProvider.notifier).refreshResumes(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeader(),
            const HomeSearchBar(),
            const FilterBar(),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${state.filteredResumes.length} resumes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SortMenu(),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const StatisticsSection(),
            const SectionTitle(title: AppStrings.recentResumes),
            if (state.resumes.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: EmptyState(
                  icon: Icons.article_outlined,
                  title: AppStrings.noResumesYet,
                  description: AppStrings.emptyDescription,
                  showLogo: true,
                  primaryActionLabel: AppStrings.createResume,
                  onPrimaryAction: () {
                    ref.read(editorViewModelProvider.notifier).resetState();
                    context.push(AppRoutes.editor);
                  },
                ),
              )
            else if (state.filteredResumes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: EmptyState(
                  icon: Icons.search_off_outlined,
                  title: AppStrings.noResumesFound,
                  description: 'Try adjusting your search or filter.',
                ),
              )
            else
              const ResumeList(),
            // Bottom padding for FAB
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
