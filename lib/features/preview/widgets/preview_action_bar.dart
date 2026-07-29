import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_spacing.dart';
import 'export_pdf_button.dart';

class PreviewActionBar extends StatelessWidget {
  const PreviewActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.pop(),
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
