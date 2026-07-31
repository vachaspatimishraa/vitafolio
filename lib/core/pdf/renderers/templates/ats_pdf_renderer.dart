import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../base/pdf_renderer.dart';
import '../../widgets/pdf_header.dart';
import '../../widgets/pdf_section_title.dart';
import '../../widgets/pdf_contact_row.dart';
import '../../widgets/pdf_timeline_item.dart';
import '../../widgets/pdf_footer.dart';
import '../../helpers/pdf_section_helper.dart';
import '../../../../data/models/resume_model.dart';
import '../../../../data/models/embedded/personal_information.dart';

class AtsPdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();

    final widgets = <pw.Widget>[];

    if (resume.personalInfo != null &&
        (resume.personalInfo!.fullName?.trim().isNotEmpty ?? false)) {
      widgets.add(_buildHeader(resume.personalInfo!));
    }

    final contactWidget = _buildContactInfo(resume);
    if (contactWidget is! pw.SizedBox) {
      widgets.add(contactWidget);
    }

    if (PdfSectionHelper.hasSummary(resume.professionalSummary?.summary)) {
      widgets.addAll([
        PdfSectionTitle('Professional Summary'),
        pw.Text(resume.professionalSummary!.summary!.trim(),
            style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 12),
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

    if (PdfSectionHelper.hasProjects(resume.projects)) {
      widgets.add(_buildProjects(resume));
    }

    if (PdfSectionHelper.hasCertifications(resume.certifications)) {
      widgets.add(_buildCertifications(resume));
    }

    if (PdfSectionHelper.hasLanguages(resume.languages)) {
      widgets.add(_buildLanguages(resume));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        footer: (context) => PdfFooter(),
        build: (context) => widgets,
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

    final contactRows = <pw.Widget>[];
    if (info.email?.trim().isNotEmpty ?? false) {
      contactRows.add(PdfContactRow(label: 'Email', value: info.email!.trim()));
    }
    if (info.phone?.trim().isNotEmpty ?? false) {
      contactRows.add(PdfContactRow(label: 'Phone', value: info.phone!.trim()));
    }
    if (info.linkedIn?.trim().isNotEmpty ?? false) {
      contactRows.add(PdfContactRow(label: 'LinkedIn', value: info.linkedIn!.trim()));
    }
    if (info.github?.trim().isNotEmpty ?? false) {
      contactRows.add(PdfContactRow(label: 'GitHub', value: info.github!.trim()));
    }
    if (info.portfolioWebsite?.trim().isNotEmpty ?? false) {
      contactRows.add(PdfContactRow(label: 'Portfolio', value: info.portfolioWebsite!.trim()));
    }

    if (contactRows.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Wrap(
          spacing: 10,
          children: contactRows,
        ),
        pw.Divider(thickness: 0.5, color: PdfColors.grey300),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildExperience(ResumeModel resume) {
    final validList = PdfSectionHelper.validExperiences(resume.experience);
    if (validList.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Experience'),
        ...validList.map((e) => PdfTimelineItem(
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
    final validList = PdfSectionHelper.validEducation(resume.education);
    if (validList.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Education'),
        ...validList.map((e) => PdfTimelineItem(
              title: e.school?.trim() ?? '',
              subtitle: '${e.degree?.trim() ?? ""} ${e.fieldOfStudy?.trim() ?? ""}'.trim(),
              date:
                  '${_formatDate(e.startDate)} - ${e.isCurrentlyStudying == true ? "Present" : _formatDate(e.endDate)}',
              description:
                  e.grade != null && e.grade!.trim().isNotEmpty ? 'Grade: ${e.grade!.trim()}' : null,
            )),
      ],
    );
  }

  pw.Widget _buildSkills(ResumeModel resume) {
    final validList = PdfSectionHelper.validSkillModels(resume.skills);
    if (validList.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Skills'),
        pw.Text(validList.map((s) => s.name!.trim()).join(', '),
            style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 12),
      ],
    );
  }

  pw.Widget _buildProjects(ResumeModel resume) {
    final validList = PdfSectionHelper.validProjects(resume.projects);
    if (validList.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Projects'),
        ...validList.map((p) => PdfTimelineItem(
              title: p.projectName?.trim() ?? '',
              subtitle: p.technologies?.trim(),
              description: p.description?.trim(),
            )),
      ],
    );
  }

  pw.Widget _buildCertifications(ResumeModel resume) {
    final validList = PdfSectionHelper.validCertifications(resume.certifications);
    if (validList.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Certifications'),
        ...validList.map((c) => PdfTimelineItem(
              title: c.certificateName?.trim() ?? '',
              subtitle: c.organization?.trim(),
              date: _formatDate(c.issueDate),
            )),
      ],
    );
  }

  pw.Widget _buildLanguages(ResumeModel resume) {
    final validList = PdfSectionHelper.validLanguages(resume.languages);
    if (validList.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Languages'),
        pw.Text(
            validList
                .map((l) => '${l.language!.trim()} (${l.proficiency.name})')
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

