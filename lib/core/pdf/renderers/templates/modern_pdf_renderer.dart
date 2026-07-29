import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../base/pdf_renderer.dart';
import '../../widgets/pdf_section_title.dart';
import '../../widgets/pdf_timeline_item.dart';
import '../../widgets/pdf_footer.dart';
import '../../../../data/models/resume_model.dart';
import '../../../../data/models/embedded/personal_information.dart';

class ModernPdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: PdfFooter(),
        ),
        build: (context) => [
          pw.FullPage(
            ignoreMargins: true,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                // Sidebar
                pw.Container(
                  width: 180,
                  color: PdfColors.blue900,
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        resume.personalInfo?.fullName ?? '',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        resume.personalInfo?.jobTitle ?? '',
                        style: const pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 12,
                        ),
                      ),
                      pw.SizedBox(height: 30),
                      _buildContactSection(resume.personalInfo),
                      pw.SizedBox(height: 30),
                      _buildSkillsSection(resume),
                      pw.SizedBox(height: 30),
                      _buildLanguagesSection(resume),
                    ],
                  ),
                ),
                // Main Content
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(30),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (resume.professionalSummary?.summary?.isNotEmpty ?? false) ...[
                          PdfSectionTitle('Summary', color: PdfColors.blue900),
                          pw.Text(resume.professionalSummary!.summary!, style: const pw.TextStyle(fontSize: 10)),
                          pw.SizedBox(height: 20),
                        ],
                        _buildExperienceSection(resume),
                        _buildEducationSection(resume),
                        _buildProjectsSection(resume),
                        _buildCertificationsSection(resume),
                      ],
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

  pw.Widget _buildContactSection(PersonalInformation? info) {
    if (info == null) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('CONTACT', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.Divider(color: PdfColors.white, thickness: 0.5),
        pw.SizedBox(height: 8),
        if (info.email != null) _sidebarText(info.email!),
        if (info.phone != null) _sidebarText(info.phone!),
        if (info.linkedIn != null) _sidebarText(info.linkedIn!),
        if (info.github != null) _sidebarText(info.github!),
        if (info.portfolioWebsite != null) _sidebarText(info.portfolioWebsite!),
      ],
    );
  }

  pw.Widget _buildSkillsSection(ResumeModel resume) {
    if (resume.skills == null || resume.skills!.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('SKILLS', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.Divider(color: PdfColors.white, thickness: 0.5),
        pw.SizedBox(height: 8),
        ...resume.skills!.map((s) => _sidebarText(s.name ?? '')),
      ],
    );
  }

  pw.Widget _buildLanguagesSection(ResumeModel resume) {
    if (resume.languages == null || resume.languages!.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('LANGUAGES', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.Divider(color: PdfColors.white, thickness: 0.5),
        pw.SizedBox(height: 8),
        ...resume.languages!.map((l) => _sidebarText('${l.language ?? ""} (${l.proficiency.name})')),
      ],
    );
  }

  pw.Widget _sidebarText(String text) {
    if (text.isEmpty) return pw.SizedBox.shrink();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(text, style: const pw.TextStyle(color: PdfColors.white, fontSize: 9)),
    );
  }

  pw.Widget _buildExperienceSection(ResumeModel resume) {
    if (resume.experience == null || resume.experience!.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Experience', color: PdfColors.blue900),
        ...resume.experience!.map((e) => PdfTimelineItem(
          title: e.company ?? '',
          subtitle: e.position,
          date: '${_formatDate(e.startDate)} - ${e.isCurrentlyWorking == true ? "Present" : _formatDate(e.endDate)}',
          location: e.location,
          description: e.description,
        )),
      ],
    );
  }

  pw.Widget _buildEducationSection(ResumeModel resume) {
    if (resume.education == null || resume.education!.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Education', color: PdfColors.blue900),
        ...resume.education!.map((e) => PdfTimelineItem(
          title: e.school ?? '',
          subtitle: '${e.degree ?? ""} ${e.fieldOfStudy ?? ""}',
          date: '${_formatDate(e.startDate)} - ${e.isCurrentlyStudying == true ? "Present" : _formatDate(e.endDate)}',
          description: e.grade != null && e.grade!.isNotEmpty ? 'Grade: ${e.grade}' : null,
        )),
      ],
    );
  }

  pw.Widget _buildProjectsSection(ResumeModel resume) {
    if (resume.projects == null || resume.projects!.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Projects', color: PdfColors.blue900),
        ...resume.projects!.map((p) => PdfTimelineItem(
          title: p.projectName ?? '',
          subtitle: p.technologies,
          description: p.description,
        )),
      ],
    );
  }

  pw.Widget _buildCertificationsSection(ResumeModel resume) {
    if (resume.certifications == null || resume.certifications!.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Certifications', color: PdfColors.blue900),
        ...resume.certifications!.map((c) => PdfTimelineItem(
          title: c.certificateName ?? '',
          subtitle: c.organization,
          date: _formatDate(c.issueDate),
        )),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }
}
