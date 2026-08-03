import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as fm;
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/core/templates/renderers/template_renderer.dart';
import 'package:vitafolio/core/templates/themes/template_theme.dart';
import 'package:vitafolio/core/templates/widgets/pdf_preview_widget.dart';
import 'package:vitafolio/core/templates/professional_modern/modern_theme.dart';

class ModernPdfRenderer extends ResumeTemplateRenderer {
  const ModernPdfRenderer();

  @override
  ResumeTheme theme() => modernTheme;

  @override
  fm.Widget buildPreview(WorkflowState resumeData, fm.BuildContext context) {
    return PdfPreviewWidget(pdf: buildPdf(resumeData));
  }

  @override
  pw.Document buildPdf(WorkflowState resumeData) {
    final pdf = pw.Document();

    final widgets = <pw.Widget>[];

    widgets.add(_buildHeader(resumeData));
    widgets.add(pw.SizedBox(height: 12));

    if (PdfSectionHelper.hasSummary(resumeData.summary)) {
      widgets.addAll([
        _buildSectionTitle('Professional Summary'),
        pw.Text(
          resumeData.summary.trim(),
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 12),
      ]);
    }

    final validSkills = PdfSectionHelper.validSkillStrings(resumeData.skills);
    if (validSkills.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('Technical Skills'),
        pw.Text(
          validSkills.join(', '),
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 12),
      ]);
    }

    final validExp = PdfSectionHelper.validExperiences(resumeData.experience);
    if (validExp.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('Experience'),
        ...validExp.map(
          (exp) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      exp.company?.trim() ?? '',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800,
                      ),
                    ),
                    pw.Text(
                      '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      exp.position?.trim() ?? '',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                    pw.Text(
                      exp.location?.trim() ?? '',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                if (exp.description?.trim().isNotEmpty == true) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    exp.description!.trim(),
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ],
            ),
          ),
        ),
        pw.SizedBox(height: 12),
      ]);
    }

    final validProj = PdfSectionHelper.validProjects(resumeData.projects);
    if (validProj.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('Projects'),
        ...validProj.map(
          (proj) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      proj.projectName?.trim() ?? '',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800,
                      ),
                    ),
                    if (proj.technologies?.trim().isNotEmpty == true)
                      pw.Text(
                        proj.technologies!.trim(),
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                  ],
                ),
                if (proj.description?.trim().isNotEmpty == true) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    proj.description!.trim(),
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ],
            ),
          ),
        ),
        pw.SizedBox(height: 12),
      ]);
    }

    final validEdu = PdfSectionHelper.validEducation(resumeData.education);
    if (validEdu.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('Education'),
        ...validEdu.map(
          (edu) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      edu.school?.trim() ?? '',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800,
                      ),
                    ),
                    pw.Text(
                      '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "Present" : _formatDate(edu.endDate)}',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '${edu.degree?.trim() ?? ""} ${edu.fieldOfStudy?.trim() ?? ""}'
                          .trim(),
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                    if (edu.grade?.trim().isNotEmpty == true)
                      pw.Text(
                        'GPA: ${edu.grade!.trim()}',
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        pw.SizedBox(height: 12),
      ]);
    }

    final validCerts = PdfSectionHelper.validCertifications(
      resumeData.certifications,
    );
    if (validCerts.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('Certifications & Achievements'),
        ...validCerts.map(
          (cert) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  cert.certificateName?.trim() ?? '',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  cert.organization?.trim() ?? '',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => widgets,
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(WorkflowState resumeData) {
    final info = resumeData.personalInfo;
    final items = [
      if (info.phone?.trim().isNotEmpty == true) info.phone!.trim(),
      if (info.email?.trim().isNotEmpty == true) info.email!.trim(),
      if (info.linkedIn?.trim().isNotEmpty == true) info.linkedIn!.trim(),
      if (info.github?.trim().isNotEmpty == true) info.github!.trim(),
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        info.portfolioWebsite!.trim(),
    ];

    final children = <pw.Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        children.add(
          pw.Text(
            '   |   ',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey400),
          ),
        );
      }
      children.add(
        pw.Text(
          items[i],
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          info.fullName?.trim().isNotEmpty == true
              ? info.fullName!.trim()
              : 'Untitled',
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blueGrey900,
          ),
        ),
        if (info.jobTitle?.trim().isNotEmpty == true)
          pw.Text(
            info.jobTitle!.trim(),
            style: const pw.TextStyle(fontSize: 13, color: PdfColors.blue700),
          ),
        pw.SizedBox(height: 6),
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
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blueGrey800,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Divider(thickness: 1, color: PdfColors.blueGrey200),
        pw.SizedBox(height: 8),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }
}
