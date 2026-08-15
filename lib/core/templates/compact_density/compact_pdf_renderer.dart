import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as fm;
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/core/templates/renderers/template_renderer.dart';
import 'package:vitafolio/core/templates/themes/template_theme.dart';
import 'package:vitafolio/core/templates/widgets/pdf_preview_widget.dart';
import 'package:vitafolio/core/templates/ats_professional/ats_theme.dart';

class CompactPdfRenderer extends ResumeTemplateRenderer {
  const CompactPdfRenderer();

  @override
  ResumeTheme theme() => atsTheme;

  @override
  fm.Widget buildPreview(WorkflowState resumeData, fm.BuildContext context) {
    return PdfPreviewWidget(pdf: buildPdf(resumeData));
  }

  @override
  pw.Document buildPdf(WorkflowState resumeData) {
    final pdf = pw.Document();

    final textDark = PdfColor.fromHex('111111');
    final subtextColor = PdfColor.fromHex('555555');

    final info = resumeData.personalInfo;
    final educationList = PdfSectionHelper.validEducation(resumeData.education);
    final experienceList = PdfSectionHelper.validExperiences(resumeData.experience);
    final projectsList = PdfSectionHelper.validProjects(resumeData.projects);
    final certificationsList = PdfSectionHelper.validCertifications(resumeData.certifications);
    final languagesList = PdfSectionHelper.validLanguages(resumeData.languages);
    final skillsList = PdfSectionHelper.validSkillStrings(resumeData.skills);

    final contactItems = <String>[
      if (info.phone?.trim().isNotEmpty == true) info.phone!.trim(),
      if (info.email?.trim().isNotEmpty == true) info.email!.trim(),
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        info.portfolioWebsite!.trim(),
      if (info.linkedIn?.trim().isNotEmpty == true) info.linkedIn!.trim(),
      if (info.github?.trim().isNotEmpty == true) info.github!.trim(),
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return [
            // Header Banner
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        (info.fullName?.trim().isNotEmpty == true)
                            ? info.fullName!.trim()
                            : 'Sebastian Bennett',
                        style: pw.TextStyle(
                          color: textDark,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      if (info.jobTitle?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          info.jobTitle!.trim().toUpperCase(),
                          style: pw.TextStyle(
                            color: subtextColor,
                            fontSize: 11,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                      if (contactItems.isNotEmpty) ...[
                        pw.SizedBox(height: 10),
                        pw.Text(
                          contactItems.join(' | '),
                          style: pw.TextStyle(
                            color: textDark,
                            fontSize: 9.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                pw.Container(
                  width: 3,
                  height: 70,
                  color: PdfColors.black,
                ),
              ],
            ),

            pw.SizedBox(height: 16),

            // SUMMARY
            if (PdfSectionHelper.hasSummary(resumeData.summary)) ...[
              _buildSectionBanner('SUMMARY'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Text(
                  resumeData.summary.trim(),
                  style: pw.TextStyle(
                    fontSize: 9.5,
                    color: textDark,
                    lineSpacing: 1.4,
                  ),
                ),
              ),
            ],

            // WORK EXPERIENCE
            if (experienceList.isNotEmpty) ...[
              _buildSectionBanner('WORK EXPERIENCE'),
              pw.SizedBox(height: 8),
              ...experienceList.map((exp) {
                final title = exp.position?.trim() ?? '';
                final company = exp.company?.trim() ?? '';
                final titleCompany = [
                  if (title.isNotEmpty) title,
                  if (company.isNotEmpty) company,
                ].join(' | ');

                final dateStr =
                    '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "present" : _formatDate(exp.endDate)}';

                final descLines = <String>[];
                if (exp.description?.trim().isNotEmpty == true) {
                  final rawLines = exp.description!.split('\n');
                  for (final line in rawLines) {
                    final trimmed = line.trim();
                    if (trimmed.isNotEmpty) {
                      if (trimmed.startsWith('•') || trimmed.startsWith('-')) {
                        descLines.add(trimmed.replaceAll(RegExp(r'^[\•\-]\s*'), ''));
                      } else {
                        descLines.add(trimmed);
                      }
                    }
                  }
                }

                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              titleCompany,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10.5,
                                color: textDark,
                              ),
                            ),
                          ),
                          if (dateStr.isNotEmpty)
                            pw.Text(
                              dateStr,
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                color: subtextColor,
                              ),
                            ),
                        ],
                      ),
                      if (exp.location?.trim().isNotEmpty == true)
                        pw.Text(
                          exp.location!.trim(),
                          style: pw.TextStyle(
                            fontStyle: pw.FontStyle.italic,
                            fontSize: 8.5,
                            color: subtextColor,
                          ),
                        ),
                      if (descLines.isNotEmpty) ...[
                        pw.SizedBox(height: 3),
                        ...descLines.map(
                          (line) => pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 6, bottom: 2),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                _buildBulletDot(textDark),
                                pw.Expanded(
                                  child: pw.Text(
                                    line,
                                    style: pw.TextStyle(
                                      fontSize: 9.5,
                                      color: textDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],

            // PROJECTS
            if (projectsList.isNotEmpty) ...[
              _buildSectionBanner('PROJECTS'),
              pw.SizedBox(height: 8),
              ...projectsList.map((proj) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        proj.projectName?.trim() ?? '',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10.5,
                          color: textDark,
                        ),
                      ),
                      if (proj.technologies?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Technologies: ${proj.technologies!.trim()}',
                          style: pw.TextStyle(
                            fontStyle: pw.FontStyle.italic,
                            fontSize: 8.5,
                            color: subtextColor,
                          ),
                        ),
                      ],
                      if (proj.description?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          proj.description!.trim(),
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            color: textDark,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],

            // SKILLS
            if (skillsList.isNotEmpty) ...[
              _buildSectionBanner('SKILLS'),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Wrap(
                  spacing: 20,
                  runSpacing: 4,
                  children: skillsList.map((skill) {
                    return pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        _buildBulletDot(textDark),
                        pw.Text(
                          skill,
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            color: textDark,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            // EDUCATION
            if (educationList.isNotEmpty) ...[
              _buildSectionBanner('EDUCATION'),
              pw.SizedBox(height: 8),
              ...educationList.map((edu) {
                final degree = [
                  if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                  if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                ].join(' ');

                final school = edu.school?.trim() ?? '';
                final degreeSchool = [
                  if (degree.isNotEmpty) degree,
                  if (school.isNotEmpty) school,
                ].join(' | ');

                final dateStr =
                    '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "present" : _formatDate(edu.endDate)}';

                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              degreeSchool,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10.5,
                                color: textDark,
                              ),
                            ),
                          ),
                          if (dateStr.isNotEmpty)
                            pw.Text(
                              dateStr,
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                color: subtextColor,
                              ),
                            ),
                        ],
                      ),
                      if (edu.grade?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 2),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 6),
                          child: pw.Row(
                            children: [
                              _buildBulletDot(textDark),
                              pw.Text(
                                'GPA: ${edu.grade!.trim()}',
                                style: pw.TextStyle(
                                  fontSize: 9.5,
                                  color: textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],

            // CERTIFICATIONS
            if (certificationsList.isNotEmpty) ...[
              _buildSectionBanner('CERTIFICATIONS'),
              pw.SizedBox(height: 8),
              ...certificationsList.map((cert) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6, left: 6),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildBulletDot(textDark),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              cert.certificateName?.trim() ?? '',
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                fontWeight: pw.FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            if (cert.organization?.trim().isNotEmpty == true)
                              pw.Text(
                                cert.organization!.trim(),
                                style: pw.TextStyle(
                                  fontSize: 8.5,
                                  color: subtextColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 8),
            ],

            // LANGUAGES
            if (languagesList.isNotEmpty) ...[
              _buildSectionBanner('LANGUAGES'),
              pw.SizedBox(height: 8),
              ...languagesList.map((lang) {
                final name = lang.language?.trim() ?? '';
                final prof = lang.proficiency.name;
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4, left: 6),
                  child: pw.Row(
                    children: [
                      _buildBulletDot(textDark),
                      pw.Text(
                        name,
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      if (prof.isNotEmpty) ...[
                        pw.Text(
                          ' ($prof)',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            color: subtextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ];
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildBulletDot(PdfColor color) {
    return pw.Container(
      width: 3.5,
      height: 3.5,
      margin: const pw.EdgeInsets.only(top: 3.5, right: 6),
      decoration: pw.BoxDecoration(
        color: color,
        shape: pw.BoxShape.circle,
      ),
    );
  }

  pw.Widget _buildSectionBanner(String title) {
    return pw.Container(
      width: double.infinity,
      color: PdfColors.black,
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      margin: const pw.EdgeInsets.only(top: 6, bottom: 4),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 2.0,
          fontSize: 11,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
