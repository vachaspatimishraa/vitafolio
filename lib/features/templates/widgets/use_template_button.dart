import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';
import 'package:vitafolio/features/templates/view_model/templates_view_model.dart';
import 'package:vitafolio/app/router.dart';

/// A filled "Use Template" button that selects the template in both the
/// templates and workflow view models, then navigates to the Resume Preview
/// screen.
class UseTemplateButton extends ConsumerWidget {
  final String templateId;

  const UseTemplateButton({super.key, required this.templateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      onPressed: () {
        ref
            .read(templatesViewModelProvider.notifier)
            .selectTemplate(templateId);
        ref.read(workflowViewModelProvider.notifier).selectTemplate(templateId);
        ref.read(previewViewModelProvider.notifier).changeTemplate(templateId);
        context.goNamed(AppRoutes.preview);
      },
      icon: const Icon(Icons.check),
      label: const Text('Use Template'),
    );
  }
}
