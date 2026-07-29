import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'template_renderer.dart';
import '../../preview/widgets/resume_header.dart';

class CreativeTemplateRenderer implements TemplateRenderer {
  const CreativeTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResumeHeader(personalInfo: resumeData.personalInfo),
        const SizedBox(height: 12),
        if (resumeData.summary.isNotEmpty) ...[
          Text(
            'SUMMARY',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(resumeData.summary, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
