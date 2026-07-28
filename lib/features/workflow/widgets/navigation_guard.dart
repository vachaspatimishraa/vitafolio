import 'package:flutter/material.dart';
import 'unsaved_changes_dialog.dart';

class NavigationGuard extends StatelessWidget {
  final Widget child;
  final bool hasUnsavedChanges;
  final VoidCallback onDiscard;

  const NavigationGuard({
    super.key,
    required this.child,
    required this.hasUnsavedChanges,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => UnsavedChangesDialog(
            onDiscard: () {
              onDiscard();
              Navigator.of(context).pop(true);
            },
          ),
        );

        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
