import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// A dedicated empty state widget displayed when no templates match the
/// current search query or category filter.
///
/// Provides a clear visual indicator and optional reset action.
class EmptyTemplateView extends StatelessWidget {
  /// The search query that produced no results.
  final String query;

  /// Called when the user wants to clear the search / reset filters.
  final VoidCallback? onReset;

  const EmptyTemplateView({super.key, this.query = '', this.onReset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.dashboard_customize_outlined,
                size: 64,
                color: colorScheme.onSecondaryContainer.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              query.isNotEmpty
                  ? 'No templates for "$query"'
                  : 'No templates found',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              query.isNotEmpty
                  ? 'Try a different search term or browse all templates.'
                  : 'No templates are available in this category.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (onReset != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              OutlinedButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.refresh),
                label: const Text('Clear filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
