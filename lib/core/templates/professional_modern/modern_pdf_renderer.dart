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
    final themeData = FontCache().getThemeForFontSync(resumeData.fontFamily);
    final pdf = pw.Document(theme: themeData);

    final deepOceanColor = PdfColor.fromHex('1B365D');
    final accentTeal = PdfColor.fromHex('0D9488');
    final textDark = PdfColor.fromHex('222222');
    final textMuted = PdfColor.fromHex('555555');
    final lineGrey = PdfColor.fromHex('E2E8F0');

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

    pw.MemoryImage? profileImageProvider;
    if (info.profileImagePath != null && info.profileImagePath!.isNotEmpty) {
      final imgFile = File(info.profileImagePath!);
      if (imgFile.existsSync()) {
        try {
          final bytes = imgFile.readAsBytesSync();
          profileImageProvider = pw.MemoryImage(bytes);
        } catch (_) {}
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          final widgets = <pw.Widget>[];

          // 1. Header with deep blue banner style
          widgets.add(
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: pw.BoxDecoration(
                color: deepOceanColor,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (profileImageProvider != null) ...[
                    pw.Container(
                      width: 56,
                      height: 56,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(color: PdfColors.white, width: 2),
                        image: pw.DecorationImage(
                          image: profileImageProvider,
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 16),
                  ],
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          (info.fullName?.trim().isNotEmpty == true)
                              ? info.fullName!.trim().toUpperCase()
                              : 'RICHARD SANCHEZ',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 2.0,
                          ),
                        ),
                        if (info.jobTitle?.trim().isNotEmpty == true) ...[
                          pw.SizedBox(height: 4),
                          pw.Text(
                            info.jobTitle!.trim(),
                            style: pw.TextStyle(
                              color: PdfColor.fromHex('E0F2FE'),
                              fontSize: 11,
                              letterSpacing: 1.0,
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

          // 2. Contact details bar
          if (contactItems.isNotEmpty) {
            widgets.add(
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 8, bottom: 16),
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('F1F5F9'),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: pw.Center(
                  child: pw.Text(
                    contactItems.join('   |   '),
                    style: pw.TextStyle(
                      color: textMuted,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
            );
          } else {
            widgets.add(pw.SizedBox(height: 14));
          }

          // 3. Professional Summary
          if (PdfSectionHelper.hasSummary(resumeData.summary)) {
            widgets.add(_buildSectionHeader('PROFESSIONAL SUMMARY', deepOceanColor, accentTeal));
            widgets.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 14),
                child: pw.Text(
                  resumeData.summary.trim(),
                  style: pw.TextStyle(
                    fontSize: 9.5,
                    color: textDark,
                    lineSpacing: 1.4,
                  ),
                ),
              ),
            );
          }

          // 4. Work Experience
          if (experienceList.isNotEmpty) {
            widgets.add(_buildSectionHeader('WORK EXPERIENCE', deepOceanColor, accentTeal));
            for (final exp in experienceList) {
              final title = exp.position?.trim() ?? '';
              final dateStr =
                  '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}';
              final company = exp.company?.trim() ?? '';
              final location = exp.location?.trim() ?? '';

              final companyLoc = [
                if (company.isNotEmpty) company,
                if (location.isNotEmpty) location,
              ].join(' • ');

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

              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              title,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 11,
                                color: textDark,
                              ),
                            ),
                          ),
                          if (dateStr.isNotEmpty)
                            pw.Text(
                              dateStr,
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                color: textMuted,
                              ),
                            ),
                        ],
                      ),
                      if (companyLoc.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          companyLoc,
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            color: accentTeal,
                            fontWeight: pw.FontWeight.bold,
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
                                _buildBulletDot(accentTeal),
                                pw.Expanded(
                                  child: pw.Text(
                                    line,
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      color: textDark,
                                      lineSpacing: 1.3,
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
              );
            }
          }

          // 5. Projects
          if (projectsList.isNotEmpty) {
            widgets.add(_buildSectionHeader('KEY PROJECTS', deepOceanColor, accentTeal));
            for (final proj in projectsList) {
              final name = proj.projectName?.trim() ?? '';
              final tech = proj.technologies?.trim() ?? '';
              final desc = proj.description?.trim() ?? '';

              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        name,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10.5,
                          color: textDark,
                        ),
                      ),
                      if (tech.isNotEmpty) ...[
                        pw.SizedBox(height: 1),
                        pw.Text(
                          'Tech: $tech',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            fontStyle: pw.FontStyle.italic,
                            color: textMuted,
                          ),
                        ),
                      ],
                      if (desc.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          desc,
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: textDark,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }
          }

          // 6. Education
          if (educationList.isNotEmpty) {
            widgets.add(_buildSectionHeader('EDUCATION', deepOceanColor, accentTeal));
            for (final edu in educationList) {
              final school = edu.school?.trim() ?? '';
              final dateStr =
                  '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "Present" : _formatDate(edu.endDate)}';
              final degree = [
                if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
              ].join(' in ');

              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              degree.isNotEmpty ? degree : school,
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
                                fontSize: 9,
                                color: textMuted,
                              ),
                            ),
                        ],
                      ),
                      if (degree.isNotEmpty && school.isNotEmpty) ...[
                        pw.SizedBox(height: 1),
                        pw.Text(
                          school,
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            color: textMuted,
                          ),
                        ),
                      ],
                      if (edu.grade?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 1),
                        pw.Text(
                          'Grade/GPA: ${edu.grade!.trim()}',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }
          }

          // 7. Skills
          if (skillsList.isNotEmpty) {
            widgets.add(_buildSectionHeader('SKILLS', deepOceanColor, accentTeal));
            widgets.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: skillsList.map((skill) {
                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('F1F5F9'),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
                        border: pw.Border.all(color: lineGrey),
                      ),
                      child: pw.Text(
                        skill,
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: textDark,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }

          // 8. Certifications
          if (certificationsList.isNotEmpty) {
            widgets.add(_buildSectionHeader('CERTIFICATIONS', deepOceanColor, accentTeal));
            for (final cert in certificationsList) {
              final certName = cert.certificateName?.trim() ?? '';
              final org = cert.organization?.trim() ?? '';
              final date = _formatDate(cert.issueDate);
              final subtitle = [
                if (org.isNotEmpty) org,
                if (date.isNotEmpty) date,
              ].join(' • ');

              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        certName,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 9.5,
                          color: textDark,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        pw.SizedBox(height: 1),
                        pw.Text(
                          subtitle,
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }
          }

          // 9. Languages
          if (languagesList.isNotEmpty) {
            widgets.add(_buildSectionHeader('LANGUAGES', deepOceanColor, accentTeal));
            final langStrings = languagesList.map((lang) {
              final name = lang.language?.trim() ?? '';
              final prof = lang.proficiency.name;
              return prof.isNotEmpty ? '$name ($prof)' : name;
            }).join('   •   ');

            widgets.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text(
                  langStrings,
                  style: pw.TextStyle(
                    fontSize: 9,
                    color: textDark,
                  ),
                ),
              ),
            );
          }

          return widgets;
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildSectionHeader(String title, PdfColor headerColor, PdfColor accentColor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8, bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              color: headerColor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Container(
            height: 2,
            width: double.infinity,
            color: accentColor,
          ),
        ],
      ),
    );
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}';
  }
}
