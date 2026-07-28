import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/router.dart';

class CreateResumeButton extends StatelessWidget {
  const CreateResumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => context.pushNamed(AppRoutes.editor),
      icon: const Icon(Icons.add),
      label: const Text(AppStrings.createResume),
    );
  }
}
