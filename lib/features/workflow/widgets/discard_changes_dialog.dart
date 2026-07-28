import 'package:flutter/material.dart';

/// A reusable Material 3 confirmation dialog for discarding unsaved changes.
///
/// Displays the exact messaging specified in the Phase 2.6 workflow rules:
///
/// ```
/// Discard Changes?
///
/// Your current resume has unsaved changes.
///
/// [ Continue Editing ]   [ Discard ]
/// ```
///
/// Returns `true` when the user confirms discarding, `false` otherwise.
class DiscardChangesDialog extends StatelessWidget {
  final String title;
  final String message;
  final String continueEditingLabel;
  final String discardLabel;

  const DiscardChangesDialog({
    super.key,
    this.title = 'Discard Changes?',
    this.message = 'Your current resume has unsaved changes.',
    this.continueEditingLabel = 'Continue Editing',
    this.discardLabel = 'Discard',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(continueEditingLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: Text(discardLabel),
        ),
      ],
    );
  }
}

/// Shows the [DiscardChangesDialog] and returns `true` if the user chose to
/// discard, `false` otherwise.
Future<bool> showDiscardChangesDialog({
  required BuildContext context,
  String? title,
  String? message,
  String? continueEditingLabel,
  String? discardLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => DiscardChangesDialog(
      title: title ?? 'Discard Changes?',
      message: message ?? 'Your current resume has unsaved changes.',
      continueEditingLabel: continueEditingLabel ?? 'Continue Editing',
      discardLabel: discardLabel ?? 'Discard',
    ),
  );
  return result ?? false;
}
