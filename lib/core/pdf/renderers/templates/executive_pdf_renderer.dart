import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../base/pdf_renderer.dart';
import '../../widgets/pdf_section_title.dart';
import '../../widgets/pdf_timeline_item.dart';
import '../../widgets/pdf_footer.dart';
import '../../helpers/pdf_section_helper.dart';
import '../../../../data/models/resume_model.dart';

class ExecutivePdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();

    final widgets = <pw.Widget>[];

    final hasHeaderName = resume.personalInfo?.fullName?.trim().isNotEmpty ?? false;
    final hasHeaderJob = resume.personalInfo?.jobTitle?.trim().isNotEmpty ?? false;
    final contactLines = <pw.Widget>[];

    if (resume.personalInfo?.phone?.trim().isNotEmpty == true) {
      contactLines.add(_contactText(resume.personalInfo!.phone!.trim()));
    }
    if (resume.personalInfo?.email?.trim().isNotEmpty == true) {
      contactLines.add(_contactText(resume.personalInfo!.email!.trim()));
    }
    if (resume.personalInfo?.linkedIn?.trim().isNotEmpty == true) {
      contactLines.add(_contactText(resume.personalInfo!.linkedIn!.trim()));
    }
    if (resume.personalInfo?.github?.trim().isNotEmpty == true) {
      contactLines.add(_contactText(resume.personalInfo!.github!.trim()));
    }
    if (resume.personalInfo?.portfolioWebsite?.trim().isNotEmpty == true) {
      contactLines.add(_contactText(resume.personalInfo!.portfolioWebsite!.trim()));
    }

    if (hasHeaderName || hasHeaderJob || contactLines.isNotEmpty) {
      widgets.add(
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (hasHeaderName)
                  pw.Text(
                    resume.personalInfo!.fullName!.trim().toUpperCase(),
                    style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey900),
                  ),
                if (hasHeaderJob)
                  pw.Text(
                    resume.personalInfo!.jobTitle!.trim(),
                    style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey800),
                  ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: contactLines,
            ),
          ],
        ),
      );
      widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 10),
          child: pw.Divider(thickness: 2, color: PdfColors.black),
        ),
      );
    }

    if (PdfSectionHelper.hasSummary(resume.professionalSummary?.summary)) {
      widgets.addAll([
        pw.Text(resume.professionalSummary!.summary!.trim(),
            style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 20),
      ]);
    }

    if (PdfSectionHelper.hasExperience(resume.experience)) {
      widgets.add(_buildExperience(resume));
    }

    if (PdfSectionHelper.hasEducation(resume.education)) {
      widgets.add(_buildEducation(resume));
    }

    if (PdfSectionHelper.hasSkills(resume.skills)) {
      widgets.add(_buildSkills(resume));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        footer: (context) => PdfFooter(),
        build: (context) => widgets,
      ),
    );

    return pdf;
  }

  pw.Widget _contactText(String text) {
    return pw.Text(text, style: const pw.TextStyle(fontSize: 9));
  }

  pw.Widget _buildExperience(ResumeModel resume) {
    final validExp = PdfSectionHelper.validExperiences(resume.experience);
    if (validExp.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Professional Experience'),
        ...validExp.map((e) => PdfTimelineItem(
              title: e.company?.trim() ?? '',
              subtitle: e.position?.trim(),
              date:
                  '${_formatDate(e.startDate)} - ${e.isCurrentlyWorking == true ? "Present" : _formatDate(e.endDate)}',
              location: e.location?.trim(),
              description: e.description?.trim(),
            )),
      ],
    );
  }

  pw.Widget _buildEducation(ResumeModel resume) {
    final validEdu = PdfSectionHelper.validEducation(resume.education);
    if (validEdu.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Education'),
        ...validEdu.map((e) => PdfTimelineItem(
              title: e.school?.trim() ?? '',
              subtitle: '${e.degree?.trim() ?? ""} ${e.fieldOfStudy?.trim() ?? ""}'.trim(),
              date:
                  '${_formatDate(e.startDate)} - ${e.isCurrentlyStudying == true ? "Present" : _formatDate(e.endDate)}',
            )),
      ],
    );
  }

  pw.Widget _buildSkills(ResumeModel resume) {
    final validSkills = PdfSectionHelper.validSkillModels(resume.skills);
    if (validSkills.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Core Competencies'),
        pw.Wrap(
          spacing: 15,
          runSpacing: 5,
          children: validSkills
              .map((s) => pw.Bullet(
                  text: s.name!.trim(), style: const pw.TextStyle(fontSize: 10)))
              .toList(),
        ),
        pw.SizedBox(height: 12),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }
}

