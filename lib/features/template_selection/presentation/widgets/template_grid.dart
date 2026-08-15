import 'package:flutter/material.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart';
import 'package:vitafolio/features/template_selection/presentation/widgets/template_card.dart';

/// Grid widget laying out real template cards responsively.
class TemplateGrid extends StatelessWidget {
  final List<ResumeTemplate> templates;
  final String? selectedTemplateId;
  final ValueChanged<ResumeTemplate> onSelect;
  final ValueChanged<ResumeTemplate> onPreview;

  const TemplateGrid({
    super.key,
    required this.templates,
    required this.selectedTemplateId,
    required this.onSelect,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 900) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            final isSelected = template.id == selectedTemplateId;

            return TemplateCard(
              template: template,
              isSelected: isSelected,
              onTap: () => onSelect(template),
              onPreviewTap: () => onPreview(template),
            );
          },
        );
      },
    );
  }
}
