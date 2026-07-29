import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../features/workflow/models/workflow_state.dart';
import '../themes/template_theme.dart';

abstract class ResumeTemplateRenderer {
  const ResumeTemplateRenderer();

  /// Generates the PDF document.
  pw.Document buildPdf(WorkflowState resumeData);

  /// Generates the preview Widget.
  Widget buildPreview(WorkflowState resumeData, BuildContext context);

  /// Returns the theme associated with this template.
  ResumeTheme theme();
}
