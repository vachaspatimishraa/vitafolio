import 'package:flutter/material.dart';
import 'package:vitafolio/shared/widgets/inputs/app_text_field.dart';

/// A premium Material 3 Multiline Field wrapper.
class MultilineField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? initialValue;
  final int maxLength;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const MultilineField({
    super.key,
    required this.label,
    this.hintText,
    this.initialValue,
    this.maxLength = 400,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hintText: hintText,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      maxLines: null,
      minLines: 5,
      maxLength: maxLength,
    );
  }
}
