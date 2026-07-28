import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/constants/app_spacing.dart';
import '../view_model/home_view_model.dart';

class SortMenu extends ConsumerWidget {
  const SortMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSort = ref.watch(homeViewModelProvider).selectedSort;
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<SortOption>(
      initialValue: selectedSort,
      onSelected: (sort) {
        ref.read(homeViewModelProvider.notifier).setSort(sort);
      },
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sort,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              selectedSort.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => SortOption.values.map((sort) {
        final isSelected = sort == selectedSort;
        return PopupMenuItem<SortOption>(
          value: sort,
          child: Row(
            children: [
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 18,
                  color: colorScheme.primary,
                )
              else
                const SizedBox(width: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(
                sort.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? colorScheme.primary : null,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
