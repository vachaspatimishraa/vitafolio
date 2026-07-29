import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';

class UnsavedChangesDialog extends StatelessWidget {
  final VoidCallback onDiscard;

  const UnsavedChangesDialog({super.key, required this.onDiscard});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Discard Changes?',
      message:
          'You have unsaved changes. Are you sure you want to leave without saving?',
      confirmLabel: 'Discard',
      cancelLabel: 'Stay',
      isDestructive: true,
      onConfirm: onDiscard,
    );
  }
}
