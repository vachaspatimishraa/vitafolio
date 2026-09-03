import 'dart:io';
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
import 'package:vitafolio/core/utils/date_range_formatter.dart';

class ElegantPdfRenderer extends ResumeTemplateRenderer {
  const ElegantPdfRenderer();

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

    final darkHeaderBg = PdfColor.fromHex('221E1F');
    final sidebarBg = PdfColor.fromHex('E4DDD6');
    final textDark = PdfColor.fromHex('1E1E1E');
    final subtextColor = PdfColor.fromHex('4A4A4A');
    final lineGrey = PdfColor.fromHex('888888');

    final info = resumeData.personalInfo;
    final educationList = PdfSectionHelper.validEducation(resumeData.education);
    final experienceList = PdfSectionHelper.validExperiences(resumeData.experience);
    final projectsList = PdfSectionHelper.validProjects(resumeData.projects);
    final certificationsList = PdfSectionHelper.validCertifications(resumeData.certifications);
    final languagesList = PdfSectionHelper.validLanguages(resumeData.languages);
    final skillsList = PdfSectionHelper.validSkillStrings(resumeData.skills);

    final contactItems = <Map<String, String>>[
      if (info.email?.trim().isNotEmpty == true) {'label': 'Email', 'val': info.email!.trim()},
      if (info.phone?.trim().isNotEmpty == true) {'label': 'Phone', 'val': info.phone!.trim()},
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        {'label': 'Website', 'val': info.portfolioWebsite!.trim()},
      if (info.linkedIn?.trim().isNotEmpty == true) {'label': 'LinkedIn', 'val': info.linkedIn!.trim()},
      if (info.github?.trim().isNotEmpty == true) {'label': 'GitHub', 'val': info.github!.trim()},
    ];

    // Profile photo image provider for PDF
    pw.ImageProvider? profileImageProvider;
    final photoPath = info.profileImagePath;
    if (photoPath != null && photoPath.trim().isNotEmpty && File(photoPath).existsSync()) {
      profileImageProvider = pw.MemoryImage(File(photoPath).readAsBytesSync());
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return [
            // Top Header Banner with Overlapping Circle Photo
            pw.SizedBox(
              height: 140,
              child: pw.Stack(
                children: [
                  pw.Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 30,
                    child: pw.Container(
                      height: 110,
                      color: darkHeaderBg,
                      padding: const pw.EdgeInsets.only(left: 200, right: 28),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            (info.fullName?.trim().isNotEmpty == true)
                                ? info.fullName!.trim().toUpperCase()
                                : 'DONNA STROUPE',
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 22,
                              letterSpacing: 2.5,
                            ),
                          ),
                          if (info.jobTitle?.trim().isNotEmpty == true) ...[
                            pw.SizedBox(height: 4),
                            pw.Text(
                              info.jobTitle!.trim(),
                              style: const pw.TextStyle(
                                color: PdfColors.grey300,
                                fontSize: 12,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  pw.Positioned(
                    left: 36,
                    top: 10,
                    child: pw.Container(
                      width: 120,
                      height: 120,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        color: darkHeaderBg,
                        border: pw.Border.all(color: PdfColors.white, width: 3),
                        image: profileImageProvider != null
                            ? pw.DecorationImage(
                                image: profileImageProvider,
                                fit: pw.BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Two-Column Body
            pw.Partitions(
              children: [
                // Left Sidebar (Beige Background)
                pw.Partition(
                  width: 190,
                  child: pw.Container(
                    color: sidebarBg,
                  padding: const pw.EdgeInsets.all(18),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // CONTACT INFO
                      if (contactItems.isNotEmpty) ...[
                        ...contactItems.map(
                          (item) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 8),
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
                        pw.SizedBox(height: 16),
                      ],

                      // EDUCATION
                      if (educationList.isNotEmpty) ...[
                        _buildSidebarHeader('EDUCATION', textDark),
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
                                      fontSize: 10,
                                      color: textDark,
                                    ),
                                  ),
                                if (edu.school?.trim().isNotEmpty == true)
                                  pw.Text(
                                    edu.school!.trim(),
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      color: subtextColor,
                                    ),
                                  ),
                                if (dateStr.isNotEmpty)
                                  pw.Text(
                                    dateStr,
                                    style: pw.TextStyle(
                                      fontSize: 8.5,
                                      color: subtextColor,
                                    ),
                                  ),
                                if (edu.grade?.trim().isNotEmpty == true)
                                  pw.Text(
                                    'GPA: ${edu.grade!.trim()}',
                                    style: pw.TextStyle(
                                      fontSize: 8.5,
                                      color: textDark,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                        pw.SizedBox(height: 14),
                      ],

                      // SKILLS
                      if (skillsList.isNotEmpty) ...[
                        _buildSidebarHeader('SKILLS', textDark),
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
                        pw.SizedBox(height: 14),
                      ],

                      // LANGUAGE
                      if (languagesList.isNotEmpty) ...[
                        _buildSidebarHeader('LANGUAGE', textDark),
                        ...languagesList.map((lang) {
                          final name = lang.language?.trim() ?? '';
                          final prof = lang.proficiency.name;
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Text(
                              prof.isNotEmpty ? '$name ($prof)' : name,
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
              ),

              // Right Main Column (White Background)
              pw.Partition(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(22),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                        // ABOUT ME / SUMMARY
                        if (PdfSectionHelper.hasSummary(resumeData.summary)) ...[
                          _buildMainHeader('About Me', textDark, lineGrey),
                          pw.Text(
                            resumeData.summary.trim(),
                            style: pw.TextStyle(
                              fontSize: 9.5,
                              color: textDark,
                              lineSpacing: 1.5,
                            ),
                          ),
                          pw.SizedBox(height: 18),
                        ],

                        // WORK EXPERIENCE
                        if (experienceList.isNotEmpty) ...[
                          _buildMainHeader('WORK EXPERIENCE', textDark, lineGrey),
                          ...experienceList.map((exp) {
                            final title = exp.position?.trim() ?? '';
                            final company = exp.company?.trim() ?? '';
                            final location = exp.location?.trim() ?? '';
                            final dateStr = DateRangeFormatter.formatExperience(
                              startDate: exp.startDate,
                              endDate: exp.endDate,
                              isCurrentRole: exp.isCurrentlyWorking == true,
                              separator: ' - ',
                            );

                            final companyLocation = [
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
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  if (dateStr.isNotEmpty)
                                    pw.Text(
                                      dateStr,
                                      style: pw.TextStyle(
                                        fontSize: 9,
                                        color: subtextColor,
                                      ),
                                    ),
                                  if (companyLocation.isNotEmpty)
                                    pw.Text(
                                      companyLocation,
                                      style: pw.TextStyle(
                                        fontSize: 9.5,
                                        color: subtextColor,
                                      ),
                                    ),
                                  if (title.isNotEmpty)
                                    pw.Text(
                                      title,
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10.5,
                                        color: textDark,
                                      ),
                                    ),
                                  if (descLines.isNotEmpty) ...[
                                    pw.SizedBox(height: 3),
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
                          pw.SizedBox(height: 14),
                        ],

                        // PROJECTS
                        if (projectsList.isNotEmpty) ...[
                          _buildMainHeader('PROJECTS', textDark, lineGrey),
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
                          pw.SizedBox(height: 14),
                        ],

                        // CERTIFICATIONS
                        if (certificationsList.isNotEmpty) ...[
                          _buildMainHeader('CERTIFICATIONS', textDark, lineGrey),
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
                                        fontSize: 9,
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

  pw.Widget _buildSidebarHeader(String title, PdfColor textDark) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 10.5,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.5,
            color: textDark,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Container(
          height: 1,
          color: textDark,
        ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildMainHeader(String title, PdfColor textDark, PdfColor lineGrey) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.2,
            color: textDark,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Container(
          height: 1,
          color: lineGrey,
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }
}
