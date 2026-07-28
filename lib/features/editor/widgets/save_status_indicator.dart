import 'package:flutter/material.dart';
import '../view_model/editor_state.dart';

class SaveStatusIndicator extends StatelessWidget {
  final SaveStatus status;

  const SaveStatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (status) {
      case SaveStatus.saved:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
            const SizedBox(width: 4),
            Text(
              'Saved',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.green),
            ),
          ],
        );
      case SaveStatus.saving:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Saving...',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.blue),
            ),
          ],
        );
      case SaveStatus.unsaved:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pending_outlined, color: Colors.orange, size: 16),
            const SizedBox(width: 4),
            Text(
              'Unsaved',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange),
            ),
          ],
        );
      case SaveStatus.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 16),
            const SizedBox(width: 4),
            Text(
              'Save Failed',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.red),
            ),
          ],
        );
    }
  }
}
