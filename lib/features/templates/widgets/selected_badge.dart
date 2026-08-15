import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_colors.dart';

class SelectedBadge extends StatelessWidget {
  const SelectedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        color: Theme.of(context).colorScheme.onPrimary,
        size: 16,
      ),
    );
  }
}
