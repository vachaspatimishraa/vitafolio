import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../base/pdf_renderer.dart';
import '../../widgets/pdf_section_title.dart';
import '../../widgets/pdf_timeline_item.dart';
import '../../widgets/pdf_footer.dart';
import '../../../../data/models/resume_model.dart';

class ExecutivePdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        footer: (context) => PdfFooter(),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    resume.personalInfo?.fullName?.toUpperCase() ?? '',
                    style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey900),
                  ),
                  pw.Text(
                    resume.personalInfo?.jobTitle ?? '',
                    style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey800),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  if (resume.personalInfo?.phone?.isNotEmpty == true)
                    _contactText(resume.personalInfo!.phone!),
                  if (resume.personalInfo?.email?.isNotEmpty == true)
                    _contactText(resume.personalInfo!.email!),
                  if (resume.personalInfo?.linkedIn?.isNotEmpty == true)
                    _contactText(resume.personalInfo!.linkedIn!),
                  if (resume.personalInfo?.github?.isNotEmpty == true)
                    _contactText(resume.personalInfo!.github!),
                  if (resume.personalInfo?.portfolioWebsite?.isNotEmpty == true)
                    _contactText(resume.personalInfo!.portfolioWebsite!),
                ],
              ),
            ],
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Divider(thickness: 2, color: PdfColors.black),
          ),
          if (resume.professionalSummary?.summary?.isNotEmpty ?? false) ...[
            pw.Text(resume.professionalSummary!.summary!,
                style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 20),
          ],
          _buildExperience(resume),
          _buildEducation(resume),
          _buildSkills(resume),
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _contactText(String text) {
    return pw.Text(text, style: const pw.TextStyle(fontSize: 9));
  }

  pw.Widget _buildExperience(ResumeModel resume) {
    if (resume.experience == null || resume.experience!.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Professional Experience'),
        ...resume.experience!.map((e) => PdfTimelineItem(
              title: e.company ?? '',
              subtitle: e.position,
              date:
                  '${_formatDate(e.startDate)} - ${e.isCurrentlyWorking == true ? "Present" : _formatDate(e.endDate)}',
              location: e.location,
              description: e.description,
            )),
      ],
    );
  }

  pw.Widget _buildEducation(ResumeModel resume) {
    if (resume.education == null || resume.education!.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Education'),
        ...resume.education!.map((e) => PdfTimelineItem(
              title: e.school ?? '',
              subtitle: '${e.degree ?? ""} ${e.fieldOfStudy ?? ""}',
              date:
                  '${_formatDate(e.startDate)} - ${e.isCurrentlyStudying == true ? "Present" : _formatDate(e.endDate)}',
            )),
      ],
    );
  }

  pw.Widget _buildSkills(ResumeModel resume) {
    if (resume.skills == null || resume.skills!.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Core Competencies'),
        pw.Wrap(
          spacing: 15,
          runSpacing: 5,
          children: resume.skills!
              .map((s) => pw.Bullet(
                  text: s.name ?? '', style: const pw.TextStyle(fontSize: 10)))
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
