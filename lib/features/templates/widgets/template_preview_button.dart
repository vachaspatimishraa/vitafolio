import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/router.dart';

import 'package:vitafolio/features/templates/models/template_model.dart';

class TemplatePreviewButton extends StatelessWidget {
  final TemplateModel template;

  const TemplatePreviewButton({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () =>
          context.pushNamed(AppRoutes.templatePreview, extra: template),
      child: const Text('Preview'),
    );
  }
}
