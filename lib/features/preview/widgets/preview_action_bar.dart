import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_spacing.dart';
import 'export_pdf_button.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../editor/view_model/editor_view_model.dart';
import '../../workflow/view_model/workflow_view_model.dart';
import '../view_model/preview_view_model.dart';
import '../../../app/router.dart';

class PreviewActionBar extends ConsumerWidget {
  const PreviewActionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  final activeResume = ref.read(previewViewModelProvider).resume;
                  if (activeResume != null) {
                    ref.read(editorViewModelProvider.notifier).loadResume(activeResume);
                    ref.read(workflowViewModelProvider.notifier).loadExistingResume(activeResume);
                  }
                  context.push(AppRoutes.editor);
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Resume'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(child: ExportPdfButton()),
          ],
        ),
      ),
    );
  }
}
