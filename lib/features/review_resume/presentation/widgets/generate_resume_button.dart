import 'package:flutter/material.dart';

/// Primary CTA button to trigger resume generation via callback.
class GenerateResumeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;

  const GenerateResumeButton({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.surfaceContainerHigh,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.picture_as_pdf_outlined),
        label: Text(
          'Generate Resume',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isEnabled ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
