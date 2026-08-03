import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/core/templates/repository/template_repository.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';

class TemplateSelector extends ConsumerWidget {
  const TemplateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewState = ref.watch(previewViewModelProvider);
    final workflowState = ref.watch(workflowViewModelProvider);
    final selectedTemplateId =
        previewState.selectedTemplate?.id ??
        workflowState.selectedTemplateId ??
        'ats_professional';

    final templates = TemplateRepository().getTemplates();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          final isSelected = selectedTemplateId == template.id;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChip(
              avatar: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: colorScheme.onPrimaryContainer,
                    )
                  : null,
              label: Text(template.name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(previewViewModelProvider.notifier)
                      .changeTemplate(template.id);
                }
              },
              selectedColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }
}
