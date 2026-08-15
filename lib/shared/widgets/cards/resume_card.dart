import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Vitafolio v2.0 Resume Card dynamically reading from ThemeData
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

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: theme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Thumbnail Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.description_rounded,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (professionalTitle != null &&
                              professionalTitle!.isNotEmpty)
                            _buildBadge(context, professionalTitle!),
                          _buildBadge(context, templateName),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Updated $lastUpdated',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing case final Widget widget)
                  Theme(
                    data: theme.copyWith(
                      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
                    ),
                    child: widget,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
