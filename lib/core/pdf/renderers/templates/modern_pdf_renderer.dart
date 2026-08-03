import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vitafolio/core/pdf/renderers/base/pdf_renderer.dart';
import 'package:vitafolio/core/pdf/widgets/pdf_section_title.dart';
import 'package:vitafolio/core/pdf/widgets/pdf_timeline_item.dart';
import 'package:vitafolio/core/pdf/widgets/pdf_footer.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/data/models/resume_model.dart';
import 'package:vitafolio/data/models/embedded/personal_information.dart';

class ModernPdfRenderer implements PdfRenderer {
  @override
  Future<pw.Document> render(ResumeModel resume) async {
    final pdf = pw.Document();

    final hasContact =
        resume.personalInfo != null &&
        ((resume.personalInfo!.email?.trim().isNotEmpty ?? false) ||
            (resume.personalInfo!.phone?.trim().isNotEmpty ?? false) ||
            (resume.personalInfo!.linkedIn?.trim().isNotEmpty ?? false) ||
            (resume.personalInfo!.github?.trim().isNotEmpty ?? false) ||
            (resume.personalInfo!.portfolioWebsite?.trim().isNotEmpty ??
                false));

    final hasSkills = PdfSectionHelper.hasSkills(resume.skills);
    final hasLanguages = PdfSectionHelper.hasLanguages(resume.languages);

    final sidebarChildren = <pw.Widget>[];

    if (resume.personalInfo?.fullName?.trim().isNotEmpty ?? false) {
      sidebarChildren.add(
        pw.Text(
          resume.personalInfo!.fullName!.trim(),
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
    }

    if (resume.personalInfo?.jobTitle?.trim().isNotEmpty ?? false) {
      sidebarChildren.add(pw.SizedBox(height: 5));
      sidebarChildren.add(
        pw.Text(
          resume.personalInfo!.jobTitle!.trim(),
          style: const pw.TextStyle(color: PdfColors.white, fontSize: 12),
        ),
      );
    }

    if (sidebarChildren.isNotEmpty) {
      sidebarChildren.add(pw.SizedBox(height: 30));
    }

    if (hasContact) {
      sidebarChildren.add(_buildContactSection(resume.personalInfo));
    }

    if (hasSkills) {
      if (sidebarChildren.isNotEmpty && sidebarChildren.last is! pw.SizedBox) {
        sidebarChildren.add(pw.SizedBox(height: 30));
      }
      sidebarChildren.add(_buildSkillsSection(resume));
    }

    if (hasLanguages) {
      if (sidebarChildren.isNotEmpty && sidebarChildren.last is! pw.SizedBox) {
        sidebarChildren.add(pw.SizedBox(height: 30));
      }
      sidebarChildren.add(_buildLanguagesSection(resume));
    }

    final mainContentChildren = <pw.Widget>[];

    if (PdfSectionHelper.hasSummary(resume.professionalSummary?.summary)) {
      mainContentChildren.addAll([
        PdfSectionTitle('Summary', color: PdfColors.blue900),
        pw.Text(
          resume.professionalSummary!.summary!.trim(),
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 20),
      ]);
    }

    if (PdfSectionHelper.hasExperience(resume.experience)) {
      mainContentChildren.add(_buildExperienceSection(resume));
    }

    if (PdfSectionHelper.hasEducation(resume.education)) {
      mainContentChildren.add(_buildEducationSection(resume));
    }

    if (PdfSectionHelper.hasProjects(resume.projects)) {
      mainContentChildren.add(_buildProjectsSection(resume));
    }

    if (PdfSectionHelper.hasCertifications(resume.certifications)) {
      mainContentChildren.add(_buildCertificationsSection(resume));
    }

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
                    children: sidebarChildren,
                  ),
                ),
                // Main Content
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(30),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: mainContentChildren,
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
    final items = <pw.Widget>[];
    if (info.email?.trim().isNotEmpty ?? false) {
      _addSidebarText(items, info.email!.trim());
    }
    if (info.phone?.trim().isNotEmpty ?? false) {
      _addSidebarText(items, info.phone!.trim());
    }
    if (info.linkedIn?.trim().isNotEmpty ?? false) {
      _addSidebarText(items, info.linkedIn!.trim());
    }
    if (info.github?.trim().isNotEmpty ?? false) {
      _addSidebarText(items, info.github!.trim());
    }
    if (info.portfolioWebsite?.trim().isNotEmpty ?? false) {
      _addSidebarText(items, info.portfolioWebsite!.trim());
    }

    if (items.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'CONTACT',
          style: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),
        pw.Divider(color: PdfColors.white, thickness: 0.5),
        pw.SizedBox(height: 8),
        ...items,
      ],
    );
  }

  pw.Widget _buildSkillsSection(ResumeModel resume) {
    final validSkills = PdfSectionHelper.validSkillModels(resume.skills);
    if (validSkills.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'SKILLS',
          style: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),
        pw.Divider(color: PdfColors.white, thickness: 0.5),
        pw.SizedBox(height: 8),
        ...validSkills.map((s) => _sidebarText(s.name!.trim())),
      ],
    );
  }

  pw.Widget _buildLanguagesSection(ResumeModel resume) {
    final validLanguages = PdfSectionHelper.validLanguages(resume.languages);
    if (validLanguages.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'LANGUAGES',
          style: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),
        pw.Divider(color: PdfColors.white, thickness: 0.5),
        pw.SizedBox(height: 8),
        ...validLanguages.map(
          (l) => _sidebarText('${l.language!.trim()} (${l.proficiency.name})'),
        ),
      ],
    );
  }

  void _addSidebarText(List<pw.Widget> list, String text) {
    list.add(
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Text(
          text,
          style: const pw.TextStyle(color: PdfColors.white, fontSize: 9),
        ),
      ),
    );
  }

  pw.Widget _sidebarText(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
        text,
        style: const pw.TextStyle(color: PdfColors.white, fontSize: 9),
      ),
    );
  }

  pw.Widget _buildExperienceSection(ResumeModel resume) {
    final validExperiences = PdfSectionHelper.validExperiences(
      resume.experience,
    );
    if (validExperiences.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Experience', color: PdfColors.blue900),
        ...validExperiences.map(
          (e) => PdfTimelineItem(
            title: e.company?.trim() ?? '',
            subtitle: e.position?.trim(),
            date:
                '${_formatDate(e.startDate)} - ${e.isCurrentlyWorking == true ? "Present" : _formatDate(e.endDate)}',
            location: e.location?.trim(),
            description: e.description?.trim(),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildEducationSection(ResumeModel resume) {
    final validEducation = PdfSectionHelper.validEducation(resume.education);
    if (validEducation.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Education', color: PdfColors.blue900),
        ...validEducation.map(
          (e) => PdfTimelineItem(
            title: e.school?.trim() ?? '',
            subtitle:
                '${e.degree?.trim() ?? ""} ${e.fieldOfStudy?.trim() ?? ""}'
                    .trim(),
            date:
                '${_formatDate(e.startDate)} - ${e.isCurrentlyStudying == true ? "Present" : _formatDate(e.endDate)}',
            description: e.grade != null && e.grade!.trim().isNotEmpty
                ? 'Grade: ${e.grade!.trim()}'
                : null,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildProjectsSection(ResumeModel resume) {
    final validProjects = PdfSectionHelper.validProjects(resume.projects);
    if (validProjects.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Projects', color: PdfColors.blue900),
        ...validProjects.map(
          (p) => PdfTimelineItem(
            title: p.projectName?.trim() ?? '',
            subtitle: p.technologies?.trim(),
            description: p.description?.trim(),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildCertificationsSection(ResumeModel resume) {
    final validCerts = PdfSectionHelper.validCertifications(
      resume.certifications,
    );
    if (validCerts.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfSectionTitle('Certifications', color: PdfColors.blue900),
        ...validCerts.map(
          (c) => PdfTimelineItem(
            title: c.certificateName?.trim() ?? '',
            subtitle: c.organization?.trim(),
            date: _formatDate(c.issueDate),
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
