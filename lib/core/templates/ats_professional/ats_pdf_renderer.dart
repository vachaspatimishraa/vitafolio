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
    final themeData = FontCache().getThemeForFontSync(resumeData.fontFamily);
    final pdf = pw.Document(theme: themeData);
    final widgets = <pw.Widget>[];

    final textDark = PdfColor.fromHex('111111');
    final subtextColor = PdfColor.fromHex('444444');
    final lineGrey = PdfColor.fromHex('CCCCCC');

    // Header Section
    widgets.add(_buildHeader(resumeData, textDark));
    widgets.add(pw.SizedBox(height: 14));

    // Summary Section
    if (PdfSectionHelper.hasSummary(resumeData.summary)) {
      widgets.addAll([
        _buildSectionTitle('Summary', textDark, lineGrey),
        pw.Text(
          resumeData.summary.trim(),
          style: pw.TextStyle(fontSize: 9.5, color: textDark, lineSpacing: 1.4),
        ),
        pw.SizedBox(height: 14),
      ]);
    }

    // Technical Skills Section
    final validSkills = PdfSectionHelper.validSkillStrings(resumeData.skills);
    if (validSkills.isNotEmpty) {
      widgets.add(_buildSectionTitle('Technical Skills', textDark, lineGrey));
      for (final skill in validSkills) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Text(
              skill,
              style: pw.TextStyle(fontSize: 9.5, color: textDark),
            ),
          ),
        );
      }
      widgets.add(pw.SizedBox(height: 14));
    }

    // Projects Section
    final validProj = PdfSectionHelper.validProjects(resumeData.projects);
    if (validProj.isNotEmpty) {
      widgets.add(_buildSectionTitle('Projects', textDark, lineGrey));
      for (final proj in validProj) {
        final title = proj.projectName?.trim() ?? '';
        final tech = proj.technologies?.trim() ?? '';
        final titleTech = [
          if (title.isNotEmpty) title,
          if (tech.isNotEmpty) tech,
        ].join(' - ');

        final descLines = <String>[];
        if (proj.description?.trim().isNotEmpty == true) {
          final rawLines = proj.description!.split('\n');
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
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (titleTech.isNotEmpty)
                  pw.Text(
                    titleTech,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                if (descLines.isNotEmpty) ...[
                  pw.SizedBox(height: 3),
                  ...descLines.map(
                    (line) => pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 8, bottom: 2),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('- ', style: pw.TextStyle(fontSize: 9.5, color: textDark)),
                          pw.Expanded(
                            child: pw.Text(
                              line,
                              style: pw.TextStyle(fontSize: 9.5, color: textDark),
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
      widgets.add(pw.SizedBox(height: 12));
    }

    // Professional Experience Section
    final validExp = PdfSectionHelper.validExperiences(resumeData.experience);
    if (validExp.isNotEmpty) {
      widgets.add(_buildSectionTitle('Experience', textDark, lineGrey));
      for (final exp in validExp) {
        final title = exp.position?.trim() ?? '';
        final company = exp.company?.trim() ?? '';
        final titleCompany = [
          if (title.isNotEmpty) title,
          if (company.isNotEmpty) company,
        ].join(' - ');

        final dateStr =
            '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}';

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
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    if (titleCompany.isNotEmpty)
                      pw.Expanded(
                        child: pw.Text(
                          titleCompany,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                    if (dateStr.isNotEmpty)
                      pw.Text(
                        dateStr,
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                  ],
                ),
                if (exp.location?.trim().isNotEmpty == true) ...[
                  pw.SizedBox(height: 1),
                  pw.Text(
                    exp.location!.trim(),
                    style: pw.TextStyle(
                      fontSize: 8.5,
                      fontStyle: pw.FontStyle.italic,
                      color: subtextColor,
                    ),
                  ),
                ],
                if (descLines.isNotEmpty) ...[
                  pw.SizedBox(height: 3),
                  ...descLines.map(
                    (line) => pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 8, bottom: 2),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('- ', style: pw.TextStyle(fontSize: 9.5, color: textDark)),
                          pw.Expanded(
                            child: pw.Text(
                              line,
                              style: pw.TextStyle(fontSize: 9.5, color: textDark),
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
      widgets.add(pw.SizedBox(height: 12));
    }

    // Education Section
    final validEdu = PdfSectionHelper.validEducation(resumeData.education);
    if (validEdu.isNotEmpty) {
      widgets.add(_buildSectionTitle('Education', textDark, lineGrey));
      for (final edu in validEdu) {
        final degree = [
          if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
          if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
        ].join(' in ');

        final school = edu.school?.trim() ?? '';
        final dateStr =
            '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "Present" : _formatDate(edu.endDate)}';

        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    if (degree.isNotEmpty)
                      pw.Expanded(
                        child: pw.Text(
                          degree,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                    if (dateStr.isNotEmpty)
                      pw.Text(
                        dateStr,
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                  ],
                ),
                if (school.isNotEmpty) ...[
                  pw.SizedBox(height: 1),
                  pw.Text(
                    school,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontStyle: pw.FontStyle.italic,
                      color: subtextColor,
                    ),
                  ),
                ],
                if (edu.grade?.trim().isNotEmpty == true) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'GPA: ${edu.grade!.trim()}',
                    style: pw.TextStyle(fontSize: 9, color: textDark),
                  ),
                ],
              ],
            ),
          ),
        );
      }
      widgets.add(pw.SizedBox(height: 12));
    }

    // Certifications Section
    final validCerts = PdfSectionHelper.validCertifications(
      resumeData.certifications,
    );
    if (validCerts.isNotEmpty) {
      widgets.add(_buildSectionTitle('Certifications & Achievements', textDark, lineGrey));
      for (final cert in validCerts) {
        final name = cert.certificateName?.trim() ?? '';
        final org = cert.organization?.trim() ?? '';
        final nameOrg = [
          if (name.isNotEmpty) name,
          if (org.isNotEmpty) org,
        ].join(' - ');

        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4, left: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildBulletDot(textDark),
                pw.Expanded(
                  child: pw.Text(
                    nameOrg,
                    style: pw.TextStyle(fontSize: 9.5, color: textDark),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      widgets.add(pw.SizedBox(height: 12));
    }

    // Languages Section
    final validLangs = PdfSectionHelper.validLanguages(resumeData.languages);
    if (validLangs.isNotEmpty) {
      widgets.add(_buildSectionTitle('Languages', textDark, lineGrey));
      for (final lang in validLangs) {
        final name = lang.language?.trim() ?? '';
        final prof = lang.proficiency.name;
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3, left: 8),
            child: pw.Row(
              children: [
                _buildBulletDot(textDark),
                pw.Text(
                  name,
                  style: pw.TextStyle(fontSize: 9.5, color: textDark),
                ),
                if (prof.isNotEmpty) ...[
                  pw.Text(
                    ' ($prof)',
                    style: pw.TextStyle(fontSize: 8.5, color: subtextColor),
                  ),
                ],
              ],
            ),
          ),
        );
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) => widgets,
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(WorkflowState resumeData, PdfColor textDark) {
    final info = resumeData.personalInfo;
    final items = [
      if (info.phone?.trim().isNotEmpty == true) info.phone!.trim(),
      if (info.email?.trim().isNotEmpty == true) info.email!.trim(),
      if (info.linkedIn?.trim().isNotEmpty == true) 'in/${info.linkedIn!.trim()}',
      if (info.github?.trim().isNotEmpty == true) 'github.com/${info.github!.trim()}',
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        info.portfolioWebsite!.trim(),
    ];

    final contactChildren = <pw.Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        contactChildren.add(
          pw.Text('  |  ', style: pw.TextStyle(fontSize: 9, color: textDark)),
        );
      }
      contactChildren.add(
        pw.Text(items[i], style: pw.TextStyle(fontSize: 9, color: textDark)),
      );
    }

    final fullName = info.fullName?.trim().isNotEmpty == true
        ? info.fullName!.trim().toUpperCase()
        : 'VIKASH CHAURASIYA';
    final jobTitle = info.jobTitle?.trim().isNotEmpty == true
        ? info.jobTitle!.trim()
        : null;

    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(
            fullName,
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 2.0,
              color: textDark,
            ),
          ),
          if (jobTitle != null) ...[
            pw.SizedBox(height: 3),
            pw.Text(
              jobTitle,
              style: pw.TextStyle(
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: textDark,
              ),
            ),
          ],
          if (contactChildren.isNotEmpty) ...[
            pw.SizedBox(height: 6),
            pw.Wrap(
              alignment: pw.WrapAlignment.center,
              crossAxisAlignment: pw.WrapCrossAlignment.center,
              children: contactChildren,
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildSectionTitle(String title, PdfColor textDark, PdfColor lineGrey) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: textDark,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Container(height: 1, color: lineGrey),
        pw.SizedBox(height: 8),
      ],
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
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
