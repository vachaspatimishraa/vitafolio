import 'package:flutter/material.dart';

/// Live character counter displaying length vs max capacity with dynamic warning color.
class CharacterCounter extends StatelessWidget {
  final int currentLength;
  final int maxLength;

  const CharacterCounter({
    super.key,
    required this.currentLength,
    this.maxLength = 500,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color textColor = colorScheme.onSurfaceVariant;
    if (currentLength > maxLength) {
      textColor = colorScheme.error;
    } else if (currentLength >= maxLength * 0.9) {
      textColor = Colors.orange;
    }

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ) ??
          TextStyle(color: textColor),
      child: Text('$currentLength / $maxLength Characters'),
    );
  }
}
