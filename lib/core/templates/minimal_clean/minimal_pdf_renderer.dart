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

class MinimalPdfRenderer extends ResumeTemplateRenderer {
  const MinimalPdfRenderer();

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

    final darkTitleColor = PdfColor.fromHex('1E2749');
    final textDark = PdfColor.fromHex('222222');
    final subtextColor = PdfColor.fromHex('555555');
    final dividerColor = PdfColor.fromHex('CCCCCC');

    final info = resumeData.personalInfo;
    final educationList = PdfSectionHelper.validEducation(resumeData.education);
    final experienceList = PdfSectionHelper.validExperiences(resumeData.experience);
    final projectsList = PdfSectionHelper.validProjects(resumeData.projects);
    final certificationsList = PdfSectionHelper.validCertifications(resumeData.certifications);
    final languagesList = PdfSectionHelper.validLanguages(resumeData.languages);
    final skillsList = PdfSectionHelper.validSkillStrings(resumeData.skills);

    final contactItems = <String>[
      if (info.email?.trim().isNotEmpty == true) info.email!.trim(),
      if (info.phone?.trim().isNotEmpty == true) info.phone!.trim(),
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
            // Header: Centered Large Bold Title, Contact Info Links Below, Underline
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    (info.fullName?.trim().isNotEmpty == true)
                        ? info.fullName!.trim().toUpperCase()
                        : 'AARYA AGARWAL',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: darkTitleColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 4.0,
                    ),
                  ),
                  if (contactItems.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Text(
                      contactItems.join(' | '),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: textDark,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            pw.SizedBox(height: 16),
            pw.Container(height: 1, color: dividerColor),
            pw.SizedBox(height: 16),

            // Two-Column Body with Vertical Divider
            pw.Partitions(
              children: [
                // Left Column (~60% width): SUMMARY & EXPERIENCE & PROJECTS
                pw.Partition(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // SUMMARY
                      if (PdfSectionHelper.hasSummary(resumeData.summary)) ...[
                        _buildLeftHeader('SUMMARY', darkTitleColor),
                        pw.Text(
                          resumeData.summary.trim(),
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            color: textDark,
                            lineSpacing: 1.4,
                          ),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Container(height: 1, color: dividerColor),
                        pw.SizedBox(height: 16),
                      ],

                      // EXPERIENCE
                      if (experienceList.isNotEmpty) ...[
                        _buildLeftHeader('EXPERIENCE', darkTitleColor),
                        ...experienceList.map((exp) {
                          final title = exp.position?.trim() ?? '';
                          final company = exp.company?.trim() ?? '';
                          final location = exp.location?.trim() ?? '';
                          final dateStr =
                              '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "PRESENT" : _formatDate(exp.endDate)}';

                          final companyLoc = [
                            if (company.isNotEmpty) company,
                            if (location.isNotEmpty) location,
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
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                // Bullet dot
                                pw.Column(
                                  children: [
                                    _buildBulletDot(textDark),
                                  ],
                                ),
                                pw.Expanded(
                                  child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Row(
                                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (company.isNotEmpty)
                                            pw.Text(
                                              company,
                                              style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                fontSize: 10.5,
                                                color: textDark,
                                              ),
                                            ),
                                          if (dateStr.isNotEmpty)
                                            pw.Text(
                                              dateStr,
                                              style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                fontSize: 9,
                                                color: textDark,
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (title.isNotEmpty) ...[
                                        pw.SizedBox(height: 2),
                                        pw.Text(
                                          title,
                                          style: pw.TextStyle(
                                            fontSize: 9.5,
                                            color: subtextColor,
                                          ),
                                        ),
                                      ],
                                      if (companyLoc.isNotEmpty && company.isEmpty) ...[
                                        pw.SizedBox(height: 2),
                                        pw.Text(
                                          companyLoc,
                                          style: pw.TextStyle(
                                            fontSize: 9,
                                            color: subtextColor,
                                          ),
                                        ),
                                      ],
                                      if (descLines.isNotEmpty) ...[
                                        pw.SizedBox(height: 4),
                                        ...descLines.map(
                                          (line) => pw.Padding(
                                            padding: const pw.EdgeInsets.only(left: 2, bottom: 2),
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
                                ),
                              ],
                            ),
                          );
                        }),
                        pw.SizedBox(height: 10),
                        pw.Container(height: 1, color: dividerColor),
                        pw.SizedBox(height: 16),
                      ],

                      // PROJECTS
                      if (projectsList.isNotEmpty) ...[
                        _buildLeftHeader('PROJECTS', darkTitleColor),
                        ...projectsList.map((proj) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 10),
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
                      ],
                    ],
                  ),
                ),

                // Right Column (~40% width): SKILLS, EDUCATION, CERTIFICATIONS, LANGUAGE
              pw.Partition(
                width: 190,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 20),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // SKILLS
                      if (skillsList.isNotEmpty) ...[
                        _buildRightHeader('SKILLS', darkTitleColor),
                        ...skillsList.map(
                          (skill) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                _buildBulletDot(textDark),
                                pw.Expanded(
                                  child: pw.Text(
                                    skill,
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
                        pw.SizedBox(height: 12),
                        pw.Container(height: 1, color: dividerColor),
                        pw.SizedBox(height: 12),
                      ],

                      // EDUCATION
                      if (educationList.isNotEmpty) ...[
                        _buildRightHeader('EDUCATION', darkTitleColor),
                        ...educationList.map((edu) {
                          final dateStr =
                              '${_formatDate(edu.startDate)} - ${_formatDate(edu.endDate)}';
                          final degree = [
                            if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                            if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                          ].join(' ');

                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                if (dateStr.isNotEmpty)
                                  pw.Text(
                                    dateStr,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 9.5,
                                      color: textDark,
                                    ),
                                  ),
                                if (edu.school?.trim().isNotEmpty == true) ...[
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    edu.school!.trim(),
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 9.5,
                                      color: textDark,
                                    ),
                                  ),
                                ],
                                if (degree.isNotEmpty) ...[
                                  pw.SizedBox(height: 3),
                                  pw.Text(
                                    degree,
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      color: textDark,
                                    ),
                                  ),
                                ],
                                if (edu.grade?.trim().isNotEmpty == true) ...[
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    'GPA: ${edu.grade!.trim()}',
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      color: textDark,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                        pw.SizedBox(height: 12),
                        pw.Container(height: 1, color: dividerColor),
                        pw.SizedBox(height: 12),
                      ],

                      // CERTIFICATIONS
                      if (certificationsList.isNotEmpty) ...[
                        _buildRightHeader('CERTIFICATIONS', darkTitleColor),
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
                                    fontSize: 9.5,
                                    color: textDark,
                                  ),
                                ),
                                if (cert.organization?.trim().isNotEmpty == true) ...[
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    cert.organization!.trim(),
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
                        pw.SizedBox(height: 12),
                        pw.Container(height: 1, color: dividerColor),
                        pw.SizedBox(height: 12),
                      ],

                      // LANGUAGE
                      if (languagesList.isNotEmpty) ...[
                        _buildRightHeader('LANGUAGE', darkTitleColor),
                        ...languagesList.map((lang) {
                          final name = lang.language?.trim() ?? '';
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 8),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  name,
                                  style: pw.TextStyle(
                                    fontSize: 9.5,
                                    color: textDark,
                                  ),
                                ),
                                pw.SizedBox(height: 3),
                                pw.Container(
                                  height: 5,
                                  width: double.infinity,
                                  decoration: pw.BoxDecoration(
                                    color: textDark,
                                    borderRadius: const pw.BorderRadius.all(
                                      pw.Radius.circular(3),
                                    ),
                                  ),
                                ),
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

  pw.Widget _buildLeftHeader(String title, PdfColor darkTitleColor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 2.0,
          color: darkTitleColor,
        ),
      ),
    );
  }

  pw.Widget _buildRightHeader(String title, PdfColor darkTitleColor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 2.0,
          color: darkTitleColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}';
  }
}
