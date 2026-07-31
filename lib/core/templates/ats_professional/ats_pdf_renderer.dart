import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as fm;
import '../../../features/workflow/models/workflow_state.dart';
import '../../pdf/helpers/pdf_section_helper.dart';
import '../renderers/template_renderer.dart';
import '../themes/template_theme.dart';
import '../widgets/pdf_preview_widget.dart';
import 'ats_theme.dart';

class AtsPdfRenderer extends ResumeTemplateRenderer {
  const AtsPdfRenderer();

  @override
  ResumeTheme theme() => atsTheme;

  @override
  fm.Widget buildPreview(WorkflowState resumeData, fm.BuildContext context) {
    return PdfPreviewWidget(pdf: buildPdf(resumeData));
  }

  @override
  pw.Document buildPdf(WorkflowState resumeData) {
    final pdf = pw.Document();

    final widgets = <pw.Widget>[];

    widgets.add(_buildHeader(resumeData));
    widgets.add(pw.SizedBox(height: 8));

    if (PdfSectionHelper.hasSummary(resumeData.summary)) {
      widgets.addAll([
        _buildSectionTitle('SUMMARY'),
        pw.Text(resumeData.summary.trim(), style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 10),
      ]);
    }

    final validExp = PdfSectionHelper.validExperiences(resumeData.experience);
    if (validExp.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('EXPERIENCE'),
        ...validExp.map((exp) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(exp.company?.trim() ?? '', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                        '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}',
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(exp.position?.trim() ?? '', style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
                      pw.Text(exp.location?.trim() ?? '', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                  if (exp.description?.trim().isNotEmpty == true) ...[
                    pw.SizedBox(height: 2),
                    pw.Text(exp.description!.trim(), style: const pw.TextStyle(fontSize: 9)),
                  ],
                ],
              ),
            )),
        pw.SizedBox(height: 10),
      ]);
    }

    final validProj = PdfSectionHelper.validProjects(resumeData.projects);
    if (validProj.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('PROJECTS'),
        ...validProj.map((proj) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(proj.projectName?.trim() ?? '', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      if (proj.technologies?.trim().isNotEmpty == true)
                        pw.Text(proj.technologies!.trim(), style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
                    ],
                  ),
                  if (proj.description?.trim().isNotEmpty == true) ...[
                    pw.SizedBox(height: 2),
                    pw.Text(proj.description!.trim(), style: const pw.TextStyle(fontSize: 9)),
                  ],
                ],
              ),
            )),
        pw.SizedBox(height: 10),
      ]);
    }

    final validEdu = PdfSectionHelper.validEducation(resumeData.education);
    if (validEdu.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('EDUCATION'),
        ...validEdu.map((edu) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(edu.school?.trim() ?? '', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                        '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "Present" : _formatDate(edu.endDate)}',
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('${edu.degree?.trim() ?? ""} ${edu.fieldOfStudy?.trim() ?? ""}'.trim(), style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
                      if (edu.grade?.trim().isNotEmpty == true)
                        pw.Text('GPA: ${edu.grade!.trim()}', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ],
              ),
            )),
        pw.SizedBox(height: 10),
      ]);
    }

    final validSkills = PdfSectionHelper.validSkillStrings(resumeData.skills);
    if (validSkills.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('SKILLS'),
        pw.Text(validSkills.join(', '), style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 10),
      ]);
    }

    final validCerts = PdfSectionHelper.validCertifications(resumeData.certifications);
    if (validCerts.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('CERTIFICATIONS'),
        ...validCerts.map((cert) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(cert.certificateName?.trim() ?? '', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                  pw.Text(cert.organization?.trim() ?? '', style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
            )),
        pw.SizedBox(height: 10),
      ]);
    }

    final validLangs = PdfSectionHelper.validLanguages(resumeData.languages);
    if (validLangs.isNotEmpty) {
      widgets.addAll([
        _buildSectionTitle('LANGUAGES'),
        pw.Text(
          validLangs.map((l) => '${l.language!.trim()} (${l.proficiency.name})').join(', '),
          style: const pw.TextStyle(fontSize: 10),
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
      if (info.portfolioWebsite?.trim().isNotEmpty == true) info.portfolioWebsite!.trim(),
    ];

    final children = <pw.Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        children.add(
          pw.Text('  |  ', style: const pw.TextStyle(fontSize: 9)),
        );
      }
      children.add(pw.Text(items[i], style: const pw.TextStyle(fontSize: 9)));
    }

    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(info.fullName?.trim().isNotEmpty == true ? info.fullName!.trim() : 'Untitled', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          if (children.isNotEmpty)
            pw.Wrap(
              alignment: pw.WrapAlignment.center,
              crossAxisAlignment: pw.WrapCrossAlignment.center,
              children: children,
            ),
        ],
      ),
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 2),
        pw.Divider(thickness: 1, color: PdfColors.black),
        pw.SizedBox(height: 6),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }
}

