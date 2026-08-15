import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Tile displaying section title, status badge (Completed vs Missing), and an Edit button callback.
class ResumeSectionTile extends StatelessWidget {
  final String title;
  final bool completed;
  final VoidCallback onEdit;

  const ResumeSectionTile({
    super.key,
    required this.title,
    required this.completed,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
            size: 20,
            color: completed ? Colors.green : Colors.amber,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: completed
                  ? Colors.green.withValues(alpha: 0.12)
                  : Colors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              completed ? 'Completed' : 'Missing',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: completed ? Colors.green : Colors.amber.shade800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: colorScheme.onSurfaceVariant,
            onPressed: onEdit,
            tooltip: 'Edit $title',
          ),
        ],
      ),
    );
  }
}
