import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/constants/app_strings.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';
import 'package:vitafolio/shared/widgets/buttons/icon_button.dart';
import 'package:vitafolio/shared/widgets/buttons/secondary_button.dart';
import 'package:vitafolio/shared/widgets/inputs/app_text_field.dart';
import 'package:vitafolio/shared/widgets/inputs/date_picker_field.dart';
import 'package:vitafolio/shared/widgets/inputs/multiline_field.dart';
import 'package:vitafolio/features/editor/widgets/editor_section.dart';

class ExperienceSection extends ConsumerWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experienceLength = ref.watch(
      workflowViewModelProvider.select((state) => state.experience.length),
    );

    return EditorSection(
      title: 'Experience',
      trailing: SecondaryButton(
        label: AppStrings.addExperience,
        icon: Icons.add,
        onPressed: () =>
            ref.read(workflowViewModelProvider.notifier).addExperience(),
      ),
      child: Column(
        children: [
          for (var index = 0; index < experienceLength; index++) ...[
            _ExperienceCard(
              key: ValueKey(
                ref.watch(
                  workflowViewModelProvider.select(
                    (s) => s.experience[index].id,
                  ),
                ),
              ),
              index: index,
            ),
            if (index < experienceLength - 1)
              const SizedBox(height: AppSpacing.md),
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
    final item = ref.watch(
      workflowViewModelProvider.select((state) => state.experience[index]),
    );
    final notifier = ref.read(workflowViewModelProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Experience ${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
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
              initialValue: item.company,
              onChanged: (value) => notifier.updateExperience(
                index,
                item.copyWith(company: value),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Position',
              initialValue: item.position,
              onChanged: (value) => notifier.updateExperience(
                index,
                item.copyWith(position: value),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Location',
              initialValue: item.location,
              onChanged: (value) => notifier.updateExperience(
                index,
                item.copyWith(location: value),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: DatePickerField(
                    label: 'Start Date',
                    initialValue: item.startDate
                        ?.toIso8601String()
                        .split('T')
                        .first,
                    onChanged: (value) => notifier.updateExperience(
                      index,
                      item.copyWith(startDate: DateTime.tryParse(value)),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DatePickerField(
                    label: 'End Date',
                    initialValue: item.endDate
                        ?.toIso8601String()
                        .split('T')
                        .first,
                    onChanged: (value) => notifier.updateExperience(
                      index,
                      item.copyWith(endDate: DateTime.tryParse(value)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Currently working here'),
              value: item.isCurrentlyWorking ?? false,
              onChanged: (value) => notifier.updateExperience(
                index,
                item.copyWith(isCurrentlyWorking: value ?? false),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            MultilineField(
              label: 'Description',
              initialValue: item.description,
              onChanged: (value) => notifier.updateExperience(
                index,
                item.copyWith(description: value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
