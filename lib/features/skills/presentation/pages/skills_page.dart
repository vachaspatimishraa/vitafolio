import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/core/data/skill_data.dart';
import 'package:vitafolio/features/skills/domain/services/role_skill_recommendation_service.dart';


import 'package:vitafolio/features/personal_details/presentation/viewmodels/personal_details_viewmodel.dart';

import 'package:vitafolio/features/personal_details/presentation/widgets/hybrid_search_dropdown.dart';
import 'package:vitafolio/features/skills/presentation/viewmodels/skills_viewmodel.dart';
import 'package:vitafolio/features/skills/presentation/widgets/footer_action_bar.dart';
import 'package:vitafolio/features/skills/presentation/widgets/resume_progress_stepper.dart';


const List<String> kDefaultRecommendedSkills = [
  'Bloc',
  'REST API',
  'Git',
  'Clean Architecture',
  'Animations',
  'Material 3',
  'UI/UX Design',
  'CI/CD',
];

/// Skills screen assembly matching reference UI with active theme & stepper.
class SkillsPage extends ConsumerStatefulWidget {
  const SkillsPage({super.key});

  @override
  ConsumerState<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends ConsumerState<SkillsPage> {
  final TextEditingController _searchController = TextEditingController();
  void _handleAddSkill(String skillName) {
    if (skillName.trim().isEmpty) return;
    ref.read(skillsViewModelProvider.notifier).addSkill(skillName.trim());
    _searchController.clear();
  }


  void _handleRemoveSkill(String skillName) {
    ref.read(skillsViewModelProvider.notifier).removeSkill(skillName);
  }

  void _handlePrevious(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.education);
    }
  }

  void _handleContinue(BuildContext context) {
    context.push(AppRoutes.certifications);
  }

  void _showAddCustomSkillDialog(BuildContext context) {
    final customController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Custom Skill'),
          content: TextField(
            controller: customController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'e.g. GraphQL',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (val) {
              if (val.trim().isNotEmpty) {
                _handleAddSkill(val);
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (customController.text.trim().isNotEmpty) {
                  _handleAddSkill(customController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final skillsState = ref.watch(skillsViewModelProvider);
    final personalDetailsState = ref.watch(personalDetailsViewModelProvider);

    final jobRole = personalDetailsState.jobRole.isNotEmpty
        ? personalDetailsState.jobRole
        : 'Not specified';

    final selectedSkills = skillsState.skills;

    final recommendedSkills = RoleSkillRecommendationService.getRecommendedSkills(
      jobRole: jobRole,
      selectedSkills: selectedSkills,
    );


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handlePrevious(context),
        ),
        title: const Text(
          'Professional Skills',
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
            // Standard Resume Progress Stepper (Step 6 of 9)
            const ResumeProgressStepper(currentStepIndex: 7),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle Header
                    Text(
                      'Select the skills that best represent your expertise...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Job Role Banner Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'JOB ROLE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            jobRole,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Search Skills Inline Hybrid Search Control
                    HybridSearchDropdown(
                      label: 'Search Skills',
                      items: kGlobalSkillCatalogue,
                      onChanged: (val) {
                        if (val.trim().isNotEmpty) {
                          _handleAddSkill(val.trim());
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),



                    // Selected Skills Header + Counter Badge
                    Row(
                      children: [
                        Text(
                          'Selected Skills',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${selectedSkills.length}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Selected Skills Chip Grid/Wrap
                    if (selectedSkills.isEmpty)
                      Text(
                        'No skills selected yet. Choose from recommendations or search above.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedSkills.map((skill) {
                          return Chip(
                            backgroundColor: colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide.none,
                            ),
                            avatar: Icon(
                              Icons.check,
                              size: 16,
                              color: colorScheme.onPrimary,
                            ),
                            label: Text(
                              skill,
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            deleteIcon: Icon(
                              Icons.close,
                              size: 16,
                              color: colorScheme.onPrimary,
                            ),
                            onDeleted: () => _handleRemoveSkill(skill),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: AppSpacing.xl),

                    // Recommended For You Header
                    Text(
                      'Recommended For You',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Recommended Skills Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...recommendedSkills.map((skill) {
                          return ActionChip(
                            elevation: 0,
                            pressElevation: 0,
                            backgroundColor: colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            avatar: const Icon(Icons.add, size: 16),
                            label: Text(skill),
                            onPressed: () => _handleAddSkill(skill),
                          );
                        }),

                        // Add Custom Skill Chip Trigger
                        ActionChip(
                          elevation: 0,
                          pressElevation: 0,
                          backgroundColor: colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: colorScheme.outlineVariant,
                              style: BorderStyle.solid,
                            ),
                          ),
                          avatar: const Icon(
                            Icons.add_circle_outline,
                            size: 16,
                          ),
                          label: const Text('Add Custom Skill'),
                          onPressed: () => _showAddCustomSkillDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Navigation Footer
            FooterActionBar(
              onPrevious: () => _handlePrevious(context),
              onContinue: () => _handleContinue(context),
              isLoading: skillsState.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
