import 'package:flutter/material.dart';

/// Multiline responsibilities text editor with live character counter.
class ResponsibilitiesEditor extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final int maxCharacters;

  const ResponsibilitiesEditor({
    super.key,
    required this.controller,
    required this.onChanged,
    this.maxCharacters = 1000,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final int currentLength = controller.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 7,
          maxLength: maxCharacters,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: 'Responsibilities & Achievements *',
            alignLabelWithHint: true,
            hintText:
                'Describe your responsibilities, achievements, and technologies used...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            counterText: '', // Custom live character counter below
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$currentLength / $maxCharacters Characters',
            style: theme.textTheme.bodySmall?.copyWith(
              color: currentLength > maxCharacters
                  ? colorScheme.error
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
