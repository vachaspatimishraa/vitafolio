import 'package:flutter/material.dart';

/// Displays a loading indicator for the splash screen.
///
/// This widget is purely presentational and contains no timing logic.
class LoadingBar extends StatelessWidget {
  /// Creates a [LoadingBar].
  const LoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircularProgressIndicator(color: colorScheme.primary);
  }
}
