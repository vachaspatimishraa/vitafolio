import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vitafolio/core/pdf/renderers/base/pdf_renderer.dart';
import 'package:vitafolio/core/pdf/widgets/pdf_section_title.dart';
import 'package:vitafolio/core/pdf/widgets/pdf_timeline_item.dart';
import 'package:vitafolio/core/pdf/widgets/pdf_footer.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/data/models/resume_model.dart';

class MinimalPdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();

    final widgets = <pw.Widget>[];

    if (resume.personalInfo?.fullName?.trim().isNotEmpty ?? false) {
      widgets.add(
        pw.Center(
          child: pw.Text(
            resume.personalInfo!.fullName!.trim().toUpperCase(),
            style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
          ),
        ),
      );
    }

    final contactItems = [
      resume.personalInfo?.phone?.trim(),
      resume.personalInfo?.email?.trim(),
      resume.personalInfo?.linkedIn?.trim(),
      resume.personalInfo?.github?.trim(),
      resume.personalInfo?.portfolioWebsite?.trim(),
    ].where((e) => e != null && e.isNotEmpty).cast<String>().toList();

    if (contactItems.isNotEmpty) {
      widgets.add(
        pw.Center(
          child: pw.Text(
            contactItems.join('  |  '),
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ),
      );
    }

    if (widgets.isNotEmpty) {
      widgets.add(pw.SizedBox(height: 30));
    }

    if (PdfSectionHelper.hasSummary(resume.professionalSummary?.summary)) {
      widgets.addAll([
        pw.Text(
          resume.professionalSummary!.summary!.trim(),
          textAlign: pw.TextAlign.center,
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 25),
      ]);
    }

    if (PdfSectionHelper.hasExperience(resume.experience)) {
      widgets.add(_buildExperience(resume));
    }

    if (PdfSectionHelper.hasEducation(resume.education)) {
      widgets.add(_buildEducation(resume));
    }

    final validSkills = PdfSectionHelper.validSkillModels(resume.skills);
    if (validSkills.isNotEmpty) {
      widgets.addAll([
        PdfSectionTitle('Skills'),
        pw.Wrap(
          spacing: 10,
          runSpacing: 5,
          children: validSkills
              .map(
                (s) => pw.Text(
                  s.name!.trim(),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              )
              .toList(),
        ),
        pw.SizedBox(height: 20),
      ]);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(50),
        footer: (context) => PdfFooter(),
        build: (context) => widgets,
      ),
    );

    return pdf;
  }

  pw.Widget _buildExperience(ResumeModel resume) {
    final validExp = PdfSectionHelper.validExperiences(resume.experience);
    if (validExp.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Experience'),
        ...validExp.map(
          (e) => PdfTimelineItem(
            title: e.company?.trim() ?? '',
            subtitle: e.position?.trim(),
            date:
                '${_formatDate(e.startDate)} - ${e.isCurrentlyWorking == true ? "Present" : _formatDate(e.endDate)}',
            description: e.description?.trim(),
          ),
        ),
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
        ...validEdu.map(
          (e) => PdfTimelineItem(
            title: e.school?.trim() ?? '',
            subtitle: e.degree?.trim(),
            date:
                '${_formatDate(e.startDate)} - ${e.isCurrentlyStudying == true ? "Pursuing" : _formatDate(e.endDate)}',
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }
}
