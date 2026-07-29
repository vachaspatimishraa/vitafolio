import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as fm;
import '../../../features/workflow/models/workflow_state.dart';
import '../renderers/template_renderer.dart';
import '../themes/template_theme.dart';
import '../widgets/pdf_preview_widget.dart';
import 'executive_theme.dart';

class ExecutivePdfRenderer extends ResumeTemplateRenderer {
  const ExecutivePdfRenderer();

  @override
  ResumeTheme theme() => executiveTheme;

  @override
  fm.Widget buildPreview(WorkflowState resumeData, fm.BuildContext context) {
    return PdfPreviewWidget(pdf: buildPdf(resumeData));
  }

  @override
  pw.Document buildPdf(WorkflowState resumeData) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) => [
          _buildHeader(resumeData),
          pw.SizedBox(height: 12),
          if (resumeData.summary.isNotEmpty) ...[
            _buildSectionTitle('Profile'),
            pw.Text(resumeData.summary, style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 12),
          ],
          if (resumeData.skills.isNotEmpty) ...[
            _buildSectionTitle('Skills'),
            pw.Wrap(
              spacing: 8,
              runSpacing: 6,
              children: resumeData.skills.map((skill) => pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.deepPurple50,
                      border: pw.Border.all(color: PdfColors.deepPurple200, width: 0.5),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Text(skill, style: const pw.TextStyle(fontSize: 9, color: PdfColors.deepPurple900)),
                  )).toList(),
            ),
            pw.SizedBox(height: 12),
          ],
          if (resumeData.experience.isNotEmpty) ...[
            _buildSectionTitle('Professional Experience'),
            ...resumeData.experience.map((exp) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(exp.company ?? '', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple900)),
                          pw.Text(
                            '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}',
                            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(exp.position ?? '', style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
                          pw.Text(exp.location ?? '', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                        ],
                      ),
                      if (exp.description?.isNotEmpty == true) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(exp.description!, style: const pw.TextStyle(fontSize: 9)),
                      ],
                    ],
                  ),
                )),
            pw.SizedBox(height: 12),
          ],
          if (resumeData.education.isNotEmpty) ...[
            _buildSectionTitle('Education'),
            ...resumeData.education.map((edu) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(edu.school ?? '', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple900)),
                          pw.Text(
                            '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "Present" : _formatDate(edu.endDate)}',
                            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('${edu.degree ?? ""} ${edu.fieldOfStudy ?? ""}', style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
                          if (edu.grade?.isNotEmpty == true)
                            pw.Text('GPA: ${edu.grade}', style: const pw.TextStyle(fontSize: 9)),
                        ],
                      ),
                    ],
                  ),
                )),
            pw.SizedBox(height: 12),
          ],
          if (resumeData.languages.isNotEmpty) ...[
            _buildSectionTitle('Languages'),
            pw.Text(
              resumeData.languages.map((l) => '${l.language ?? ""} (${l.proficiency.name})').join(', '),
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(WorkflowState resumeData) {
    final info = resumeData.personalInfo;
    final items = [
      if (info.phone?.isNotEmpty == true) info.phone!,
      if (info.email?.isNotEmpty == true) info.email!,
      if (info.linkedIn?.isNotEmpty == true) info.linkedIn!,
      if (info.github?.isNotEmpty == true) info.github!,
      if (info.portfolioWebsite?.isNotEmpty == true) info.portfolioWebsite!,
    ];

    final children = <pw.Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        children.add(
          pw.Text('   •   ', style: const pw.TextStyle(fontSize: 9, color: PdfColors.amber400)),
        );
      }
      children.add(pw.Text(items[i], style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(info.fullName ?? 'Untitled', style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple900)),
        if (info.jobTitle?.isNotEmpty == true) ...[
          pw.SizedBox(height: 2),
          pw.Text(info.jobTitle!, style: const pw.TextStyle(fontSize: 13, color: PdfColors.deepPurple600)),
        ],
        pw.SizedBox(height: 8),
        if (children.isNotEmpty)
          pw.Wrap(
            crossAxisAlignment: pw.WrapCrossAlignment.center,
            children: children,
          ),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple800)),
        pw.SizedBox(height: 3),
        pw.Divider(thickness: 1.5, color: PdfColors.amber200),
        pw.SizedBox(height: 8),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }
}
