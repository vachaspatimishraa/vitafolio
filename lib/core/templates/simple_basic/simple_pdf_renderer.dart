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

class SimplePdfRenderer extends ResumeTemplateRenderer {
  const SimplePdfRenderer();

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

    final peachCircleColor = PdfColor.fromHex('FFE3D3');
    final textDark = PdfColor.fromHex('1E1E1E');
    final subtextColor = PdfColor.fromHex('555555');

    final info = resumeData.personalInfo;
    final educationList = PdfSectionHelper.validEducation(resumeData.education);
    final experienceList = PdfSectionHelper.validExperiences(resumeData.experience);
    final projectsList = PdfSectionHelper.validProjects(resumeData.projects);
    final certificationsList = PdfSectionHelper.validCertifications(resumeData.certifications);
    final languagesList = PdfSectionHelper.validLanguages(resumeData.languages);
    final skillsList = PdfSectionHelper.validSkillStrings(resumeData.skills);

    final contactItems = <String>[
      if (info.phone?.trim().isNotEmpty == true) 'Telp: ${info.phone!.trim()}',
      if (info.email?.trim().isNotEmpty == true) 'Email: ${info.email!.trim()}',
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        'Website: ${info.portfolioWebsite!.trim()}',
      if (info.linkedIn?.trim().isNotEmpty == true) 'LinkedIn: ${info.linkedIn!.trim()}',
      if (info.github?.trim().isNotEmpty == true) 'GitHub: ${info.github!.trim()}',
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return [
            // Header Banner: Soft Peach Accent Circle + Uppercase Full Name & Pill Job Title Box
            pw.SizedBox(
              height: 120,
              child: pw.Stack(
                children: [
                  pw.Positioned(
                    top: -15,
                    left: -15,
                    child: pw.Container(
                      width: 120,
                      height: 120,
                      decoration: pw.BoxDecoration(
                        color: peachCircleColor,
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                  ),
                  pw.Positioned(
                    top: 20,
                    left: 50,
                    right: 0,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          (info.fullName?.trim().isNotEmpty == true)
                              ? info.fullName!.trim().toUpperCase()
                              : 'CLAUDIA ALVES',
                          style: pw.TextStyle(
                            color: textDark,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: 3.5,
                          ),
                        ),
                        if (info.jobTitle?.trim().isNotEmpty == true) ...[
                          pw.SizedBox(height: 10),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: textDark, width: 1.2),
                              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
                            ),
                            child: pw.Text(
                              info.jobTitle!.trim().toUpperCase(),
                              style: pw.TextStyle(
                                color: textDark,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 9.5,
                                letterSpacing: 1.5,
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

            pw.SizedBox(height: 12),

            // CONTACT
            if (contactItems.isNotEmpty) ...[
              _buildSectionTitle('C O N T A C T', subtextColor),
              ...contactItems.map(
                (item) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6, left: 16),
                  child: pw.Text(
                    item,
                    style: pw.TextStyle(
                      fontSize: 9.5,
                      color: textDark,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 18),
            ],

            // SUMMARY
            if (PdfSectionHelper.hasSummary(resumeData.summary)) ...[
              _buildSectionTitle('S U M M A R Y', subtextColor),
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16),
                child: pw.Text(
                  resumeData.summary.trim(),
                  style: pw.TextStyle(
                    fontSize: 9.5,
                    color: textDark,
                    lineSpacing: 1.5,
                  ),
                ),
              ),
              pw.SizedBox(height: 18),
            ],

            // EXPERIENCE
            if (experienceList.isNotEmpty) ...[
              _buildSectionTitle('E X P E R I E N C E :', subtextColor),
              ...experienceList.map((exp) {
                final title = exp.position?.trim() ?? '';
                final company = exp.company?.trim() ?? '';
                final dateStr =
                    '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}';

                final companyDate = [
                  if (company.isNotEmpty) company,
                  if (dateStr.isNotEmpty) dateStr,
                ].join(' - ');

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
                  padding: const pw.EdgeInsets.only(bottom: 12, left: 16),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (title.isNotEmpty)
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildBulletDot(textDark),
                            pw.Expanded(
                              child: pw.Text(
                                title,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                  color: textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (companyDate.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 10),
                          child: pw.Text(
                            companyDate,
                            style: pw.TextStyle(
                              fontSize: 9.5,
                              color: subtextColor,
                            ),
                          ),
                        ),
                      ],
                      if (descLines.isNotEmpty) ...[
                        pw.SizedBox(height: 3),
                        ...descLines.map(
                          (line) => pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 10, bottom: 2),
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
              _buildSectionTitle('P R O J E C T S :', subtextColor),
              ...projectsList.map((proj) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10, left: 16),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildBulletDot(textDark),
                          pw.Expanded(
                            child: pw.Text(
                              proj.projectName?.trim() ?? '',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                                color: textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (proj.technologies?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 2),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 10),
                          child: pw.Text(
                            'Technologies: ${proj.technologies!.trim()}',
                            style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic,
                              fontSize: 8.5,
                              color: subtextColor,
                            ),
                          ),
                        ),
                      ],
                      if (proj.description?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 2),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 10),
                          child: pw.Text(
                            proj.description!.trim(),
                            style: pw.TextStyle(
                              fontSize: 9.5,
                              color: textDark,
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

            // SKILLS
            if (skillsList.isNotEmpty) ...[
              _buildSectionTitle('S K I L L S :', subtextColor),
              ...skillsList.map(
                (skill) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4, left: 16),
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

            // EDUCATION
            if (educationList.isNotEmpty) ...[
              _buildSectionTitle('E D U C A T I O N :', subtextColor),
              ...educationList.map((edu) {
                final degree = [
                  if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                  if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                ].join(' in ');

                final school = edu.school?.trim() ?? '';
                final dateStr =
                    '${_formatDate(edu.startDate)} - ${_formatDate(edu.endDate)}';

                final schoolDate = [
                  if (school.isNotEmpty) school,
                  if (dateStr.isNotEmpty) dateStr,
                ].join(' - ');

                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10, left: 16),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (degree.isNotEmpty)
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildBulletDot(textDark),
                            pw.Expanded(
                              child: pw.Text(
                                degree,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                  color: textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (schoolDate.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 10),
                          child: pw.Text(
                            schoolDate,
                            style: pw.TextStyle(
                              fontSize: 9.5,
                              color: subtextColor,
                            ),
                          ),
                        ),
                      ],
                      if (edu.grade?.trim().isNotEmpty == true) ...[
                        pw.SizedBox(height: 2),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 10),
                          child: pw.Text(
                            'GPA: ${edu.grade!.trim()}',
                            style: pw.TextStyle(
                              fontSize: 9.5,
                              color: textDark,
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

            // CERTIFICATIONS
            if (certificationsList.isNotEmpty) ...[
              _buildSectionTitle('C E R T I F I C A T I O N S :', subtextColor),
              ...certificationsList.map((cert) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6, left: 16),
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
              pw.SizedBox(height: 14),
            ],

            // LANGUAGES
            if (languagesList.isNotEmpty) ...[
              _buildSectionTitle('L A N G U A G E S :', subtextColor),
              ...languagesList.map((lang) {
                final name = lang.language?.trim() ?? '';
                final prof = lang.proficiency.name;
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4, left: 16),
                  child: pw.Row(
                    children: [
                      _buildBulletDot(textDark),
                      pw.Text(
                        name,
                        style: pw.TextStyle(
                          fontSize: 9.5,
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

  pw.Widget _buildSectionTitle(String title, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 2.5,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}';
  }
}
