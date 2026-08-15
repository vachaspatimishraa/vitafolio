import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/app/constants/app_strings.dart';
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';

class PreviewAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PreviewAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewState = ref.watch(previewViewModelProvider);
    final resumeTitle = previewState.resume?.title ?? AppStrings.preview;
    final templateName = previewState.selectedTemplate?.name;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(resumeTitle),
          if (templateName != null)
            Text(
              'Template: $templateName',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
