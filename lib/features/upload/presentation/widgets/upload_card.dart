import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Upload Card widget with drag & drop visual styling and browse button.
class UploadCard extends StatelessWidget {
  final VoidCallback onBrowse;

  const UploadCard({
    super.key,
    required this.onBrowse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_upload_outlined,
              size: 42,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Choose Resume',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Drag & Drop or Browse Files',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onBrowse,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              ),
              icon: const Icon(Icons.folder_open, size: 20),
              label: const Text(
                'Browse Files',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
