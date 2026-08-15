import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Card showing details of selected file with Replace & Remove actions.
class SelectedFileCard extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final VoidCallback onReplace;
  final VoidCallback onRemove;

  const SelectedFileCard({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.onReplace,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: colorScheme.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$fileSize • PDF Document',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'PDF',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                color: colorScheme.error,
                tooltip: 'Remove File',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onReplace,
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('Replace File'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
