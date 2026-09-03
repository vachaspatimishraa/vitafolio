import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as fm;
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/core/pdf/optimization/font_cache.dart';
import 'package:vitafolio/core/templates/renderers/template_renderer.dart';
import 'package:vitafolio/core/templates/themes/template_theme.dart';
import 'package:vitafolio/core/templates/widgets/pdf_preview_widget.dart';
import 'package:vitafolio/core/templates/modern_executive/executive_theme.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';

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
    final themeData = FontCache().getThemeForFontSync(resumeData.fontFamily);
    final pdf = pw.Document(theme: themeData);

    final darkNavy = PdfColor.fromHex('13324C');
    final textDark = PdfColor.fromHex('222222');
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
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            // Header Banner
            pw.Container(
              width: double.infinity,
              color: darkNavy,
              padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    (info.fullName?.trim().isNotEmpty == true)
                        ? info.fullName!.trim().toUpperCase()
                        : 'UNTITLED',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 3.0,
                    ),
                  ),
                  if (info.jobTitle?.trim().isNotEmpty == true) ...[
                    pw.SizedBox(height: 6),
                    pw.Text(
                      info.jobTitle!.trim().toUpperCase(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 12,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                  if (contactItems.isNotEmpty) ...[
                    pw.SizedBox(height: 10),
                    pw.Text(
                      contactItems.join('   |   '),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        color: PdfColors.grey300,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // SUMMARY
            if (PdfSectionHelper.hasSummary(resumeData.summary)) ...[
              _buildSectionHeader('SUMMARY', darkNavy),
              pw.Text(
                resumeData.summary.trim(),
                style: pw.TextStyle(
                  fontSize: 10,
                  color: textDark,
                  lineSpacing: 2,
                ),
              ),
              pw.SizedBox(height: 16),
            ],

            // WORK EXPERIENCE
            if (experienceList.isNotEmpty) ...[
              _buildSectionHeader('WORK EXPERIENCE', darkNavy),
              ...experienceList.map((exp) {
                final title = exp.position?.trim() ?? '';
                final company = exp.company?.trim() ?? '';
                final dateStr = DateRangeFormatter.formatExperience(
                  startDate: exp.startDate,
                  endDate: exp.endDate,
                  isCurrentRole: exp.isCurrentlyWorking == true,
                  separator: ' - ',
                );

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
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          if (title.isNotEmpty)
                            pw.Text(
                              title,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 11,
                                color: textDark,
                              ),
                            ),
                          if (dateStr.isNotEmpty)
                            pw.Text(
                              dateStr,
                              style: pw.TextStyle(
                                fontStyle: pw.FontStyle.italic,
                                fontSize: 9.5,
                                color: subtextColor,
                              ),
                            ),
                        ],
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
            ],

            // PROJECTS
            if (projectsList.isNotEmpty) ...[
              _buildSectionHeader('PROJECTS', darkNavy),
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
                          fontSize: 11,
                          color: textDark,
                        ),
                      ),
                      if (proj.technologies?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Technologies: ${proj.technologies!.trim()}',
                          style: pw.TextStyle(
                            fontStyle: pw.FontStyle.italic,
                            fontSize: 9,
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
              pw.SizedBox(height: 10),
            ],

            // Bottom Two Column Section Grid
            pw.Partitions(
              children: [
                // Left Column: Education & Skills
                pw.Partition(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (educationList.isNotEmpty) ...[
                        _buildSectionHeader('EDUCATION', darkNavy),
                        ...educationList.map((edu) {
                          final degree = [
                            if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                            if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                          ].join(' in ');

                          final dateStr = DateRangeFormatter.formatEducation(
                            startDate: edu.startDate,
                            endDate: edu.endDate,
                            isCurrentlyStudying: edu.isCurrentlyStudying == true,
                            separator: ' - ',
                          );

                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                if (degree.isNotEmpty)
                                  pw.Text(
                                    degree,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10.5,
                                      color: textDark,
                                    ),
                                  ),
                                if (edu.school?.trim().isNotEmpty == true || dateStr.isNotEmpty) ...[
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    [
                                      if (edu.school?.trim().isNotEmpty == true) edu.school!.trim(),
                                      if (dateStr.isNotEmpty) dateStr,
                                    ].join(' | '),
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
                                        'Grade / CGPA: ${edu.grade!.trim()}',
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
                        pw.SizedBox(height: 10),
                      ],

                      if (skillsList.isNotEmpty) ...[
                        _buildSectionHeader('CORE SKILLS', darkNavy),
                        pw.Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: skillsList.map((skill) {
                            return pw.Container(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: darkNavy, width: 0.5),
                                borderRadius: pw.BorderRadius.circular(2),
                              ),
                              child: pw.Text(
                                skill,
                                style: pw.TextStyle(
                                  fontSize: 8.5,
                                  color: textDark,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),

                // Right Column: Certifications & Languages
                pw.Partition(
                  width: 220,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (certificationsList.isNotEmpty) ...[
                          _buildSectionHeader('CERTIFICATIONS', darkNavy),
                          ...certificationsList.map((cert) {
                            return pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 6),
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
                        if (languagesList.isNotEmpty) ...[
                          _buildSectionHeader('LANGUAGES', darkNavy),
                          ...languagesList.map((lang) {
                            final name = lang.language?.trim() ?? '';
                            final prof = lang.proficiency.name;

                            return pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 4),
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

  pw.Widget _buildSectionHeader(String title, PdfColor darkNavy) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.2,
            color: darkNavy,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Container(
          height: 1,
          color: darkNavy,
        ),
        pw.SizedBox(height: 8),
      ],
    );
  }
}


