import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../shared/widgets/cards/statistics_card.dart';
import '../view_model/home_view_model.dart';

class StatisticsSection extends ConsumerWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (totalCount, draftCount, completedCount, archivedCount) = ref.watch(
      homeViewModelProvider.select(
        (s) => (s.totalCount, s.draftCount, s.completedCount, s.archivedCount),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use a responsive layout based on screen width
          final isNarrow = constraints.maxWidth < 500;

          if (isNarrow) {
            // Two rows of cards for narrow screens
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatisticsCard(
                        title: AppStrings.totalResumes,
                        value: totalCount.toString(),
                        icon: Icons.description_outlined,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: StatisticsCard(
                        title: AppStrings.draftResumes,
                        value: draftCount.toString(),
                        icon: Icons.edit_document,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: StatisticsCard(
                        title: AppStrings.completedResumes,
                        value: completedCount.toString(),
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: StatisticsCard(
                        title: AppStrings.archivedResumes,
                        value: archivedCount.toString(),
                        icon: Icons.archive_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          // Single row for wider screens
          return IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: StatisticsCard(
                    title: AppStrings.totalResumes,
                    value: totalCount.toString(),
                    icon: Icons.description_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: StatisticsCard(
                    title: AppStrings.draftResumes,
                    value: draftCount.toString(),
                    icon: Icons.edit_document,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: StatisticsCard(
                    title: AppStrings.completedResumes,
                    value: completedCount.toString(),
                    icon: Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: StatisticsCard(
                    title: AppStrings.archivedResumes,
                    value: archivedCount.toString(),
                    icon: Icons.archive_outlined,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
