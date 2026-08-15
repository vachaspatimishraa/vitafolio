import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Reusable Empty Language State placeholder component.
class EmptyLanguageState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyLanguageState({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.g_translate_outlined,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No Languages Added',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Show employers the languages you can communicate in.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Language'),
            ),
          ],
        ),
      ),
    );
  }
}
