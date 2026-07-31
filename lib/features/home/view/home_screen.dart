import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/empty_states/empty_state.dart';
import '../../../shared/widgets/loaders/loading_indicator.dart';
import '../../editor/view_model/editor_view_model.dart';
import '../../workflow/view_model/workflow_view_model.dart';
import '../view_model/home_view_model.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/resume_list.dart';
import '../widgets/search_bar.dart';
import '../widgets/section_title.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      homeViewModelProvider.select((s) => s.isLoading),
    );
    final isError = ref.watch(homeViewModelProvider.select((s) => s.isError));
    final errorMessage = ref.watch(
      homeViewModelProvider.select((s) => s.errorMessage),
    );

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? _buildLoadingState()
            : isError
            ? _buildErrorState(context, ref, errorMessage)
            : _buildContent(context, ref),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(editorViewModelProvider.notifier).resetState();
          ref.read(workflowViewModelProvider.notifier).createNewResume();
          context.push(AppRoutes.editor);
        },
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.createResume),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: LoadingIndicator());
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
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final resumesEmpty = ref.watch(
      homeViewModelProvider.select((s) => s.resumes.isEmpty),
    );
    final filteredResumesEmpty = ref.watch(
      homeViewModelProvider.select((s) => s.filteredResumes.isEmpty),
    );

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(homeViewModelProvider.notifier).refreshResumes(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeader(),
            const HomeSearchBar(),
            const SizedBox(height: AppSpacing.md),
            const SectionTitle(title: AppStrings.recentResumes),
            if (resumesEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: EmptyState(
                  icon: Icons.article_outlined,
                  title: 'Create Your First Resume',
                  description:
                      'Build a professional, job-ready resume in minutes with our ATS-friendly templates.',
                  showLogo: true,
                  primaryActionLabel: AppStrings.createResume,
                  onPrimaryAction: () {
                    ref.read(editorViewModelProvider.notifier).resetState();
                    ref.read(workflowViewModelProvider.notifier).createNewResume();
                    context.push(AppRoutes.editor);
                  },
                ),
              )
            else if (filteredResumesEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: EmptyState(
                  icon: Icons.search_off_outlined,
                  title: AppStrings.noResumesFound,
                  description: 'Try adjusting your search terms.',
                ),
              )
            else
              const ResumeList(),
            // Bottom spacing for FAB
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
