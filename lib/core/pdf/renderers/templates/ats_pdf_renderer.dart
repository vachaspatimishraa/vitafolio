import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vitafolio/core/pdf/renderers/base/pdf_renderer.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/data/models/resume_model.dart';
import 'package:vitafolio/data/models/embedded/personal_information.dart';

class AtsPdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();
    final widgets = <pw.Widget>[];

    if (resume.personalInfo != null) {
      widgets.add(_buildHeader(resume.personalInfo!));
      widgets.add(pw.SizedBox(height: 10));
      widgets.add(pw.Divider(thickness: 0.8, color: PdfColors.black));
      widgets.add(pw.SizedBox(height: 14));
    }

    if (PdfSectionHelper.hasSummary(resume.professionalSummary?.summary)) {
      widgets.addAll([
        _buildSectionTitle('SUMMARY'),
        pw.Text(
          resume.professionalSummary!.summary!.trim(),
          style: const pw.TextStyle(fontSize: 9.5, lineSpacing: 2),
        ),
        pw.SizedBox(height: 14),
      ]);
    }

    final validExp = PdfSectionHelper.validExperiences(resume.experience);
    if (validExp.isNotEmpty) {
      widgets.add(_buildSectionTitle('PROFESSIONAL EXPERIENCE'));
      for (final exp in validExp) {
        final titleCompany = [
          if (exp.position?.trim().isNotEmpty == true) exp.position!.trim(),
          if (exp.company?.trim().isNotEmpty == true) exp.company!.trim(),
        ].join(', ');

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
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        titleCompany,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Text(
                      dateStr,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (exp.location?.trim().isNotEmpty == true) ...[
                  pw.SizedBox(height: 1),
                  pw.Text(
                    exp.location!.trim(),
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey700,
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
                          _buildBulletDot(),
                          pw.Expanded(
                            child: pw.Text(
                              line,
                              style: const pw.TextStyle(fontSize: 9.5),
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
      widgets.add(pw.SizedBox(height: 10));
    }

    final validProj = PdfSectionHelper.validProjects(resume.projects);
    if (validProj.isNotEmpty) {
      widgets.add(_buildSectionTitle('PROJECTS'));
      for (final proj in validProj) {
        widgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
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
                      ),
                    ),
                    if (proj.technologies?.trim().isNotEmpty == true)
                      pw.Text(
                        proj.technologies!.trim(),
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                  ],
                ),
                if (proj.description?.trim().isNotEmpty == true) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    proj.description!.trim(),
                    style: const pw.TextStyle(fontSize: 9.5),
                  ),
                ],
              ],
            ),
          ),
        );
      }
      widgets.add(pw.SizedBox(height: 10));
    }

    final validEdu = PdfSectionHelper.validEducation(resume.education);
    if (validEdu.isNotEmpty) {
      widgets.add(_buildSectionTitle('EDUCATION'));
      for (final edu in validEdu) {
        final degreeField = [
          if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
          if (edu.fieldOfStudy?.trim().isNotEmpty == true)
            edu.fieldOfStudy!.trim(),
        ].join(' in ');

        final dateStr =
            '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "Present" : _formatDate(edu.endDate)}';

        widgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        degreeField.isNotEmpty
                            ? degreeField
                            : (edu.school?.trim() ?? ''),
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Text(
                      dateStr,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (degreeField.isNotEmpty &&
                    edu.school?.trim().isNotEmpty == true)
                  pw.Text(
                    edu.school!.trim(),
                    style: const pw.TextStyle(fontSize: 9.5),
                  ),
                if (edu.grade?.trim().isNotEmpty == true) ...[
                  pw.SizedBox(height: 2),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 4),
                    child: pw.Row(
                      children: [
                        _buildBulletDot(),
                        pw.Text(
                          'Grade/GPA: ${edu.grade!.trim()}',
                          style: const pw.TextStyle(fontSize: 9.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }
      widgets.add(pw.SizedBox(height: 10));
    }

    final validSkills = PdfSectionHelper.validSkillModels(resume.skills);
    if (validSkills.isNotEmpty) {
      widgets.add(_buildSectionTitle('TECHNICAL SKILLS'));

      final skillNames = validSkills.map((s) => s.name!.trim()).toList();
      final col1 = <String>[];
      final col2 = <String>[];
      final col3 = <String>[];

      for (var i = 0; i < skillNames.length; i++) {
        if (i % 3 == 0) {
          col1.add(skillNames[i]);
        } else if (i % 3 == 1) {
          col2.add(skillNames[i]);
        } else {
          col3.add(skillNames[i]);
        }
      }

      widgets.add(
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(child: _buildSkillColumn(col1)),
            pw.SizedBox(width: 8),
            pw.Expanded(child: _buildSkillColumn(col2)),
            pw.SizedBox(width: 8),
            pw.Expanded(child: _buildSkillColumn(col3)),
          ],
        ),
      );
      widgets.add(pw.SizedBox(height: 14));
    }

    final validCerts = PdfSectionHelper.validCertifications(
      resume.certifications,
    );
    if (validCerts.isNotEmpty) {
      widgets.add(_buildSectionTitle('CERTIFICATIONS'));
      for (final cert in validCerts) {
        widgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  cert.certificateName?.trim() ?? '',
                  style: pw.TextStyle(
                    fontSize: 9.5,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  cert.organization?.trim() ?? '',
                  style: const pw.TextStyle(fontSize: 9.5),
                ),
              ],
            ),
          ),
        );
      }
      widgets.add(pw.SizedBox(height: 10));
    }

    final validLangs = PdfSectionHelper.validLanguages(resume.languages);
    if (validLangs.isNotEmpty) {
      widgets.add(_buildSectionTitle('LANGUAGES'));
      widgets.add(
        pw.Text(
          validLangs
              .map((l) => '${l.language!.trim()} (${l.proficiency.name})')
              .join(', '),
          style: const pw.TextStyle(fontSize: 9.5),
        ),
      );
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

  pw.Widget _buildHeader(PersonalInformation info) {
    final items = [
      if (info.phone?.trim().isNotEmpty == true) info.phone!.trim(),
      if (info.email?.trim().isNotEmpty == true) info.email!.trim(),
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        info.portfolioWebsite!.trim(),
      if (info.linkedIn?.trim().isNotEmpty == true) info.linkedIn!.trim(),
      if (info.github?.trim().isNotEmpty == true) info.github!.trim(),
    ];

    final contactChildren = <pw.Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        contactChildren.add(
          pw.Text('  |  ', style: const pw.TextStyle(fontSize: 9)),
        );
      }
      contactChildren.add(
        pw.Text(items[i], style: const pw.TextStyle(fontSize: 9)),
      );
    }

    final fullName = info.fullName?.trim().isNotEmpty == true
        ? info.fullName!.trim().toUpperCase()
        : 'UNTITLED';
    final jobTitle = info.jobTitle?.trim().isNotEmpty == true
        ? info.jobTitle!.trim().toUpperCase()
        : null;

    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(
            fullName,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (jobTitle != null) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              jobTitle,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
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

  pw.Widget _buildSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
      ],
    );
  }

  pw.Widget _buildBulletDot() {
    return pw.Container(
      width: 3.5,
      height: 3.5,
      margin: const pw.EdgeInsets.only(top: 3.5, right: 6),
      decoration: const pw.BoxDecoration(
        color: PdfColors.black,
        shape: pw.BoxShape.circle,
      ),
    );
  }

  pw.Widget _buildSkillColumn(List<String> skills) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: skills
          .map(
            (skill) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 3),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildBulletDot(),
                  pw.Expanded(
                    child: pw.Text(
                      skill,
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final m = (date.month >= 1 && date.month <= 12)
        ? months[date.month - 1]
        : '${date.month}';
    return '$m ${date.year}';
  }
}
