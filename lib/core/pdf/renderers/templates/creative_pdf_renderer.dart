import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../base/pdf_renderer.dart';
import '../../widgets/pdf_section_title.dart';
import '../../widgets/pdf_timeline_item.dart';
import '../../widgets/pdf_footer.dart';
import '../../helpers/pdf_section_helper.dart';
import '../../../../data/models/resume_model.dart';

class CreativePdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();
    const accentColor = PdfColors.deepOrange800;

    final widgets = <pw.Widget>[];

    final hasHeaderName =
        resume.personalInfo?.fullName?.trim().isNotEmpty ?? false;
    final hasHeaderJob =
        resume.personalInfo?.jobTitle?.trim().isNotEmpty ?? false;
    final contactLines = <pw.Widget>[];

    if (resume.personalInfo?.phone?.trim().isNotEmpty == true) {
      contactLines.add(
        pw.Text(
          resume.personalInfo!.phone!.trim(),
          style: const pw.TextStyle(fontSize: 10),
        ),
      );
    }
    if (resume.personalInfo?.email?.trim().isNotEmpty == true) {
      contactLines.add(
        pw.Text(
          resume.personalInfo!.email!.trim(),
          style: const pw.TextStyle(fontSize: 10),
        ),
      );
    }
    if (resume.personalInfo?.linkedIn?.trim().isNotEmpty == true) {
      contactLines.add(
        pw.Text(
          resume.personalInfo!.linkedIn!.trim(),
          style: const pw.TextStyle(fontSize: 10),
        ),
      );
    }
    if (resume.personalInfo?.github?.trim().isNotEmpty == true) {
      contactLines.add(
        pw.Text(
          resume.personalInfo!.github!.trim(),
          style: const pw.TextStyle(fontSize: 10),
        ),
      );
    }
    if (resume.personalInfo?.portfolioWebsite?.trim().isNotEmpty == true) {
      contactLines.add(
        pw.Text(
          resume.personalInfo!.portfolioWebsite!.trim(),
          style: const pw.TextStyle(fontSize: 10),
        ),
      );
    }

    if (hasHeaderName || hasHeaderJob || contactLines.isNotEmpty) {
      widgets.add(
        pw.Header(
          level: 0,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (hasHeaderName)
                    pw.Text(
                      resume.personalInfo!.fullName!.trim(),
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  if (hasHeaderJob)
                    pw.Text(
                      resume.personalInfo!.jobTitle!.trim(),
                      style: const pw.TextStyle(fontSize: 18),
                    ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: contactLines,
              ),
            ],
          ),
        ),
      );
    }

    if (PdfSectionHelper.hasSummary(resume.professionalSummary?.summary)) {
      widgets.addAll([
        PdfSectionTitle('About Me', color: accentColor),
        pw.Text(
          resume.professionalSummary!.summary!.trim(),
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 20),
      ]);
    }

    final validExp = PdfSectionHelper.validExperiences(resume.experience);
    if (validExp.isNotEmpty) {
      widgets.addAll([
        PdfSectionTitle('Experience', color: accentColor),
        ...validExp.map(
          (e) => PdfTimelineItem(
            title: e.company?.trim() ?? '',
            subtitle: e.position?.trim(),
            date:
                '${_formatDate(e.startDate)} - ${e.isCurrentlyWorking == true ? "Present" : _formatDate(e.endDate)}',
            description: e.description?.trim(),
          ),
        ),
      ]);
    }

    final validEdu = PdfSectionHelper.validEducation(resume.education);
    if (validEdu.isNotEmpty) {
      widgets.addAll([
        PdfSectionTitle('Education', color: accentColor),
        ...validEdu.map(
          (e) => PdfTimelineItem(
            title: e.school?.trim() ?? '',
            subtitle: e.degree?.trim(),
            date:
                '${_formatDate(e.startDate)} - ${e.isCurrentlyStudying == true ? "Present" : _formatDate(e.endDate)}',
          ),
        ),
      ]);
    }

    final validSkills = PdfSectionHelper.validSkillModels(resume.skills);
    if (validSkills.isNotEmpty) {
      widgets.addAll([
        PdfSectionTitle('Skills', color: accentColor),
        pw.Wrap(
          spacing: 8,
          runSpacing: 8,
          children: validSkills
              .map(
                (s) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: const pw.BoxDecoration(
                    color: accentColor,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(20)),
                  ),
                  child: pw.Text(
                    s.name!.trim(),
                    style: const pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ]);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(35),
        footer: (context) => PdfFooter(),
        build: (context) => widgets,
      ),
    );

    return pdf;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }
}
