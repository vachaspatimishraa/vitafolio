import 'package:flutter/material.dart';

class EmptySectionPlaceholder extends StatelessWidget {
  final String sectionName;

  const EmptySectionPlaceholder({super.key, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          '$sectionName section is empty',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
