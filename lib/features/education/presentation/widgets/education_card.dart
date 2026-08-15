import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/shared/widgets/cards/app_card.dart';

import 'package:vitafolio/features/education/presentation/widgets/education_options_menu.dart';

class EducationCard extends StatelessWidget {
  final String degree;
  final String fieldOfStudy;
  final String institution;
  final String startYear;
  final String endYear;
  final String? grade;
  final String? description;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EducationCard({
    super.key,
    required this.degree,
    required this.fieldOfStudy,
    required this.institution,
    required this.startYear,
    required this.endYear,
    this.grade,
    this.description,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            degree,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            fieldOfStudy,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxl), // Space for more menu
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  institution,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '$startYear — $endYear',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (grade != null && grade!.isNotEmpty) ...[
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          grade!,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: EducationOptionsMenu(
              onEdit: onEdit ?? () {},
              onDelete: onDelete ?? () {},
            ),
          ),
        ],
      ),
    );
  }
}
