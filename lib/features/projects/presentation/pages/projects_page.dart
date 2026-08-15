import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/projects/presentation/viewmodels/projects_viewmodel.dart';
import 'package:vitafolio/features/projects/presentation/widgets/empty_projects_state.dart';
import 'package:vitafolio/features/projects/presentation/widgets/project_card.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/shared/widgets/helpers/resume_progress_stepper.dart';
import 'package:vitafolio/shared/widgets/section_add_button.dart';
import 'package:vitafolio/shared/widgets/wizard_bottom_action_bar.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  void _handlePrevious(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.experience);
    }
  }

  Future<void> _handleContinue(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(projectsViewModelProvider.notifier);
    try {
      await notifier.save();
      if (context.mounted) {
        context.push(AppRoutes.education);
      }
    } catch (_) {
      // ViewModel handles error messaging
    }
  }

  void _handleAddProject(BuildContext context) {
    context.push(AppRoutes.addProject);
  }

  void _handleEditProject(BuildContext context, Project project) {
    context.push(
      AppRoutes.addProject,
      extra: {'isEditing': true, 'project': project},
    );
  }

  void _handleDeleteProject(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) {
    ref.read(projectsViewModelProvider.notifier).deleteProject(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "$name"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(projectsViewModelProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handlePrevious(context),
        ),
        title: const Text(
          'Projects',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      bottomNavigationBar: WizardBottomActionBar(
        secondaryLabel: 'Previous',
        onSecondaryPressed: () => _handlePrevious(context),
        primaryLabel: 'Continue',
        onPrimaryPressed: () => _handleContinue(context, ref),
        isLoading: state.isLoading,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step 5 of 10 Progress Stepper
            const ResumeProgressStepper(currentStepIndex: 5),

            // Main Content Area
            Expanded(
              child: state.projects.isEmpty
                  ? EmptyProjectsState(
                      onAdd: () => _handleAddProject(context),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Projects',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Add significant projects you have built or contributed to.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.projects.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final project = state.projects[index];
                              return ProjectCard(
                                project: project,
                                onEdit: () =>
                                    _handleEditProject(context, project),
                                onDelete: () => _handleDeleteProject(
                                  context,
                                  ref,
                                  project.id,
                                  project.name,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          SectionAddButton(
                            label: 'Add Project',
                            onPressed: () => _handleAddProject(context),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
