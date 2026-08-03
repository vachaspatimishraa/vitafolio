import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';
import 'package:vitafolio/features/preview/widgets/resume_header.dart';

class ModernTemplateRenderer implements TemplateRenderer {
  const ModernTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [ResumeHeader(personalInfo: resumeData.personalInfo)],
          ),
        ),
      ],
    );
  }
}
