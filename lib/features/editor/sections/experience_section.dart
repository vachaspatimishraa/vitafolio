import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../features/workflow/view_model/workflow_view_model.dart';
import '../../../shared/widgets/buttons/icon_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/inputs/date_picker_field.dart';
import '../../../shared/widgets/inputs/multiline_field.dart';
import '../widgets/editor_section.dart';

class ExperienceSection extends ConsumerWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowViewModelProvider);

    return EditorSection(
      title: 'Experience',
      trailing: SecondaryButton(
        label: AppStrings.addExperience,
        icon: Icons.add,
        onPressed: () => ref.read(workflowViewModelProvider.notifier).addExperience(),
      ),
      child: Column(
        children: [
          for (var index = 0; index < state.experience.length; index++) ...[
            _ExperienceCard(key: ValueKey(state.experience[index].id), index: index),
            if (index < state.experience.length - 1) const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _ExperienceCard extends ConsumerWidget {
  final int index;

  const _ExperienceCard({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(workflowViewModelProvider).experience[index];
    final notifier = ref.read(workflowViewModelProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Experience ${index + 1}', style: Theme.of(context).textTheme.titleSmall),
                ),
                AppIconButton(
                  icon: Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                  tooltip: 'Delete item',
                  onPressed: () => notifier.removeExperience(index),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Company',
              initialValue: item.title,
              onChanged: (value) => notifier.updateExperience(index, item.copyWith(title: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Position',
              initialValue: item.subtitle,
              onChanged: (value) => notifier.updateExperience(index, item.copyWith(subtitle: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Location',
              initialValue: item.location,
              onChanged: (value) => notifier.updateExperience(index, item.copyWith(location: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: DatePickerField(
                    label: 'Start Date',
                    initialValue: item.startDate,
                    onChanged: (value) => notifier.updateExperience(index, item.copyWith(startDate: value)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DatePickerField(
                    label: 'End Date',
                    initialValue: item.endDate,
                    onChanged: (value) => notifier.updateExperience(index, item.copyWith(endDate: value)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Currently working here'),
              value: item.isCurrent,
              onChanged: (value) => notifier.updateExperience(index, item.copyWith(isCurrent: value ?? false)),
            ),
            const SizedBox(height: AppSpacing.md),
            MultilineField(
              label: 'Description',
              initialValue: item.description,
              onChanged: (value) => notifier.updateExperience(index, item.copyWith(description: value)),
            ),
          ],
        ),
      ),
    );
  }
}
