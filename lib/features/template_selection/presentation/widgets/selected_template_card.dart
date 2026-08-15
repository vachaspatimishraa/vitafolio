import 'package:flutter/material.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart';

/// Card showing details of currently selected real ResumeTemplate.
class SelectedTemplateCard extends StatelessWidget {
  final ResumeTemplate template;

  const SelectedTemplateCard({
    super.key,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: colorScheme.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Template (${template.category.label})',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  template.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 14,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  'ATS ${template.atsRating}/5',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
