import 'package:flutter/material.dart';

/// A reusable premium Material 3 Discard Changes Confirmation Dialog.
class DiscardChangesDialog extends StatelessWidget {
  final String title;
  final String message;
  final String discardLabel;
  final String cancelLabel;
  final VoidCallback? onDiscard;
  final VoidCallback? onCancel;

  const DiscardChangesDialog({
    super.key,
    this.title = 'Discard Changes',
    this.message =
        'Are you sure you want to discard your changes? All unsaved updates will be lost.',
    this.discardLabel = 'Discard',
    this.cancelLabel = 'Keep Editing',
    this.onDiscard,
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
            if (onDiscard != null) onDiscard!();
            Navigator.of(context).pop(true);
          },
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          child: Text(discardLabel),
        ),
      ],
    );
  }
}
