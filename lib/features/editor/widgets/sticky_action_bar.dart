import 'package:flutter/material.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../shared/widgets/buttons/outlined_button.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

class StickyActionBar extends StatelessWidget {
  final VoidCallback onSaveDraft;
  final VoidCallback onPreview;

  const StickyActionBar({
    super.key,
    required this.onSaveDraft,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 520;

              final saveButton = PrimaryButton(
                label: 'Save Draft',
                onPressed: onSaveDraft,
                isFullWidth: true,
              );

              final previewButton = AppOutlinedButton(
                label: 'Preview Resume',
                onPressed: onPreview,
                isFullWidth: true,
              );

              if (isCompact) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    saveButton,
                    const SizedBox(height: AppSpacing.sm),
                    previewButton,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: saveButton),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: previewButton),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
