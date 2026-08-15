import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/education/presentation/viewmodels/education_viewmodel.dart';
import 'package:vitafolio/features/education/presentation/widgets/education_card.dart';
import 'package:vitafolio/features/education/presentation/widgets/resume_progress_stepper.dart';
import 'package:vitafolio/shared/widgets/empty_states/empty_state.dart';
import 'package:vitafolio/shared/widgets/section_add_button.dart';
import 'package:vitafolio/shared/widgets/wizard_bottom_action_bar.dart';

class EducationListPage extends ConsumerWidget {
  const EducationListPage({super.key});

  void _addEducation(BuildContext context) {
    context.push(AppRoutes.addEducation);
  }

  void _editEducation(BuildContext context, MockEducationItem item) {
    context.push(
      AppRoutes.addEducation,
      extra: {'isEditing': true, 'item': item},
    );
  }

  void _deleteEducation(WidgetRef ref, String id) {
    ref.read(educationViewModelProvider.notifier).deleteEducation(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final state = ref.watch(educationViewModelProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Education'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      bottomNavigationBar: WizardBottomActionBar(
        primaryLabel: 'Continue',
        onPrimaryPressed: () {
          context.push(AppRoutes.skills);
        },
        secondaryLabel: 'Previous',
        onSecondaryPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            context.go(AppRoutes.projects);
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ResumeProgressStepper(currentStepIndex: 6),
            Expanded(
              child: state.educations.isEmpty
                  ? EmptyState(
                      icon: Icons.school_outlined,
                      title: 'No Education Added',
                      description:
                          'Tap the button below to add your first education record.',
                      primaryActionLabel: 'Add Education',
                      onPrimaryAction: () => _addEducation(context),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Education',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Add your educational qualifications starting from the most recent.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.educations.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final item = state.educations[index];
                              final parts = item.dateRange.split(' - ');
                              final startYear = parts.isNotEmpty
                                  ? parts[0]
                                  : '';
                              final endYear = parts.length > 1 ? parts[1] : '';

                              return EducationCard(
                                degree: item.degree,
                                fieldOfStudy: item.fieldOfStudy,
                                institution: item.institution,
                                startYear: startYear,
                                endYear: endYear,
                                grade: item.grade,
                                description: item.description,
                                onEdit: () => _editEducation(context, item),
                                onDelete: () => _deleteEducation(ref, item.id),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          SectionAddButton(
                            label: 'Add Education',
                            onPressed: () => _addEducation(context),
                          ),
                          const SizedBox(height: 24),
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
