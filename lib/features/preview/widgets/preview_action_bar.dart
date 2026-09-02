import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
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
              child: ElevatedButton.icon(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.review);
                  }
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  'Back to Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2838),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Color(0xFF2E3846)),
                  ),
                ),
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
