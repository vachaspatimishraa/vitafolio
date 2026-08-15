import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/experience/presentation/viewmodels/experience_viewmodel.dart';
import 'package:vitafolio/features/experience/presentation/widgets/empty_experience_state.dart';
import 'package:vitafolio/features/experience/presentation/widgets/experience_card.dart';
import 'package:vitafolio/features/experience/presentation/widgets/experience_options_menu.dart';
import 'package:vitafolio/features/experience/presentation/widgets/footer_navigation.dart';
import 'package:vitafolio/features/experience/presentation/widgets/resume_progress_stepper.dart';
import 'package:vitafolio/shared/widgets/section_add_button.dart';

/// Screen displaying work experience list matching Stitch design.
class ExperienceListPage extends ConsumerWidget {
  const ExperienceListPage({super.key});

  void _handlePrevious(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.summary);
    }
  }

  void _handleContinue(BuildContext context) {
    context.push(AppRoutes.projects);
  }

  void _handleAddExperience(BuildContext context) {
    context.push(AppRoutes.addExperience);
  }

  void _handleEditExperience(BuildContext context, MockExperienceItem item) {
    context.push(
      AppRoutes.addExperience,
      extra: {'isEditing': true, 'item': item},
    );
  }

  void _handleDeleteExperience(
    BuildContext context,
    WidgetRef ref,
    String id,
    String title,
  ) {
    ref.read(experienceViewModelProvider.notifier).deleteExperience(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "$title"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(experienceViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handlePrevious(context),
        ),
        title: const Text(
          'Experience',
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
      body: SafeArea(
        child: Column(
          children: [
            // Step 4 of 9 Progress Stepper
            const ResumeProgressStepper(currentStepIndex: 4),

            // Main Content Area
            Expanded(
              child: state.experiences.isEmpty
                  ? EmptyExperienceState(
                      onAdd: () => _handleAddExperience(context),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Title & Subtitle
                          Text(
                            'Work Experience',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add your professional experience starting with the most recent position.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // List of Experience Cards
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.experiences.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = state.experiences[index];
                              final mockExp = MockExperience(
                                id: item.id,
                                jobTitle: item.title,
                                companyName: item.company,
                                employmentType: item.employmentType,
                                dateRange: item.dateRange,
                                location: item.location,
                                isCurrentlyWorking: item.isCurrent,
                                responsibilities: [item.responsibilities],
                              );
                              return ExperienceCard(
                                experience: mockExp,
                                onEdit: () =>
                                    _handleEditExperience(context, item),
                                onDelete: () => _handleDeleteExperience(
                                  context,
                                  ref,
                                  item.id,
                                  item.title,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          SectionAddButton(
                            label: 'Add Experience',
                            onPressed: () => _handleAddExperience(context),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),

            // Sticky Bottom Navigation Footer
            FooterNavigation(
              onPrevious: () => _handlePrevious(context),
              onContinue: () => _handleContinue(context),
              isLoading: state.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
