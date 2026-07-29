import 'package:flutter/material.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../data/models/enums/resume_status.dart';
import 'app_card.dart';

/// A reusable Card to display details about a resume.
class ResumeCard extends StatelessWidget {
  final String title;
  final String? professionalTitle;
  final String lastUpdated;
  final String templateName;
  final ResumeStatus status;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ResumeCard({
    super.key,
    required this.title,
    this.professionalTitle,
    required this.lastUpdated,
    required this.templateName,
    required this.status,
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
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: status == ResumeStatus.completed
                        ? Colors.green.withValues(alpha: 0.15)
                        : colorScheme.secondaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: status == ResumeStatus.completed
                          ? Colors.green.withValues(alpha: 0.3)
                          : colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    status == ResumeStatus.completed ? 'Completed' : 'Draft',
                    style: textTheme.labelSmall?.copyWith(
                      color: status == ResumeStatus.completed
                          ? (theme.brightness == Brightness.dark
                                ? Colors.greenAccent[200]
                                : Colors.green[700])
                          : colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (trailingWidget != null) ...[trailingWidget],
        ],
      ),
    );
  }
}
