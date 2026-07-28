import 'package:flutter/material.dart';

/// A reusable premium Material 3 Information Dialog.
class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String closeLabel;
  final VoidCallback? onClose;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.closeLabel = 'Close',
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () {
            if (onClose != null) onClose!();
            Navigator.of(context).pop();
          },
          child: Text(closeLabel),
        ),
      ],
    );
  }
}
