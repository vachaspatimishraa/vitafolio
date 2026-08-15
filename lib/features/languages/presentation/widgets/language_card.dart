import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Card widget displaying language name, proficiency level badge, and edit/delete callbacks.
class LanguageCard extends StatelessWidget {
  final String language;
  final String level;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LanguageCard({
    super.key,
    required this.language,
    required this.level,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.translate_outlined,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    level,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: colorScheme.onSurfaceVariant,
            onPressed: onEdit,
            tooltip: 'Edit Language',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: colorScheme.error,
            onPressed: onDelete,
            tooltip: 'Delete Language',
          ),
        ],
      ),
    );
  }
}
