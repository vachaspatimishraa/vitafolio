import 'package:flutter/material.dart';
import '../../../app/constants/app_strings.dart';
import '../../../shared/widgets/buttons/outlined_button.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

class ActionBar extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSaveDraft;
  final VoidCallback onPreview;

  const ActionBar({
    required this.isLoading,
    required this.onSaveDraft,
    required this.onPreview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppOutlinedButton(
            onPressed: onPreview,
            label: AppStrings.previewResume,
          ),
          PrimaryButton(
            onPressed: onSaveDraft,
            isLoading: isLoading,
            label: AppStrings.saveDraft,
          ),
        ],
      ),
    );
  }
}
