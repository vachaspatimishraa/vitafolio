import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../base/pdf_renderer.dart';
import '../../widgets/pdf_header.dart';
import '../../widgets/pdf_section_title.dart';
import '../../widgets/pdf_contact_row.dart';
import '../../widgets/pdf_timeline_item.dart';
import '../../widgets/pdf_footer.dart';
import '../../../../data/models/resume_model.dart';
import '../../../../data/models/embedded/personal_information.dart';

class AtsPdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        footer: (context) => PdfFooter(),
        build: (context) => [
          if (resume.personalInfo != null) _buildHeader(resume.personalInfo!),
          _buildContactInfo(resume),
          if (resume.professionalSummary?.summary?.isNotEmpty ?? false) ...[
            PdfSectionTitle('Professional Summary'),
            pw.Text(resume.professionalSummary!.summary!,
                style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 12),
          ],
          _buildExperience(resume),
          _buildEducation(resume),
          _buildSkills(resume),
          _buildProjects(resume),
          _buildCertifications(resume),
          _buildLanguages(resume),
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(PersonalInformation info) {
    return PdfHeader(info: info);
  }

  pw.Widget _buildContactInfo(ResumeModel resume) {
    final info = resume.personalInfo;
    if (info == null) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Wrap(
          spacing: 10,
          children: [
            if (info.email != null && info.email!.isNotEmpty)
              PdfContactRow(label: 'Email', value: info.email!),
            if (info.phone != null && info.phone!.isNotEmpty)
              PdfContactRow(label: 'Phone', value: info.phone!),
            if (info.linkedIn != null && info.linkedIn!.isNotEmpty)
              PdfContactRow(label: 'LinkedIn', value: info.linkedIn!),
            if (info.github != null && info.github!.isNotEmpty)
              PdfContactRow(label: 'GitHub', value: info.github!),
            if (info.portfolioWebsite != null && info.portfolioWebsite!.isNotEmpty)
              PdfContactRow(label: 'Portfolio', value: info.portfolioWebsite!),
          ],
        ),
        pw.Divider(thickness: 0.5, color: PdfColors.grey300),
        pw.SizedBox(height: 10),
      ],
    );
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
              description:
                  e.grade != null && e.grade!.isNotEmpty ? 'Grade: ${e.grade}' : null,
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
        PdfSectionTitle('Skills'),
        pw.Text(resume.skills!.map((s) => s.name).join(', '),
            style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 12),
      ],
    );
  }

  pw.Widget _buildProjects(ResumeModel resume) {
    if (resume.projects == null || resume.projects!.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Projects'),
        ...resume.projects!.map((p) => PdfTimelineItem(
              title: p.projectName ?? '',
              subtitle: p.technologies,
              description: p.description,
            )),
      ],
    );
  }

  pw.Widget _buildCertifications(ResumeModel resume) {
    if (resume.certifications == null || resume.certifications!.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Certifications'),
        ...resume.certifications!.map((c) => PdfTimelineItem(
              title: c.certificateName ?? '',
              subtitle: c.organization,
              date: _formatDate(c.issueDate),
            )),
      ],
    );
  }

  pw.Widget _buildLanguages(ResumeModel resume) {
    if (resume.languages == null || resume.languages!.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Languages'),
        pw.Text(
            resume.languages!
                .map((l) => '${l.language ?? ""} (${l.proficiency.name})')
                .join(', '),
            style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 12),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }
}
