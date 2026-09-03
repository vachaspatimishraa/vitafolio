import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vitafolio/core/pdf/renderers/base/pdf_renderer.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/data/models/resume_model.dart';

class ModernPdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();
    final sidebarColor = PdfColor.fromHex('1B365D');
    final darkNavy = PdfColor.fromHex('1B365D');

    // Build Profile Photo
    pw.Widget profilePhotoWidget;
    final photoPath = resume.personalInfo?.profileImagePath;
    if (photoPath != null && photoPath.trim().isNotEmpty && File(photoPath).existsSync()) {
      try {
        final imageBytes = File(photoPath).readAsBytesSync();
        final memoryImage = pw.MemoryImage(imageBytes);
        profilePhotoWidget = pw.Container(
          width: 84,
          height: 84,
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
            border: pw.Border.all(color: PdfColors.white, width: 3),
            image: pw.DecorationImage(
              image: memoryImage,
              fit: pw.BoxFit.cover,
            ),
          ),
        );
      } catch (_) {
        profilePhotoWidget = _buildAvatarPlaceholder();
      }
    } else {
      profilePhotoWidget = _buildAvatarPlaceholder();
    }

    // Left Sidebar Children
    final sidebarWidgets = <pw.Widget>[
      pw.Center(child: profilePhotoWidget),
      pw.SizedBox(height: 20),
    ];

    // Sidebar: CONTACT
    final info = resume.personalInfo;
    if (info != null) {
      final contactItems = <String>[
        if (info.phone?.trim().isNotEmpty == true) info.phone!.trim(),
        if (info.email?.trim().isNotEmpty == true) info.email!.trim(),
        if (info.portfolioWebsite?.trim().isNotEmpty == true)
          info.portfolioWebsite!.trim(),
        if (info.linkedIn?.trim().isNotEmpty == true) info.linkedIn!.trim(),
        if (info.github?.trim().isNotEmpty == true) info.github!.trim(),
      ];
      if (contactItems.isNotEmpty) {
        sidebarWidgets.add(_buildSidebarTitle('CONTACT'));
        for (final item in contactItems) {
          sidebarWidgets.add(
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 5),
              child: pw.Text(
                item,
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 9),
              ),
            ),
          );
        }
        sidebarWidgets.add(pw.SizedBox(height: 16));
      }
    }

    // Sidebar: EDUCATION
    final validEdu = PdfSectionHelper.validEducation(resume.education);
    if (validEdu.isNotEmpty) {
      sidebarWidgets.add(_buildSidebarTitle('EDUCATION'));
      for (final edu in validEdu) {
        final dateStr =
            '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "PURSUING" : _formatDate(edu.endDate)}';
        final school = edu.school?.trim() ?? '';
        final degree = [
          if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
          if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
        ].join(' in ');

        sidebarWidgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  dateStr,
                  style: const pw.TextStyle(color: PdfColors.white, fontSize: 8.5),
                ),
                if (school.isNotEmpty)
                  pw.Text(
                    school.toUpperCase(),
                    style: pw.TextStyle(
                      color: PdfColors.white,
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
                            style: const pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 9,
                            ),
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
                            style: const pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 9,
                            ),
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

    // Sidebar: SKILLS
    final validSkills = PdfSectionHelper.validSkillModels(resume.skills);
    if (validSkills.isNotEmpty) {
      sidebarWidgets.add(_buildSidebarTitle('SKILLS'));
      for (final s in validSkills) {
        sidebarWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildSidebarBulletDot(),
                pw.Expanded(
                  child: pw.Text(
                    s.name!.trim(),
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

    // Sidebar: LANGUAGES
    final validLangs = PdfSectionHelper.validLanguages(resume.languages);
    if (validLangs.isNotEmpty) {
      sidebarWidgets.add(_buildSidebarTitle('LANGUAGES'));
      for (final l in validLangs) {
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

    // Right Column Children
    final mainWidgets = <pw.Widget>[];

    final fullName = info?.fullName?.trim().isNotEmpty == true
        ? info!.fullName!.trim().toUpperCase()
        : 'UNTITLED';
    final jobTitle = info?.jobTitle?.trim().isNotEmpty == true
        ? info!.jobTitle!.trim().toUpperCase()
        : null;

    mainWidgets.add(
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            fullName,
            style: pw.TextStyle(
              fontSize: 26,
              fontWeight: pw.FontWeight.bold,
              color: darkNavy,
            ),
          ),
          if (jobTitle != null) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              jobTitle,
              style: pw.TextStyle(
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey700,
                letterSpacing: 1.0,
              ),
            ),
          ],
          pw.SizedBox(height: 6),
          pw.Divider(thickness: 1, color: darkNavy),
          pw.SizedBox(height: 14),
        ],
      ),
    );

    if (PdfSectionHelper.hasSummary(resume.professionalSummary?.summary)) {
      mainWidgets.addAll([
        _buildMainTitle('PROFILE', darkNavy),
        pw.Text(
          resume.professionalSummary!.summary!.trim(),
          style: const pw.TextStyle(fontSize: 9.5, lineSpacing: 2),
        ),
        pw.SizedBox(height: 16),
      ]);
    }

    final validExp = PdfSectionHelper.validExperiences(resume.experience);
    if (validExp.isNotEmpty) {
      mainWidgets.add(_buildMainTitle('WORK EXPERIENCE', darkNavy));
      for (final exp in validExp) {
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
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  children: [
                    pw.Container(
                      width: 6,
                      height: 6,
                      margin: const pw.EdgeInsets.only(top: 3, right: 8),
                      decoration: pw.BoxDecoration(
                        color: darkNavy,
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            company.isNotEmpty ? company : position,
                            style: pw.TextStyle(
                              fontSize: 10.5,
                              fontWeight: pw.FontWeight.bold,
                              color: darkNavy,
                            ),
                          ),
                          pw.Text(
                            dateStr,
                            style: pw.TextStyle(
                              fontSize: 9.5,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                      if (company.isNotEmpty && position.isNotEmpty)
                        pw.Text(
                          position,
                          style: const pw.TextStyle(
                            fontSize: 9.5,
                            color: PdfColors.grey800,
                          ),
                        ),
                      if (descLines.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        ...descLines.map(
                          (line) => pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 2, bottom: 2),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                _buildDarkBulletDot(darkNavy),
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
              ],
            ),
          ),
        );
      }
      mainWidgets.add(pw.SizedBox(height: 12));
    }

    final validProj = PdfSectionHelper.validProjects(resume.projects);
    if (validProj.isNotEmpty) {
      mainWidgets.add(_buildMainTitle('PROJECTS', darkNavy));
      for (final proj in validProj) {
        mainWidgets.add(
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
                        color: darkNavy,
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
      mainWidgets.add(pw.SizedBox(height: 12));
    }

    final validCerts = PdfSectionHelper.validCertifications(resume.certifications);
    if (validCerts.isNotEmpty) {
      mainWidgets.add(_buildMainTitle('CERTIFICATIONS', darkNavy));
      for (final cert in validCerts) {
        mainWidgets.add(
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
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) => [
          pw.FullPage(
            ignoreMargins: true,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Container(
                  width: 190,
                  color: sidebarColor,
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: sidebarWidgets,
                  ),
                ),
                pw.Expanded(
                  child: pw.Container(
                    color: PdfColors.white,
                    padding: const pw.EdgeInsets.all(24),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: mainWidgets,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildAvatarPlaceholder() {
    return pw.Container(
      width: 80,
      height: 80,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: PdfColor.fromHex('2C4D6F'),
        border: pw.Border.all(color: PdfColors.white, width: 2.5),
      ),
      child: pw.Center(
        child: pw.Text(
          '?',
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );
  }

  pw.Widget _buildSidebarTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
            fontSize: 11,
            letterSpacing: 1.0,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Divider(color: PdfColors.white, thickness: 0.5),
        pw.SizedBox(height: 6),
      ],
    );
  }

  pw.Widget _buildMainTitle(String title, PdfColor darkNavy) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: darkNavy,
            fontWeight: pw.FontWeight.bold,
            fontSize: 11,
            letterSpacing: 1.0,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Divider(color: darkNavy, thickness: 0.5),
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
