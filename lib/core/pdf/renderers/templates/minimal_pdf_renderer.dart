import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../base/pdf_renderer.dart';
import '../../widgets/pdf_section_title.dart';
import '../../widgets/pdf_timeline_item.dart';
import '../../widgets/pdf_footer.dart';
import '../../../../data/models/resume_model.dart';

class MinimalPdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(50),
        footer: (context) => PdfFooter(),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              resume.personalInfo?.fullName?.toUpperCase() ?? '',
              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Center(
            child: pw.Text(
              [
                resume.personalInfo?.phone,
                resume.personalInfo?.email,
                resume.personalInfo?.linkedIn,
                resume.personalInfo?.github,
                resume.personalInfo?.portfolioWebsite,
              ].where((e) => e != null && e.isNotEmpty).join('  |  '),
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ),
          pw.SizedBox(height: 30),
          if (resume.professionalSummary?.summary?.isNotEmpty ?? false) ...[
            pw.Text(resume.professionalSummary!.summary!,
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 25),
          ],
          _buildExperience(resume),
          _buildEducation(resume),
          if (resume.skills != null && resume.skills!.isNotEmpty) ...[
            PdfSectionTitle('Skills'),
            pw.Wrap(
              spacing: 10,
              runSpacing: 5,
              children: resume.skills!
                  .map((s) => pw.Text(s.name ?? '',
                      style: const pw.TextStyle(fontSize: 10)))
                  .toList(),
            ),
            pw.SizedBox(height: 20),
          ],
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildExperience(ResumeModel resume) {
    if (resume.experience == null || resume.experience!.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Experience'),
        ...resume.experience!.map((e) => PdfTimelineItem(
              title: e.company ?? '',
              subtitle: e.position,
              date:
                  '${_formatDate(e.startDate)} - ${e.isCurrentlyWorking == true ? "Present" : _formatDate(e.endDate)}',
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
              subtitle: e.degree,
              date:
                  '${_formatDate(e.startDate)} - ${e.isCurrentlyStudying == true ? "Present" : _formatDate(e.endDate)}',
            )),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }
}
