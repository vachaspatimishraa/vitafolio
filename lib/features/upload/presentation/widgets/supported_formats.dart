import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Supported File Formats chip bar displaying accepted file formats & max file size.
class SupportedFormats extends StatelessWidget {
  const SupportedFormats({super.key});

  static const List<String> _formats = ['PDF', 'DOCX', 'DOC', 'PNG', 'JPG', 'JPEG'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Supported Formats',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Max size: 10 MB',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: _formats.map((format) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Text(
                format,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
