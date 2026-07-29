import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../base/pdf_renderer.dart';
import '../../widgets/pdf_section_title.dart';
import '../../widgets/pdf_timeline_item.dart';
import '../../widgets/pdf_footer.dart';
import '../../../../data/models/resume_model.dart';

class CreativePdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();
    const accentColor = PdfColors.deepOrange800;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(35),
        footer: (context) => PdfFooter(),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      resume.personalInfo?.fullName ?? '',
                      style: pw.TextStyle(
                          fontSize: 32,
                          fontWeight: pw.FontWeight.bold,
                          color: accentColor),
                    ),
                    pw.Text(
                      resume.personalInfo?.jobTitle ?? '',
                      style: const pw.TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    if (resume.personalInfo?.phone?.isNotEmpty == true)
                      pw.Text(resume.personalInfo!.phone!,
                          style: const pw.TextStyle(fontSize: 10)),
                    if (resume.personalInfo?.email?.isNotEmpty == true)
                      pw.Text(resume.personalInfo!.email!,
                          style: const pw.TextStyle(fontSize: 10)),
                    if (resume.personalInfo?.linkedIn?.isNotEmpty == true)
                      pw.Text(resume.personalInfo!.linkedIn!,
                          style: const pw.TextStyle(fontSize: 10)),
                    if (resume.personalInfo?.github?.isNotEmpty == true)
                      pw.Text(resume.personalInfo!.github!,
                          style: const pw.TextStyle(fontSize: 10)),
                    if (resume.personalInfo?.portfolioWebsite?.isNotEmpty == true)
                      pw.Text(resume.personalInfo!.portfolioWebsite!,
                          style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          if (resume.professionalSummary?.summary?.isNotEmpty ?? false) ...[
            PdfSectionTitle('About Me', color: accentColor),
            pw.Text(resume.professionalSummary!.summary!,
                style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 20),
          ],
          if (resume.experience != null && resume.experience!.isNotEmpty) ...[
            PdfSectionTitle('Experience', color: accentColor),
            ...resume.experience!.map((e) => PdfTimelineItem(
                  title: e.company ?? '',
                  subtitle: e.position,
                  date:
                      '${_formatDate(e.startDate)} - ${e.isCurrentlyWorking == true ? "Present" : _formatDate(e.endDate)}',
                  description: e.description,
                )),
          ],
          if (resume.education != null && resume.education!.isNotEmpty) ...[
            PdfSectionTitle('Education', color: accentColor),
            ...resume.education!.map((e) => PdfTimelineItem(
                  title: e.school ?? '',
                  subtitle: e.degree,
                  date:
                      '${_formatDate(e.startDate)} - ${e.isCurrentlyStudying == true ? "Present" : _formatDate(e.endDate)}',
                )),
          ],
          if (resume.skills != null && resume.skills!.isNotEmpty) ...[
            PdfSectionTitle('Skills', color: accentColor),
            pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children: resume.skills!
                  .map((s) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: const pw.BoxDecoration(
                          color: accentColor,
                          borderRadius:
                              pw.BorderRadius.all(pw.Radius.circular(20)),
                        ),
                        child: pw.Text(s.name ?? '',
                            style: const pw.TextStyle(
                                color: PdfColors.white, fontSize: 10)),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );

    return pdf;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }
}
