import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/router.dart';
import '../../templates/models/template_model.dart';
import '../../templates/repository/template_repository.dart';
import '../view_model/preview_view_model.dart';

class TemplateSelector extends ConsumerWidget {
  const TemplateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewState = ref.watch(previewViewModelProvider);
    final currentTemplate = previewState.selectedTemplate;
    final templates = TemplateRepository().getAllTemplates();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: templates.length + 1,
        itemBuilder: (context, index) {
          if (index == templates.length) {
            // "More Templates" item
            return Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: ActionChip(
                avatar: const Icon(Icons.grid_view, size: 18),
                label: const Text('All Templates'),
                onPressed: () => context.pushNamed(AppRoutes.templates),
              ),
            );
          }

          final template = templates[index];
          final isSelected = currentTemplate?.id == template.id;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(template.name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref.read(previewViewModelProvider.notifier).changeTemplate(template.id);
                }
              },
              selectedColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
