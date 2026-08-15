import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/templates/view_model/templates_view_model.dart';
import 'package:vitafolio/shared/widgets/inputs/search_field.dart';

/// A search bar that filters templates by name or category.
///
/// Updates [templatesViewModelProvider] as the user types.
class TemplateSearchBar extends ConsumerWidget {
  const TemplateSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(templatesViewModelProvider).searchQuery;

    return SearchField(
      hintText: 'Search templates...',
      initialValue: query,
      onChanged: (value) =>
          ref.read(templatesViewModelProvider.notifier).setSearchQuery(value),
      onClear: () =>
          ref.read(templatesViewModelProvider.notifier).setSearchQuery(''),
    );
  }
}
