import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/templates/view_model/templates_view_model.dart';
import 'package:vitafolio/features/templates/widgets/template_card.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// A responsive grid that displays template cards.
///
/// Uses [LayoutBuilder] to adapt the column count:
/// - Small phones: 2 columns
/// - Large phones / small tablets: 3 columns
/// - Tablets and larger: 4 columns
class TemplateGrid extends ConsumerWidget {
  const TemplateGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templatesViewModelProvider);
    final templates = state.filteredTemplates;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 720
            ? 4
            : constraints.maxWidth >= 480
            ? 3
            : 2;

        return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.72,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            return TemplateCard(
              template: template,
              isSelected: state.selectedTemplateId == template.id,
            );
          },
        );
      },
    );
  }
}
