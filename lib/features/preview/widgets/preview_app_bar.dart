import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_strings.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';

class PreviewAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PreviewAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewState = ref.watch(previewViewModelProvider);
    final resumeTitle = previewState.resume?.title ?? AppStrings.preview;
    final templateName = previewState.selectedTemplate?.name;
    final theme = Theme.of(context);
    final foregroundColor = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.review);
          }
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            resumeTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (templateName != null)
            Text(
              'Template: $templateName',
              style: theme.textTheme.labelSmall?.copyWith(
                    color: foregroundColor.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: IconButton(
            tooltip: 'Custom Font',
            onPressed: () {
              context.push(AppRoutes.customFont);
            },
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2838) : const Color(0xFFF0F2F5),
                border: Border.all(
                  color: isDark ? const Color(0xFF3E4C5E) : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                'A',
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
