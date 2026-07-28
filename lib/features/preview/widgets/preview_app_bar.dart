import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/router.dart';

class PreviewAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PreviewAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text(AppStrings.preview),
      actions: [
        IconButton(
          icon: const Icon(Icons.grid_view),
          tooltip: AppStrings.changeTemplate,
          onPressed: () => context.pushNamed(AppRoutes.templates),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
