import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Multiline description editor with live character counter (0 / 500 Characters).
class DescriptionEditor extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final int maxCharacters;

  const DescriptionEditor({
    super.key,
    required this.controller,
    required this.onChanged,
    this.maxCharacters = 500,
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
            labelText: 'Description / Achievements',
            alignLabelWithHint: true,
            hintText:
                'Describe your academic achievements, relevant coursework, or honors...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusTextField),
            ),
            counterText: '',
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
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
