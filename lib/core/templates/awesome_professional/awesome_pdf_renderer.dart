import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as fm;
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/core/templates/renderers/template_renderer.dart';
import 'package:vitafolio/core/templates/themes/template_theme.dart';
import 'package:vitafolio/core/templates/widgets/pdf_preview_widget.dart';
import 'package:vitafolio/core/templates/awesome_professional/awesome_theme.dart';

class AwesomePdfRenderer extends ResumeTemplateRenderer {
  const AwesomePdfRenderer();

  @override
  ResumeTheme theme() => awesomeTheme;

  @override
  fm.Widget buildPreview(WorkflowState resumeData, fm.BuildContext context) {
    return PdfPreviewWidget(pdf: buildPdf(resumeData));
  }

  @override
  pw.Document buildPdf(WorkflowState resumeData) {
    final pdf = pw.Document();
    final slateBlue = PdfColor.fromHex('4A5D6E');
    final goldTan = PdfColor.fromHex('C69C6D');
    final lightBg = PdfColor.fromHex('F7F3EE');

    final info = resumeData.personalInfo;
    final nameParts = (info.fullName?.trim().isNotEmpty == true)
        ? info.fullName!.trim().split(' ')
        : ['UNTITLED', ''];
    final firstName = nameParts.first.toUpperCase();
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ').toUpperCase() : '';
    final jobTitle = info.jobTitle?.trim().isNotEmpty == true
        ? info.jobTitle!.trim().toUpperCase()
        : null;

    // Profile Photo
    pw.Widget profilePhotoWidget;
    final photoPath = info.profileImagePath;
    if (photoPath != null && photoPath.trim().isNotEmpty && File(photoPath).existsSync()) {
      try {
        final imageBytes = File(photoPath).readAsBytesSync();
        final memoryImage = pw.MemoryImage(imageBytes);
        profilePhotoWidget = pw.Container(
          width: 86,
          height: 86,
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
            border: pw.Border.all(color: goldTan, width: 3),
            image: pw.DecorationImage(
              image: memoryImage,
              fit: pw.BoxFit.cover,
            ),
          ),
        );
      } catch (_) {
        profilePhotoWidget = _buildAvatarPlaceholder(goldTan);
      }
    } else {
      profilePhotoWidget = _buildAvatarPlaceholder(goldTan);
    }

    // Header Banner
    final headerBanner = pw.Container(
      color: slateBlue,
      padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                firstName,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  letterSpacing: 1.5,
                ),
              ),
              if (lastName.isNotEmpty)
                pw.Text(
                  lastName,
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              if (jobTitle != null) ...[
                pw.SizedBox(height: 4),
                pw.Text(
                  jobTitle,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: goldTan,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ],
          ),
          profilePhotoWidget,
        ],
      ),
    );

    // Left Column
    final leftWidgets = <pw.Widget>[];

    // Left: CONTACT
    final contactItems = <String>[
      if (info.phone?.trim().isNotEmpty == true) info.phone!.trim(),
      if (info.email?.trim().isNotEmpty == true) info.email!.trim(),
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        info.portfolioWebsite!.trim(),
      if (info.linkedIn?.trim().isNotEmpty == true) info.linkedIn!.trim(),
      if (info.github?.trim().isNotEmpty == true) info.github!.trim(),
    ];
    if (contactItems.isNotEmpty) {
      leftWidgets.add(_buildSectionBanner('CONTACT', slateBlue, PdfColors.white));
      for (final item in contactItems) {
        leftWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Text(
              item,
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey900),
            ),
          ),
        );
      }
      leftWidgets.add(pw.SizedBox(height: 14));
    }

    // Left: SKILLS
    final validSkills = PdfSectionHelper.validSkillStrings(resumeData.skills);
    if (validSkills.isNotEmpty) {
      leftWidgets.add(_buildSectionBanner('SKILLS', slateBlue, PdfColors.white));
      leftWidgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Text(
            'PROFESSIONAL',
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: slateBlue,
            ),
          ),
        ),
      );
      for (final skill in validSkills) {
        leftWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildBulletDot(slateBlue),
                pw.Expanded(
                  child: pw.Text(
                    skill,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      leftWidgets.add(pw.SizedBox(height: 14));
    }

    // Left: EDUCATION
    final validEdu = PdfSectionHelper.validEducation(resumeData.education);
    if (validEdu.isNotEmpty) {
      leftWidgets.add(_buildSectionBanner('EDUCATION', slateBlue, PdfColors.white));
      for (final edu in validEdu) {
        final school = edu.school?.trim() ?? '';
        final degree = [
          if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
          if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
        ].join(' in ');
        final dateStr =
            '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "Present" : _formatDate(edu.endDate)}';

        leftWidgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 5,
                  height: 5,
                  margin: const pw.EdgeInsets.only(top: 3, right: 6),
                  decoration: pw.BoxDecoration(
                    color: slateBlue,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (school.isNotEmpty)
                        pw.Text(
                          school.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey900,
                          ),
                        ),
                      if (degree.isNotEmpty)
                        pw.Text(
                          degree,
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey800,
                          ),
                        ),
                      pw.Text(
                        dateStr,
                        style: const pw.TextStyle(
                          fontSize: 8.5,
                          color: PdfColors.grey700,
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
      leftWidgets.add(pw.SizedBox(height: 14));
    }

    // Left: LANGUAGES
    final validLangs = PdfSectionHelper.validLanguages(resumeData.languages);
    if (validLangs.isNotEmpty) {
      leftWidgets.add(_buildSectionBanner('LANGUAGES', slateBlue, PdfColors.white));
      for (final l in validLangs) {
        leftWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildBulletDot(slateBlue),
                pw.Expanded(
                  child: pw.Text(
                    '${l.language!.trim()} (${l.proficiency.name})',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    // Right Column
    final rightWidgets = <pw.Widget>[];

    // Right: SUMMARY
    if (PdfSectionHelper.hasSummary(resumeData.summary)) {
      rightWidgets.add(_buildSectionBanner('SUMMARY', lightBg, slateBlue));
      rightWidgets.add(
        pw.Container(
          padding: const pw.EdgeInsets.only(left: 8),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              left: pw.BorderSide(color: PdfColor.fromHex('C69C6D'), width: 2),
            ),
          ),
          child: pw.Text(
            resumeData.summary.trim(),
            style: const pw.TextStyle(fontSize: 9.5, lineSpacing: 2),
          ),
        ),
      );
      rightWidgets.add(pw.SizedBox(height: 16));
    }

    // Right: WORKING EXPERIENCE
    final validExp = PdfSectionHelper.validExperiences(resumeData.experience);
    if (validExp.isNotEmpty) {
      rightWidgets.add(_buildSectionBanner('WORKING EXPERIENCE', lightBg, slateBlue));
      for (final exp in validExp) {
        final company = exp.company?.trim() ?? '';
        final position = exp.position?.trim() ?? '';
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

        rightWidgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 6,
                  height: 6,
                  margin: const pw.EdgeInsets.only(top: 3, right: 8),
                  decoration: pw.BoxDecoration(
                    color: slateBlue,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        position.isNotEmpty ? position.toUpperCase() : company.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 10.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey900,
                        ),
                      ),
                      pw.Text(
                        '$company   |   $dateStr',
                        style: const pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey700,
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
                                _buildBulletDot(slateBlue),
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
      rightWidgets.add(pw.SizedBox(height: 12));
    }

    // Right: PROJECTS
    final validProj = PdfSectionHelper.validProjects(resumeData.projects);
    if (validProj.isNotEmpty) {
      rightWidgets.add(_buildSectionBanner('PROJECTS', lightBg, slateBlue));
      for (final proj in validProj) {
        rightWidgets.add(
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
                        color: slateBlue,
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
    }

    // Right: CERTIFICATIONS
    final validCerts = PdfSectionHelper.validCertifications(resumeData.certifications);
    if (validCerts.isNotEmpty) {
      rightWidgets.add(_buildSectionBanner('CERTIFICATIONS', lightBg, slateBlue));
      for (final cert in validCerts) {
        rightWidgets.add(
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
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          headerBanner,
          pw.SizedBox(height: 16),
          ...rightWidgets,
          if (leftWidgets.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            ...leftWidgets,
          ],
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildAvatarPlaceholder(PdfColor borderAccent) {
    return pw.Container(
      width: 80,
      height: 80,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: PdfColor.fromHex('2C3E50'),
        border: pw.Border.all(color: borderAccent, width: 2.5),
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

  pw.Widget _buildSectionBanner(String title, PdfColor bgColor, PdfColor textColor) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: pw.BoxDecoration(
        color: bgColor,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
      ),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          color: textColor,
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  pw.Widget _buildBulletDot(PdfColor color) {
    return pw.Container(
      width: 3.5,
      height: 3.5,
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
