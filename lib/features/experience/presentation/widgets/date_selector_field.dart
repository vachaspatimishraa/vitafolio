import 'package:flutter/material.dart';

/// Month & Year Date Selector Field Widget.
class DateSelectorField extends StatelessWidget {
  final String label;
  final String? value;
  final bool enabled;
  final VoidCallback onTap;

  const DateSelectorField({
    super.key,
    required this.label,
    required this.value,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          prefixIcon: const Icon(Icons.calendar_month_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: !enabled,
          fillColor: enabled ? null : colorScheme.surfaceContainerHigh,
        ),
        child: Text(
          value ?? (enabled ? 'Select Date' : 'Present'),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: enabled
                ? (value != null ? colorScheme.onSurface : colorScheme.onSurfaceVariant)
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            fontWeight: !enabled ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
