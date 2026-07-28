import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/templates_view_model.dart';
import '../../../shared/widgets/chips/filter_chip.dart';

class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(templatesViewModelProvider).selectedCategory;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TemplateCategory.values.map((category) {
          final isSelected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AppFilterChip(
              label: category.label,
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref.read(templatesViewModelProvider.notifier).setCategory(category);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
