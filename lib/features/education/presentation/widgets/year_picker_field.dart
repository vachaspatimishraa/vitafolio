import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Year Picker Field component supporting Material 3 year selection.
class YearPickerField extends StatelessWidget {
  final String label;
  final String? value;
  final bool enabled;
  final ValueChanged<String> onYearSelected;

  const YearPickerField({
    super.key,
    required this.label,
    required this.value,
    this.enabled = true,
    required this.onYearSelected,
  });

  void _showYearPicker(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final int currentYear = DateTime.now().year;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select $label'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1970),
              lastDate: DateTime(2035),
              selectedDate: DateTime(
                int.tryParse(value ?? '') ?? currentYear,
              ),
              onChanged: (DateTime dateTime) {
                onYearSelected(dateTime.year.toString());
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Select $label',
      button: true,
      child: InkWell(
        onTap: enabled ? () => _showYearPicker(context) : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusTextField),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            enabled: enabled,
            prefixIcon: const Icon(Icons.calendar_today_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusTextField),
            ),
            filled: !enabled,
            fillColor: enabled ? null : colorScheme.surfaceContainerHigh,
          ),
          child: Text(
            value ?? (enabled ? 'Select Year' : 'Present'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: enabled
                  ? (value != null ? colorScheme.onSurface : colorScheme.onSurfaceVariant)
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontWeight: !enabled ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
