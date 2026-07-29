import 'package:flutter/material.dart';

import 'app_text_field.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const DatePickerField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hintText: 'Select date',
      initialValue: initialValue,
      readOnly: true,
      suffixIcon: const Icon(Icons.calendar_month_outlined),
      onTap: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (selected != null) {
          final value =
              '${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}';
          onChanged(value);
        }
      },
    );
  }
}
