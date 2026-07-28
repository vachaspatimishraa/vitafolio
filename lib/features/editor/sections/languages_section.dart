import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../data/models/enums/language_proficiency.dart';
import '../../../features/workflow/view_model/workflow_view_model.dart';
import '../../../shared/widgets/buttons/icon_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/inputs/dropdown_field.dart';
import '../widgets/editor_section.dart';

class LanguagesSection extends ConsumerWidget {
  const LanguagesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowViewModelProvider);

    return EditorSection(
      title: 'Languages',
      trailing: SecondaryButton(
        label: AppStrings.addLanguage,
        icon: Icons.add,
        onPressed: () => ref.read(workflowViewModelProvider.notifier).addLanguage(),
      ),
      child: Column(
        children: [
          for (var index = 0; index < state.languages.length; index++) ...[
            _LanguageCard(key: ValueKey(state.languages[index].id), index: index),
            if (index < state.languages.length - 1) const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _LanguageCard extends ConsumerWidget {
  final int index;

  const _LanguageCard({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(workflowViewModelProvider).languages[index];
    final notifier = ref.read(workflowViewModelProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Language ${index + 1}', style: Theme.of(context).textTheme.titleSmall),
                ),
                AppIconButton(
                  icon: Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                  tooltip: 'Delete item',
                  onPressed: () => notifier.removeLanguage(index),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Language',
              initialValue: item.title,
              onChanged: (value) => notifier.updateLanguage(index, item.copyWith(title: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownField(
              label: 'Proficiency',
              value: item.proficiency.isNotEmpty ? item.proficiency : LanguageProficiency.intermediate.name,
              items: LanguageProficiency.values.map((e) => e.name).toList(),
              onChanged: (value) {
                if (value != null) {
                  notifier.updateLanguage(index, item.copyWith(proficiency: value));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
