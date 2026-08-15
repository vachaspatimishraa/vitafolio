import 'package:flutter/material.dart';
import 'package:vitafolio/features/professional_summary/presentation/widgets/character_counter.dart';

/// Multiline summary editor card with character counter and sample insert button.
class SummaryEditorCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onUseSample;

  const SummaryEditorCard({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onUseSample,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Summary',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: onUseSample,
              icon: const Icon(Icons.auto_awesome_outlined, size: 16),
              label: const Text('Use Sample Summary'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: 7,
          maxLength: 500,
          buildCounter: (
            context, {
            required currentLength,
            required isFocused,
            required maxLength,
          }) =>
              null, // Use custom live character counter below
          onChanged: onChanged,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText:
                'Passionate Flutter Developer with 3+ years of experience building scalable mobile applications. Skilled in Riverpod, clean architecture, and UI animations with a track record of launching successful cross-platform apps.',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            alignLabelWithHint: true,
            filled: true,
            fillColor: colorScheme.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: CharacterCounter(
            currentLength: controller.text.length,
            maxLength: 500,
          ),
        ),
      ],
    );
  }
}
