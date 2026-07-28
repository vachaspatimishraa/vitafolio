import 'package:flutter/material.dart';
import 'app_bottom_sheet.dart';

class BottomSheetOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const BottomSheetOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// A reusable bottom sheet to select from a list of options.
class OptionsBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<BottomSheetOption<T>> options;
  final ValueChanged<T>? onSelected;

  const OptionsBottomSheet({
    super.key,
    required this.title,
    required this.options,
    this.onSelected,
  });

  /// Helper to show the options bottom sheet easily.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<BottomSheetOption<T>> options,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      builder: (context) => OptionsBottomSheet<T>(
        title: title,
        options: options,
        onSelected: (value) => Navigator.of(context).pop(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: title,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            leading: option.icon != null ? Icon(option.icon) : null,
            title: Text(option.label),
            onTap: () {
              if (onSelected != null) {
                onSelected!(option.value);
              }
            },
          );
        },
      ),
    );
  }
}
