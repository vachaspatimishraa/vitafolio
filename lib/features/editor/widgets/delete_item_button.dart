import 'package:flutter/material.dart';

import 'package:vitafolio/shared/widgets/buttons/icon_button.dart';

class DeleteItemButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteItemButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: Icons.delete_outline,
      color: Theme.of(context).colorScheme.error,
      tooltip: 'Delete item',
      onPressed: onPressed,
    );
  }
}
