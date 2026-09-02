import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as fm;
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/core/pdf/optimization/font_cache.dart';
import 'package:vitafolio/core/templates/renderers/template_renderer.dart';
import 'package:vitafolio/core/templates/themes/template_theme.dart';
import 'package:vitafolio/core/templates/widgets/pdf_preview_widget.dart';
import 'package:vitafolio/core/templates/academic_blue/academic_theme.dart';

class AcademicPdfRenderer extends ResumeTemplateRenderer {
  const AcademicPdfRenderer();

  @override
  ResumeTheme theme() => academicTheme;

  @override
  fm.Widget buildPreview(WorkflowState resumeData, fm.BuildContext context) {
    return PdfPreviewWidget(pdf: buildPdf(resumeData));
  }

  @override
  pw.Document buildPdf(WorkflowState resumeData) {
    final themeData = FontCache().getThemeForFontSync(resumeData.fontFamily);
    final pdf = pw.Document(theme: themeData);

    final textDark = PdfColor.fromHex('222222');
    final subtextColor = PdfColor.fromHex('555555');
    final underlineColor = PdfColor.fromHex('DDDDDD');

    final info = resumeData.personalInfo;
    final educationList = PdfSectionHelper.validEducation(resumeData.education);
    final experienceList = PdfSectionHelper.validExperiences(resumeData.experience);
    final projectsList = PdfSectionHelper.validProjects(resumeData.projects);
    final certificationsList = PdfSectionHelper.validCertifications(resumeData.certifications);
    final languagesList = PdfSectionHelper.validLanguages(resumeData.languages);
    final skillsList = PdfSectionHelper.validSkillStrings(resumeData.skills);

    final contactItems = <Map<String, String>>[
      if (info.phone?.trim().isNotEmpty == true) {'label': 'Phone', 'val': info.phone!.trim()},
      if (info.email?.trim().isNotEmpty == true) {'label': 'Email', 'val': info.email!.trim()},
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        {'label': 'Website', 'val': info.portfolioWebsite!.trim()},
      if (info.linkedIn?.trim().isNotEmpty == true) {'label': 'LinkedIn', 'val': info.linkedIn!.trim()},
      if (info.github?.trim().isNotEmpty == true) {'label': 'GitHub', 'val': info.github!.trim()},
    ];

    final nameParts = (info.fullName?.trim().isNotEmpty == true)
        ? info.fullName!.trim().split(' ')
        : ['HENRIETTA', 'MITCHELL'];
    final firstName = nameParts.first.toUpperCase();
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ').toUpperCase() : '';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            pw.Partitions(
              children: [
                // Left Column (~38% width)
                pw.Partition(
                  width: 190,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Header Name
                      pw.Text(
                        firstName,
                        style: pw.TextStyle(
                          color: textDark,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 2.0,
                        ),
                      ),
                      if (lastName.isNotEmpty)
                        pw.Text(
                          lastName,
                          style: pw.TextStyle(
                            color: textDark,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 2.0,
                          ),
                        ),
                      if (info.jobTitle?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 8),
                        pw.Text(
                          info.jobTitle!.trim().toUpperCase(),
                          style: pw.TextStyle(
                            color: subtextColor,
                            fontSize: 9.5,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                      pw.SizedBox(height: 24),

                      // PERSONAL PROFILE / SUMMARY
                      if (PdfSectionHelper.hasSummary(resumeData.summary)) ...[
                        _buildSectionHeader('PERSONAL PROFILE', textDark, underlineColor),
                        pw.Text(
                          resumeData.summary.trim(),
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            color: textDark,
                            lineSpacing: 1.5,
                          ),
                        ),
                        pw.SizedBox(height: 20),
                      ],

                      // CERTIFICATIONS
                      if (certificationsList.isNotEmpty) ...[
                        _buildSectionHeader('CERTIFICATIONS', textDark, underlineColor),
                        ...certificationsList.map((cert) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 8),
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
                          );
                        }),
                        pw.SizedBox(height: 20),
                      ],

                      // CONTACT INFORMATION
                      if (contactItems.isNotEmpty) ...[
                        _buildSectionHeader('CONTACT INFORMATION', textDark, underlineColor),
                        ...contactItems.map(
                          (item) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 6),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  '${item['label']}:',
                                  style: pw.TextStyle(
                                    fontSize: 8.5,
                                    color: subtextColor,
                                  ),
                                ),
                                pw.Text(
                                  item['val']!,
                                  style: pw.TextStyle(
                                    fontSize: 9.5,
                                    color: textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 20),
                      ],

                      // LANGUAGES
                      if (languagesList.isNotEmpty) ...[
                        _buildSectionHeader('LANGUAGES', textDark, underlineColor),
                        ...languagesList.map((lang) {
                          final name = lang.language?.trim() ?? '';
                          final prof = lang.proficiency.name;
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Text(
                              '$name ($prof)',
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                color: textDark,
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),

                // Right Column
              pw.Partition(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 24),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // EMPLOYMENT HISTORY
                      if (experienceList.isNotEmpty) ...[
                        _buildSectionHeader('EMPLOYMENT HISTORY', textDark, underlineColor),
                        ...experienceList.map((exp) {
                          final title = exp.position?.trim() ?? '';
                          final company = exp.company?.trim() ?? '';
                          final dateStr =
                              '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}';

                          final companyDate = [
                            if (company.isNotEmpty) company,
                            if (dateStr.isNotEmpty) '($dateStr)',
                          ].join(' ');

                          final descLines = <String>[];
                          if (exp.description?.trim().isNotEmpty == true) {
                            final rawLines = exp.description!.split('\n');
                            for (final line in rawLines) {
                              final trimmed = line.trim();
                              if (trimmed.isNotEmpty) {
                                if (trimmed.startsWith('-') || trimmed.startsWith('•')) {
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
                                if (title.isNotEmpty)
                                  pw.Text(
                                    title,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 11,
                                      color: textDark,
                                    ),
                                  ),
                                if (companyDate.isNotEmpty) ...[
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    companyDate,
                                    style: pw.TextStyle(
                                      fontSize: 9.5,
                                      color: subtextColor,
                                    ),
                                  ),
                                ],
                                if (descLines.isNotEmpty) ...[
                                  pw.SizedBox(height: 4),
                                  ...descLines.map(
                                    (line) => pw.Padding(
                                      padding: const pw.EdgeInsets.only(bottom: 2),
                                      child: pw.Text(
                                        '- $line',
                                        style: pw.TextStyle(
                                          fontSize: 9.5,
                                          color: textDark,
                                          lineSpacing: 1.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                        pw.SizedBox(height: 14),
                      ],

                      // PREVIOUS EDUCATION
                      if (educationList.isNotEmpty) ...[
                        _buildSectionHeader('PREVIOUS EDUCATION', textDark, underlineColor),
                        ...educationList.map((edu) {
                          final degreeDate = [
                            if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                            if (edu.fieldOfStudy?.trim().isNotEmpty == true) 'in ${edu.fieldOfStudy!.trim()}',
                            if (edu.endDate != null) ', ${_formatDate(edu.endDate)}',
                          ].join(' ');

                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                if (edu.school?.trim().isNotEmpty == true)
                                  pw.Text(
                                    edu.school!.trim(),
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 11,
                                      color: textDark,
                                    ),
                                  ),
                                if (degreeDate.isNotEmpty) ...[
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    degreeDate,
                                    style: pw.TextStyle(
                                      fontSize: 9.5,
                                      color: subtextColor,
                                    ),
                                  ),
                                ],
                                if (edu.grade?.trim().isNotEmpty == true) ...[
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    '- Grade / CGPA: ${edu.grade!.trim()}',
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
                        pw.SizedBox(height: 14),
                      ],

                      // PROJECTS
                      if (projectsList.isNotEmpty) ...[
                        _buildSectionHeader('PROJECTS', textDark, underlineColor),
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
                                      fontSize: 8.5,
                                      color: subtextColor,
                                    ),
                                  ),
                                ],
                                if (proj.description?.trim().isNotEmpty == true) ...[
                                  pw.SizedBox(height: 3),
                                  pw.Text(
                                    '- ${proj.description!.trim()}',
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
                        pw.SizedBox(height: 14),
                      ],

                      // SKILLS AND ABILITIES
                      if (skillsList.isNotEmpty) ...[
                        _buildSectionHeader('SKILLS AND ABILITIES', textDark, underlineColor),
                        ...skillsList.map(
                          (skill) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 3),
                            child: pw.Text(
                              '- $skill',
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                color: textDark,
                              ),
                            ),
                          ),
                        ),
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

  pw.Widget _buildSectionHeader(String title, PdfColor textDark, PdfColor underlineColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.5,
            color: textDark,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Container(
          width: 28,
          height: 2.5,
          color: underlineColor,
        ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
