import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// A badge widget that displays "ATS Friendly" for templates optimized for
/// Applicant Tracking Systems.
///
/// Uses [Theme.of(context)] for styling — never hardcodes colors or sizes.
class TemplateBadge extends StatelessWidget {
  /// Whether to show the filled variant (default) or an outlined variant.
  final bool filled;

  const TemplateBadge({super.key, this.filled = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: filled ? colorScheme.tertiaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(
          color: filled
              ? colorScheme.tertiaryContainer
              : colorScheme.tertiary.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            size: AppSpacing.iconXs,
            color: filled
                ? colorScheme.onTertiaryContainer
                : colorScheme.tertiary,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            'ATS Friendly',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: filled
                  ? colorScheme.onTertiaryContainer
                  : colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
