import 'package:flutter/material.dart';
import '../dialogs/confirmation_dialog.dart';
import '../dialogs/delete_dialog.dart';
import '../dialogs/discard_changes_dialog.dart';
import '../dialogs/info_dialog.dart';

/// Reusable helper class to display dialogs conveniently.
class DialogHelper {
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      ),
    );
  }

  static Future<bool?> showDelete({
    required BuildContext context,
    required String title,
    required String message,
    String deleteLabel = 'Delete',
    String cancelLabel = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteDialog(
        title: title,
        message: message,
        deleteLabel: deleteLabel,
        cancelLabel: cancelLabel,
      ),
    );
  }

  static Future<bool?> showDiscardChanges({
    required BuildContext context,
    String title = 'Discard Changes',
    String message = 'Are you sure you want to discard your changes?',
    String discardLabel = 'Discard',
    String cancelLabel = 'Keep Editing',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DiscardChangesDialog(
        title: title,
        message: message,
        discardLabel: discardLabel,
        cancelLabel: cancelLabel,
      ),
    );
  }

  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String closeLabel = 'Close',
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) =>
          InfoDialog(title: title, message: message, closeLabel: closeLabel),
    );
  }
}
