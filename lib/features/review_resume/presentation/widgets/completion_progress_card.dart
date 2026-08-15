import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Card rendering completion progress percentage, bar indicator, and completed section stats.
class CompletionProgressCard extends StatelessWidget {
  final int completedSections;
  final int totalSections;
  final double percentage;

  const CompletionProgressCard({
    super.key,
    required this.completedSections,
    this.totalSections = 9,
    required this.percentage,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resume Completion',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '${(percentage * 100).round()}%',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: colorScheme.surfaceContainerHigh,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$completedSections of $totalSections sections completed',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
