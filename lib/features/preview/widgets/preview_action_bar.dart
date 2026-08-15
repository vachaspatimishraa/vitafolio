import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/features/preview/widgets/export_pdf_button.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Edit'),
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
