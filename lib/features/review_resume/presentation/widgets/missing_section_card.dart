import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Card warning user of a missing required/optional section with a 'Complete' CTA button.
class MissingSectionCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const MissingSectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.4),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 20,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 0,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }
}
