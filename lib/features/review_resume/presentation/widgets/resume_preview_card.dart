import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Reusable card displaying resume preview thumbnail, template name, ATS badge, and preview callback.
class ResumePreviewCard extends StatelessWidget {
  final String? previewImage;
  final String templateName;
  final bool atsFriendly;
  final VoidCallback onPreview;

  const ResumePreviewCard({
    super.key,
    this.previewImage,
    required this.templateName,
    this.atsFriendly = true,
    required this.onPreview,
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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail / Placeholder
          Container(
            width: 70,
            height: 90,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
            ),
            child: previewImage != null
                ? Image.asset(previewImage!, fit: BoxFit.cover)
                : Icon(
                    Icons.description_outlined,
                    size: 36,
                    color: colorScheme.primary,
                  ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Template Details & Badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  templateName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                if (atsFriendly) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 12,
                          color: Colors.green,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'ATS Friendly',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                OutlinedButton.icon(
                  onPressed: onPreview,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                  label: const Text('Preview'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
