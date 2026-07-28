import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../features/workflow/view_model/workflow_view_model.dart';
import '../../../shared/widgets/buttons/icon_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/inputs/date_picker_field.dart';
import '../widgets/editor_section.dart';

class EducationSection extends ConsumerWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowViewModelProvider);

    return EditorSection(
      title: 'Education',
      trailing: SecondaryButton(
        label: AppStrings.addEducation,
        icon: Icons.add,
        onPressed: () => ref.read(workflowViewModelProvider.notifier).addEducation(),
      ),
      child: Column(
        children: [
          for (var index = 0; index < state.education.length; index++) ...[
            _EducationCard(key: ValueKey(state.education[index].id), index: index),
            if (index < state.education.length - 1) const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _EducationCard extends ConsumerWidget {
  final int index;

  const _EducationCard({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(workflowViewModelProvider).education[index];
    final notifier = ref.read(workflowViewModelProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Education ${index + 1}', style: Theme.of(context).textTheme.titleSmall),
                ),
                AppIconButton(
                  icon: Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                  tooltip: 'Delete item',
                  onPressed: () => notifier.removeEducation(index),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'School',
              initialValue: item.title,
              onChanged: (value) => notifier.updateEducation(index, item.copyWith(title: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Degree',
              initialValue: item.subtitle,
              onChanged: (value) => notifier.updateEducation(index, item.copyWith(subtitle: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Field of Study',
              initialValue: item.location,
              onChanged: (value) => notifier.updateEducation(index, item.copyWith(location: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Grade / CGPA',
              initialValue: item.extra,
              onChanged: (value) => notifier.updateEducation(index, item.copyWith(extra: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: DatePickerField(
                    label: 'Start Date',
                    initialValue: item.startDate,
                    onChanged: (value) => notifier.updateEducation(index, item.copyWith(startDate: value)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DatePickerField(
                    label: 'End Date',
                    initialValue: item.endDate,
                    onChanged: (value) => notifier.updateEducation(index, item.copyWith(endDate: value)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
