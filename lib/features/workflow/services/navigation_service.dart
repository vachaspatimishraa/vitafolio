import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../view_model/workflow_view_model.dart';
import '../widgets/validation_dialog.dart';
import './validation_service.dart';
import '../../../app/router.dart';

class NavigationService {
  static void navigateToPreview(BuildContext context, WidgetRef ref) {
    final state = ref.read(workflowViewModelProvider);
    final errors = ValidationService.validateResume(state);

    if (errors.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => ValidationDialog(errors: errors),
      );
    } else {
      context.push(AppRoutes.preview);
    }
  }

  static void handleCreateNewResume(BuildContext context, WidgetRef ref) {
    ref.read(workflowViewModelProvider.notifier).createNewResume();
    context.pushNamed('editor');
  }
}
