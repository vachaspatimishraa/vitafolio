import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../features/workflow/view_model/workflow_view_model.dart';
import '../../../shared/widgets/buttons/icon_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/inputs/multiline_field.dart';
import '../widgets/editor_section.dart';

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowViewModelProvider);

    return EditorSection(
      title: 'Projects',
      trailing: SecondaryButton(
        label: AppStrings.addProject,
        icon: Icons.add,
        onPressed: () => ref.read(workflowViewModelProvider.notifier).addProject(),
      ),
      child: Column(
        children: [
          for (var index = 0; index < state.projects.length; index++) ...[
            _ProjectCard(key: ValueKey(state.projects[index].id), index: index),
            if (index < state.projects.length - 1) const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _ProjectCard extends ConsumerWidget {
  final int index;

  const _ProjectCard({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(workflowViewModelProvider).projects[index];
    final notifier = ref.read(workflowViewModelProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Project ${index + 1}', style: Theme.of(context).textTheme.titleSmall),
                ),
                AppIconButton(
                  icon: Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                  tooltip: 'Delete item',
                  onPressed: () => notifier.removeProject(index),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Project Name',
              initialValue: item.title,
              onChanged: (value) => notifier.updateProject(index, item.copyWith(title: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Technologies',
              initialValue: item.subtitle,
              onChanged: (value) => notifier.updateProject(index, item.copyWith(subtitle: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            MultilineField(
              label: 'Description',
              initialValue: item.description,
              onChanged: (value) => notifier.updateProject(index, item.copyWith(description: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'GitHub Link',
              initialValue: item.url,
              keyboardType: TextInputType.url,
              onChanged: (value) => notifier.updateProject(index, item.copyWith(url: value)),
              validator: (value) {
                final text = value?.trim() ?? '';
                return ref.read(workflowViewModelProvider.notifier).isValidUrl(text) ? null : 'Enter a valid URL';
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Live URL',
              initialValue: item.extra,
              keyboardType: TextInputType.url,
              onChanged: (value) => notifier.updateProject(index, item.copyWith(extra: value)),
              validator: (value) {
                final text = value?.trim() ?? '';
                return ref.read(workflowViewModelProvider.notifier).isValidUrl(text) ? null : 'Enter a valid URL';
              },
            ),
          ],
        ),
      ),
    );
  }
}
