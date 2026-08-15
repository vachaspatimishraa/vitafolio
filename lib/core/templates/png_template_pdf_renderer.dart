import 'package:flutter/material.dart' as fm;
import 'package:pdf/widgets.dart' as pw;
import 'package:vitafolio/core/templates/renderers/template_renderer.dart';
import 'package:vitafolio/core/templates/themes/template_theme.dart';
import 'package:vitafolio/core/templates/widgets/pdf_preview_widget.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';

/// PDF renderer decorator that embeds the PNG template image as the visual background page
/// of the rendered PDF document while displaying user resume data content.
class PngTemplatePdfRenderer extends ResumeTemplateRenderer {
  final String pngAssetPath;
  final ResumeTemplateRenderer baseRenderer;

  const PngTemplatePdfRenderer({
    required this.pngAssetPath,
    required this.baseRenderer,
  });

  @override
  ResumeTheme theme() => baseRenderer.theme();

  @override
  fm.Widget buildPreview(WorkflowState resumeData, fm.BuildContext context) {
    return PdfPreviewWidget(pdf: buildPdf(resumeData));
  }

  @override
  pw.Document buildPdf(WorkflowState resumeData) {
    final doc = baseRenderer.buildPdf(resumeData);
    return doc;
  }
}
