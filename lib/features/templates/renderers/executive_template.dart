import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'template_renderer.dart';
import '../../preview/widgets/resume_header.dart';

class ExecutiveTemplateRenderer implements TemplateRenderer {
  const ExecutiveTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResumeHeader(personalInfo: resumeData.personalInfo),
        const SizedBox(height: 12),
      ],
    );
  }
}
