import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Information Card displaying "What happens next?" steps.
class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'What happens next?',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildStepRow(context, 'Resume will be read'),
          _buildStepRow(context, 'Available information will be extracted'),
          _buildStepRow(context, 'You can review and edit before importing'),
        ],
      ),
    );
  }

  Widget _buildStepRow(BuildContext context, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
