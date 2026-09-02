import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as fm;
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/core/pdf/optimization/font_cache.dart';
import 'package:vitafolio/core/templates/renderers/template_renderer.dart';
import 'package:vitafolio/core/templates/themes/template_theme.dart';
import 'package:vitafolio/core/templates/widgets/pdf_preview_widget.dart';
import 'package:vitafolio/core/templates/ats_professional/ats_theme.dart';

class ClassicPdfRenderer extends ResumeTemplateRenderer {
  const ClassicPdfRenderer();

  @override
  ResumeTheme theme() => atsTheme;

  @override
  fm.Widget buildPreview(WorkflowState resumeData, fm.BuildContext context) {
    return PdfPreviewWidget(pdf: buildPdf(resumeData));
  }

  @override
  pw.Document buildPdf(WorkflowState resumeData) {
    final themeData = FontCache().getThemeForFontSync(resumeData.fontFamily);
    final pdf = pw.Document(theme: themeData);

    final creamBg = PdfColor.fromHex('F9F6F0');
    final dividerColor = PdfColor.fromHex('E2DAD0');
    final textDark = PdfColor.fromHex('1F1F1F');
    final subtextColor = PdfColor.fromHex('4A4A4A');

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
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(36),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: creamBg),
          ),
        ),
        build: (context) {
          return [
            // Header: Left (Name + Job Title), Right (Contact Info Stacked)
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        (info.fullName?.trim().isNotEmpty == true)
                            ? info.fullName!.trim().toUpperCase()
                            : 'KERWIN JEONG',
                        style: pw.TextStyle(
                          color: textDark,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: 3.5,
                        ),
                      ),
                      if (info.jobTitle?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 6),
                        pw.Text(
                          info.jobTitle!.trim().toUpperCase(),
                          style: pw.TextStyle(
                            color: subtextColor,
                            fontSize: 12,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (contactItems.isNotEmpty) ...[
                  pw.SizedBox(width: 20),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: contactItems.map((item) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 3),
                        child: pw.Text(
                          item,
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            color: textDark,
                            fontSize: 9.5,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),

            pw.SizedBox(height: 16),
            pw.Container(height: 1, color: dividerColor),
            pw.SizedBox(height: 16),

            // PROFESSIONAL SUMMARY
            if (PdfSectionHelper.hasSummary(resumeData.summary)) ...[
              _buildSectionTitle('PROFESSIONAL SUMMARY', textDark),
              pw.Text(
                resumeData.summary.trim(),
                style: pw.TextStyle(
                  fontSize: 10,
                  color: textDark,
                  lineSpacing: 1.5,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Container(height: 1, color: dividerColor),
              pw.SizedBox(height: 16),
            ],

            // WORK EXPERIENCE
            if (experienceList.isNotEmpty) ...[
              _buildSectionTitle('WORK EXPERIENCE', textDark),
              ...experienceList.map((exp) {
                final title = exp.position?.trim() ?? '';
                final dateStr =
                    '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}';
                final company = exp.company?.trim() ?? '';

                final titleDate = [
                  if (title.isNotEmpty) title,
                  if (dateStr.isNotEmpty) dateStr,
                ].join(' | ');

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
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (titleDate.isNotEmpty)
                        pw.Text(
                          titleDate,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 11,
                            color: textDark,
                          ),
                        ),
                      if (company.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          company,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: subtextColor,
                          ),
                        ),
                      ],
                      if (descLines.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        ...descLines.map(
                          (line) => pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 4, bottom: 2),
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
                                      lineSpacing: 1.4,
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
              pw.SizedBox(height: 10),
              pw.Container(height: 1, color: dividerColor),
              pw.SizedBox(height: 16),
            ],

            // Bottom Two Column Layout
            pw.Partitions(
              children: [
                // Left Column: Education & Skills
                pw.Partition(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (educationList.isNotEmpty) ...[
                        _buildSectionTitle('ACADEMIC HISTORY', textDark),
                        ...educationList.map((edu) {
                          final school = edu.school?.trim() ?? '';
                          final dateStr =
                              '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "Present" : _formatDate(edu.endDate)}';
                          final schoolDate = [
                            if (school.isNotEmpty) school,
                            if (dateStr.isNotEmpty) dateStr,
                          ].join(' | ');

                          final degree = [
                            if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                            if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                          ].join(' in ');

                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                if (schoolDate.isNotEmpty)
                                  pw.Text(
                                    schoolDate,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10.5,
                                      color: textDark,
                                    ),
                                  ),
                                if (degree.isNotEmpty) ...[
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    degree,
                                    style: pw.TextStyle(
                                      fontSize: 9.5,
                                      color: subtextColor,
                                    ),
                                  ),
                                ],
                                if (edu.grade?.trim().isNotEmpty == true) ...[
                                  pw.SizedBox(height: 2),
                                  pw.Row(
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
                                ],
                              ],
                            ),
                          );
                        }),
                        pw.SizedBox(height: 12),
                      ],

                      if (skillsList.isNotEmpty) ...[
                        _buildSectionTitle('SKILLS', textDark),
                        ...skillsList.map(
                          (skill) => pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 4, bottom: 3),
                            child: pw.Row(
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
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Right Column: Certifications, Projects, Languages
                pw.Partition(
                  width: 220,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (certificationsList.isNotEmpty) ...[
                          _buildSectionTitle('CERTIFICATIONS', textDark),
                          ...certificationsList.map((cert) {
                            return pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 8),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    cert.certificateName?.trim() ?? '',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10.5,
                                      color: textDark,
                                    ),
                                  ),
                                  if (cert.organization?.trim().isNotEmpty == true) ...[
                                    pw.SizedBox(height: 2),
                                    pw.Text(
                                      cert.organization!.trim(),
                                      style: pw.TextStyle(
                                        fontSize: 9.5,
                                        color: subtextColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }),
                          pw.SizedBox(height: 12),
                        ],

                        if (projectsList.isNotEmpty) ...[
                          _buildSectionTitle('PROJECTS', textDark),
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
                                    pw.SizedBox(height: 3),
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
                          pw.SizedBox(height: 12),
                        ],

                        if (languagesList.isNotEmpty) ...[
                          _buildSectionTitle('LANGUAGES', textDark),
                          ...languagesList.map((lang) {
                            final name = lang.language?.trim() ?? '';
                            final prof = lang.proficiency.name;
                            return pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 4, bottom: 3),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

  pw.Widget _buildSectionTitle(String title, PdfColor textDark) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 10.5,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 2.0,
          color: textDark,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}';
  }
}
