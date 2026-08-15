import 'package:flutter/material.dart';

/// A reusable premium Material 3 Delete Confirmation Dialog.
class DeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final String deleteLabel;
  final String cancelLabel;
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;

  const DeleteDialog({
    super.key,
    required this.title,
    required this.message,
    this.deleteLabel = 'Delete',
    this.cancelLabel = 'Cancel',
    this.onDelete,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            if (onCancel != null) onCancel!();
            Navigator.of(context).pop(false);
          },
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () {
            if (onDelete != null) onDelete!();
            Navigator.of(context).pop(true);
          },
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          child: Text(deleteLabel),
        ),
      ],
    );
  }
}
