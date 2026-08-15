import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// CertificationOptionsMenu widget exposing Edit and Delete callbacks via a Material 3 popup menu.
class CertificationOptionsMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CertificationOptionsMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: colorScheme.onSurface),
              const SizedBox(width: AppSpacing.sm),
              const Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: colorScheme.error),
              const SizedBox(width: AppSpacing.sm),
              Text('Delete', style: TextStyle(color: colorScheme.error)),
            ],
          ),
        ),
      ],
    );
  }
}
