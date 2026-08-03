import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/constants/app_strings.dart';
import 'package:vitafolio/shared/widgets/inputs/search_field.dart';
import 'package:vitafolio/features/home/view_model/home_view_model.dart';

class HomeSearchBar extends ConsumerStatefulWidget {
  const HomeSearchBar({super.key});

  @override
  ConsumerState<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends ConsumerState<HomeSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sync controller with state when state changes externally
    final query = ref.watch(
      homeViewModelProvider.select((state) => state.searchQuery),
    );
    if (_controller.text != query) {
      _controller.text = query;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: query.length),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: SearchField(
        hintText: AppStrings.searchResumes,
        controller: _controller,
        onChanged: (value) {
          ref.read(homeViewModelProvider.notifier).updateSearchQuery(value);
        },
        onClear: () {
          _controller.clear();
          ref.read(homeViewModelProvider.notifier).updateSearchQuery('');
        },
      ),
    );
  }
}
