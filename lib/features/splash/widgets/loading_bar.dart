import 'package:flutter/material.dart';

/// Displays a sleek horizontal progress bar for the splash screen matching Stitch design.
class LoadingBar extends StatelessWidget {
  const LoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 120,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      clipBehavior: Clip.antiAlias,
      child: LinearProgressIndicator(
        backgroundColor: colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primaryContainer),
      ),
    );
  }
}

