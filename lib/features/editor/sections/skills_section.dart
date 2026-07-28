import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../features/workflow/view_model/workflow_view_model.dart';
import '../widgets/chip_input.dart';
import '../widgets/editor_section.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowViewModelProvider);
    final notifier = ref.read(workflowViewModelProvider.notifier);

    return EditorSection(
      title: 'Skills',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChipInput(
            chips: state.skills,
            suggestions: WorkflowViewModel.skillSuggestions,
            onAdd: notifier.addSkill,
            onRemove: notifier.removeSkill,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: WorkflowViewModel.skillSuggestions
                .where((skill) => !state.skills.contains(skill))
                .map(
                  (skill) => ActionChip(
                    label: Text(skill),
                    onPressed: () => notifier.addSkill(skill),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
