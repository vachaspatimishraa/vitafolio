import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Reusable small certification provider badge widget (AWS, Google, Microsoft, Meta, etc.).
class CertificationBadge extends StatelessWidget {
  final String text;
  final IconData? icon;

  const CertificationBadge({
    super.key,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
