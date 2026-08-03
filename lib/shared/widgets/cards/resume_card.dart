import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/shared/widgets/cards/app_card.dart';

/// A reusable Card to display details about a resume.
class ResumeCard extends StatelessWidget {
  final String title;
  final String? professionalTitle;
  final String lastUpdated;
  final String templateName;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ResumeCard({
    super.key,
    required this.title,
    this.professionalTitle,
    required this.lastUpdated,
    required this.templateName,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final trailingWidget = trailing;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Styled premium thumbnail mockup
          Container(
            width: 48,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.8),
                  colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 6,
                  right: 6,
                  child: Container(
                    height: 4,
                    color: colorScheme.onPrimary.withValues(alpha: 0.6),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 6,
                  right: 14,
                  child: Container(
                    height: 3,
                    color: colorScheme.onPrimary.withValues(alpha: 0.4),
                  ),
                ),
                Positioned(
                  top: 24,
                  left: 6,
                  right: 10,
                  child: Container(
                    height: 3,
                    color: colorScheme.onPrimary.withValues(alpha: 0.4),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Icon(
                    Icons.description,
                    size: 14,
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (professionalTitle != null &&
                    professionalTitle!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    professionalTitle!,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Template: $templateName',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Updated: $lastUpdated',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),

              ],
            ),
          ),
          if (trailingWidget != null) ...[trailingWidget],
        ],
      ),
    );
  }
}
