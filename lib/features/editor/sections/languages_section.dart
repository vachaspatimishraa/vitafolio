import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/constants/app_strings.dart';
import 'package:vitafolio/data/models/enums/language_proficiency.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';
import 'package:vitafolio/shared/widgets/buttons/icon_button.dart';
import 'package:vitafolio/shared/widgets/buttons/secondary_button.dart';
import 'package:vitafolio/shared/widgets/inputs/app_text_field.dart';
import 'package:vitafolio/shared/widgets/inputs/dropdown_field.dart';
import 'package:vitafolio/features/editor/widgets/editor_section.dart';

class LanguagesSection extends ConsumerWidget {
  const LanguagesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languagesLength = ref.watch(
      workflowViewModelProvider.select((state) => state.languages.length),
    );

    return EditorSection(
      title: 'Languages',
      trailing: SecondaryButton(
        label: AppStrings.addLanguage,
        icon: Icons.add,
        onPressed: () =>
            ref.read(workflowViewModelProvider.notifier).addLanguage(),
      ),
      child: Column(
        children: [
          for (var index = 0; index < languagesLength; index++) ...[
            _LanguageCard(
              key: ValueKey(
                ref.watch(
                  workflowViewModelProvider.select(
                    (s) => s.languages[index].id,
                  ),
                ),
              ),
              index: index,
            ),
            if (index < languagesLength - 1)
              const SizedBox(height: AppSpacing.md),
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
    final item = ref.watch(
      workflowViewModelProvider.select((state) => state.languages[index]),
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
                    'Language ${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
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
              initialValue: item.language,
              onChanged: (value) => notifier.updateLanguage(
                index,
                item.copyWith(language: value),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownField(
              label: 'Proficiency',
              value: item.proficiency.name,
              items: LanguageProficiency.values.map((e) => e.name).toList(),
              onChanged: (value) {
                if (value != null) {
                  final prof = LanguageProficiency.values.firstWhere(
                    (e) => e.name == value,
                  );
                  notifier.updateLanguage(
                    index,
                    item.copyWith(proficiency: prof),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
