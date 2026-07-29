import 'package:flutter/material.dart';

import '../../../shared/widgets/buttons/secondary_button.dart';

class AddItemButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AddItemButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(label: label, icon: Icons.add, onPressed: onPressed);
  }
}
