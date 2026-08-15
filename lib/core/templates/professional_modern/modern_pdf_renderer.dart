import 'dart:io';
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

    final deepOceanColor = PdfColor.fromHex('1B365D');
    final textDark = PdfColor.fromHex('222222');
    final textLight = PdfColors.white;
    final lineGrey = PdfColor.fromHex('CCCCCC');

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

    // Profile photo image provider for PDF
    pw.ImageProvider? profileImageProvider;
    final photoPath = info.profileImagePath;
    if (photoPath != null && photoPath.trim().isNotEmpty && File(photoPath).existsSync()) {
      try {
        profileImageProvider = pw.MemoryImage(File(photoPath).readAsBytesSync());
      } catch (_) {}
    }

    final nameParts = (info.fullName?.trim().isNotEmpty == true)
        ? info.fullName!.trim().split(' ')
        : ['RICHARD', 'SANCHEZ'];
    final firstName = nameParts.first.toUpperCase();
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ').toUpperCase() : '';

    // Build Sidebar Items
    final sidebarWidgets = <pw.Widget>[
      pw.Center(
        child: pw.Container(
          width: 110,
          height: 110,
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
            color: PdfColor.fromHex('2C4D6F'),
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
      pw.SizedBox(height: 20),
    ];

    if (contactItems.isNotEmpty) {
      sidebarWidgets.add(_buildSidebarTitle('CONTACT', textLight));
      for (final c in contactItems) {
        sidebarWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Text(
              c['val']!,
              style: const pw.TextStyle(color: PdfColors.white, fontSize: 9),
            ),
          ),
        );
      }
      sidebarWidgets.add(pw.SizedBox(height: 16));
    }

    if (educationList.isNotEmpty) {
      sidebarWidgets.add(_buildSidebarTitle('EDUCATION', textLight));
      for (final edu in educationList) {
        final dateStr =
            '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "PRESENT" : _formatDate(edu.endDate)}';
        final school = edu.school?.trim() ?? '';
        final degree = [
          if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
          if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
        ].join(' in ');

        sidebarWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  dateStr,
                  style: const pw.TextStyle(color: PdfColors.grey300, fontSize: 8.5),
                ),
                if (school.isNotEmpty)
                  pw.Text(
                    school.toUpperCase(),
                    style: pw.TextStyle(
                      color: textLight,
                      fontSize: 9.5,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                if (degree.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 2),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildSidebarBulletDot(),
                        pw.Expanded(
                          child: pw.Text(
                            degree,
                            style: const pw.TextStyle(color: PdfColors.white, fontSize: 8.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (edu.grade?.trim().isNotEmpty == true)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 2),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildSidebarBulletDot(),
                        pw.Expanded(
                          child: pw.Text(
                            'GPA: ${edu.grade!.trim()}',
                            style: const pw.TextStyle(color: PdfColors.white, fontSize: 8.5),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      }
      sidebarWidgets.add(pw.SizedBox(height: 16));
    }

    if (skillsList.isNotEmpty) {
      sidebarWidgets.add(_buildSidebarTitle('SKILLS', textLight));
      for (final skill in skillsList) {
        sidebarWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildSidebarBulletDot(),
                pw.Expanded(
                  child: pw.Text(
                    skill,
                    style: const pw.TextStyle(color: PdfColors.white, fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      sidebarWidgets.add(pw.SizedBox(height: 16));
    }

    if (languagesList.isNotEmpty) {
      sidebarWidgets.add(_buildSidebarTitle('LANGUAGES', textLight));
      for (final l in languagesList) {
        sidebarWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildSidebarBulletDot(),
                pw.Expanded(
                  child: pw.Text(
                    '${l.language!.trim()} (${l.proficiency.name})',
                    style: const pw.TextStyle(color: PdfColors.white, fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    // Build Main Right Column Items
    final mainWidgets = <pw.Widget>[
      pw.Row(
        children: [
          pw.Text(
            '$firstName ',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: textDark,
              letterSpacing: 1.5,
            ),
          ),
          if (lastName.isNotEmpty)
            pw.Text(
              lastName,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: deepOceanColor,
                letterSpacing: 1.5,
              ),
            ),
        ],
      ),
      if (info.jobTitle?.trim().isNotEmpty == true) ...[
        pw.SizedBox(height: 4),
        pw.Text(
          info.jobTitle!.trim().toUpperCase(),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
            letterSpacing: 1.5,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Container(height: 1.5, color: deepOceanColor),
      ],
      pw.SizedBox(height: 18),
    ];

    if (PdfSectionHelper.hasSummary(resumeData.summary)) {
      mainWidgets.addAll([
        _buildMainTitle('PROFILE', textDark, lineGrey),
        pw.Text(
          resumeData.summary.trim(),
          style: pw.TextStyle(fontSize: 9.5, color: textDark, lineSpacing: 1.4),
        ),
        pw.SizedBox(height: 16),
      ]);
    }

    if (experienceList.isNotEmpty) {
      mainWidgets.add(_buildMainTitle('WORK EXPERIENCE', textDark, lineGrey));
      for (final exp in experienceList) {
        final company = exp.company?.trim() ?? '';
        final position = exp.position?.trim() ?? '';
        final dateStr =
            '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "PRESENT" : _formatDate(exp.endDate)}';

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

        mainWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 5,
                  height: 5,
                  margin: const pw.EdgeInsets.only(top: 4, right: 8),
                  decoration: pw.BoxDecoration(
                    color: deepOceanColor,
                    shape: pw.BoxShape.circle,
                  ),
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
                                fontSize: 10.5,
                                fontWeight: pw.FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                          if (dateStr.isNotEmpty)
                            pw.Text(
                              dateStr,
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.grey700,
                              ),
                            ),
                        ],
                      ),
                      if (position.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          position,
                          style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey800),
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
                                _buildDarkBulletDot(textDark),
                                pw.Expanded(
                                  child: pw.Text(
                                    line,
                                    style: pw.TextStyle(fontSize: 9, color: textDark),
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
          ),
        );
      }
      mainWidgets.add(pw.SizedBox(height: 14));
    }

    if (projectsList.isNotEmpty) {
      mainWidgets.add(_buildMainTitle('PROJECTS', textDark, lineGrey));
      for (final proj in projectsList) {
        mainWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
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
                        color: textDark,
                      ),
                    ),
                    if (proj.technologies?.trim().isNotEmpty == true)
                      pw.Text(
                        proj.technologies!.trim(),
                        style: pw.TextStyle(
                          fontSize: 8.5,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                  ],
                ),
                if (proj.description?.trim().isNotEmpty == true) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    proj.description!.trim(),
                    style: pw.TextStyle(fontSize: 9, color: textDark),
                  ),
                ],
              ],
            ),
          ),
        );
      }
      mainWidgets.add(pw.SizedBox(height: 14));
    }

    if (certificationsList.isNotEmpty) {
      mainWidgets.add(_buildMainTitle('CERTIFICATIONS', textDark, lineGrey));
      for (final cert in certificationsList) {
        final certOrgDate = [
          if (cert.organization?.trim().isNotEmpty == true) cert.organization!.trim(),
          if (cert.issueDate != null) _formatDate(cert.issueDate),
        ].join(' | ');

        mainWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  cert.certificateName?.trim() ?? '',
                  style: pw.TextStyle(
                    fontSize: 9.5,
                    fontWeight: pw.FontWeight.bold,
                    color: textDark,
                  ),
                ),
                if (certOrgDate.isNotEmpty)
                  pw.Text(
                    certOrgDate,
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                  ),
              ],
            ),
          ),
        );
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left Column Sidebar (Deep Ocean)
              pw.Container(
                width: 175,
                color: deepOceanColor,
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: sidebarWidgets,
                ),
              ),
              pw.SizedBox(width: 16),
              // Right Column Main Content
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: mainWidgets,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildSidebarTitle(String title, PdfColor color) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: color,
            fontWeight: pw.FontWeight.bold,
            fontSize: 10.5,
            letterSpacing: 1.0,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Divider(color: PdfColors.white, thickness: 0.5),
        pw.SizedBox(height: 6),
      ],
    );
  }

  pw.Widget _buildMainTitle(String title, PdfColor textDark, PdfColor lineGrey) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: textDark,
            fontWeight: pw.FontWeight.bold,
            fontSize: 11,
            letterSpacing: 1.0,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Container(height: 1, color: lineGrey),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildSidebarBulletDot() {
    return pw.Container(
      width: 3,
      height: 3,
      margin: const pw.EdgeInsets.only(top: 3.5, right: 5),
      decoration: const pw.BoxDecoration(
        color: PdfColors.white,
        shape: pw.BoxShape.circle,
      ),
    );
  }

  pw.Widget _buildDarkBulletDot(PdfColor color) {
    return pw.Container(
      width: 3,
      height: 3,
      margin: const pw.EdgeInsets.only(top: 3.5, right: 5),
      decoration: pw.BoxDecoration(
        color: color,
        shape: pw.BoxShape.circle,
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}';
  }
}
