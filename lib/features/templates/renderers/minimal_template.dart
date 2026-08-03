import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';
import 'package:vitafolio/features/preview/widgets/resume_header.dart';

class MinimalTemplateRenderer implements TemplateRenderer {
  const MinimalTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ResumeHeader(personalInfo: resumeData.personalInfo),
        const SizedBox(height: 12),
      ],
    );
  }
}
