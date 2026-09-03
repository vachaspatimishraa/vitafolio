import 'dart:typed_data';
import 'package:vitafolio/core/templates/repository/template_repository.dart';
import 'package:vitafolio/core/templates/ats_professional/ats_pdf_renderer.dart';
import 'package:vitafolio/core/templates/professional_modern/modern_pdf_renderer.dart';
import 'package:vitafolio/core/templates/modern_executive/executive_pdf_renderer.dart';
import 'package:vitafolio/core/templates/awesome_professional/awesome_pdf_renderer.dart';
import 'package:vitafolio/core/templates/academic_blue/academic_pdf_renderer.dart';
import 'package:vitafolio/core/templates/classic_standard/classic_pdf_renderer.dart';
import 'package:vitafolio/core/templates/compact_density/compact_pdf_renderer.dart';
import 'package:vitafolio/core/templates/elegant_serif/elegant_pdf_renderer.dart';
import 'package:vitafolio/core/templates/minimal_clean/minimal_pdf_renderer.dart';
import 'package:vitafolio/core/templates/simple_basic/simple_pdf_renderer.dart';
import 'package:vitafolio/core/templates/renderers/template_renderer.dart';
import 'package:vitafolio/data/models/embedded/education_model.dart';
import 'package:vitafolio/data/models/embedded/experience_model.dart';
import 'package:vitafolio/data/models/embedded/personal_information.dart';
import 'package:vitafolio/data/models/embedded/certification_model.dart';
import 'package:vitafolio/data/models/embedded/language_model.dart';
import 'package:vitafolio/data/models/embedded/project_model.dart';
import 'package:vitafolio/data/models/enums/language_proficiency.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';

/// Centralized service responsible for managing PDF document lifecycle, optimization, and export generation.
class PdfService {
  PdfService();

  /// Converts a domain [Resume] entity into a [WorkflowState] container for rendering.
  static WorkflowState workflowStateFromDomain(Resume resume) {
    final templateId = resume.selectedTemplateId.value.isNotEmpty
        ? resume.selectedTemplateId.value
        : 'ats';

    String s(String? val) => PdfSectionHelper.sanitizeText(val);

    return WorkflowState(
      resumeId: int.tryParse(resume.id.value),
      resumeName: s(resume.title),
      personalInfo: PersonalInformation(
        fullName: s(resume.personalDetails?.fullName),
        jobTitle: s(resume.personalDetails?.jobTitle),
        email: s(resume.personalDetails?.email),
        phone: s(resume.personalDetails?.phoneNumber),
        linkedIn: s(resume.personalDetails?.linkedinUrl),
        github: s(resume.personalDetails?.githubUrl),
        portfolioWebsite: s(resume.personalDetails?.website),
        profileImagePath: resume.personalDetails?.profileImagePath,
      ),
      summary: s(resume.summary?.summaryText),
      education: resume.educations
          .map(
            (e) => EducationModel(
              id: e.id,
              degree: s(e.degree),
              fieldOfStudy: s(e.fieldOfStudy),
              school: s(e.institution),
              grade: s(e.grade),
              startDate: DateRangeFormatter.parseDate(e.startYear),
              endDate: DateRangeFormatter.parseDate(e.endYear),
              isCurrentlyStudying: e.isCurrentlyStudying,
              startYear: s(e.startYear),
              endYear: s(e.endYear),
            ),
          )
          .toList(),
      experience: resume.experiences
          .map(
            (e) => ExperienceModel(
              id: e.id,
              position: s(e.jobTitle),
              company: s(e.company),
              location: s(e.location),
              startDate: DateRangeFormatter.parseDate(e.startDate),
              endDate: DateRangeFormatter.parseDate(e.endDate),
              isCurrentlyWorking: e.isCurrentRole,
              description: s(e.description),
              startDateStr: s(e.startDate),
              endDateStr: s(e.endDate),
            ),
          )
          .toList(),
      skills: resume.skills.map((skill) => s(skill.name)).toList(),
      projects: resume.projects
          .map(
            (p) => ProjectModel(
              id: p.id,
              projectName: s(p.name),
              description: s(p.description),
              technologies: s(p.technologies.join(', ')),
            ),
          )
          .toList(),
      certifications: resume.certifications
          .map(
            (c) => CertificationModel(
              id: c.id,
              certificateName: s(c.name),
              organization: s(c.organization),
              issueDate: DateTime.tryParse(c.issueDate) ?? (int.tryParse(c.issueDate) != null ? DateTime(int.parse(c.issueDate)) : null),
              credentialUrl: s(c.credentialId),
            ),
          )
          .toList(),
      languages: resume.languages
          .map(
            (l) => LanguageModel(
              id: l.id,
              language: s(l.name),
              proficiency: _parseProficiency(l.proficiencyLevel),
            ),
          )
          .toList(),
      selectedTemplateId: templateId,
      fontFamily: resume.fontFamily,
    );
  }

  static LanguageProficiency _parseProficiency(String? val) {
    if (val == null) return LanguageProficiency.beginner;
    final lower = val.toLowerCase();
    if (lower.contains('native') || lower.contains('fluent')) {
      return LanguageProficiency.native;
    } else if (lower.contains('advance')) {
      return LanguageProficiency.advanced;
    } else if (lower.contains('intermed')) {
      return LanguageProficiency.intermediate;
    }
    return LanguageProficiency.beginner;
  }

  /// Resolves appropriate template renderer for a given template ID string.
  ResumeTemplateRenderer resolveRenderer(String templateId) {
    final cleanId = templateId.toLowerCase();
    if (cleanId.contains('modern')) {
      return const ModernPdfRenderer();
    } else if (cleanId.contains('minimal')) {
      return const MinimalPdfRenderer();
    } else if (cleanId.contains('executive')) {
      return const ExecutivePdfRenderer();
    } else if (cleanId.contains('creative') || cleanId.contains('awesome')) {
      return const AwesomePdfRenderer();
    } else if (cleanId.contains('academic')) {
      return const AcademicPdfRenderer();
    } else if (cleanId.contains('classic')) {
      return const ClassicPdfRenderer();
    } else if (cleanId.contains('compact')) {
      return const CompactPdfRenderer();
    } else if (cleanId.contains('elegant')) {
      return const ElegantPdfRenderer();
    } else if (cleanId.contains('simple')) {
      return const SimplePdfRenderer();
    }
    return const AtsPdfRenderer();
  }

  /// Primary API method to generate an optimized PDF from a domain [Resume] entity.
  Future<Uint8List> generatePdfFromDomain(Resume resume) async {
    final templateId = resume.selectedTemplateId.value;
    final template = TemplateRepository().getTemplate(templateId);
    final pdfRenderer = resolveRenderer(template.id);
    final workflowState = workflowStateFromDomain(resume);

    // Diagnostic logging
    // ignore: avoid_print
    print('[PDF] Generate requested for active resume ID: ${resume.id.value}');
    // ignore: avoid_print
    print('[PDF] Resume title: ${resume.title}');
    // ignore: avoid_print
    print('[PDF] Selected Template ID: $templateId (${template.name})');
    // ignore: avoid_print
    print('[PDF] Resolved Renderer: ${pdfRenderer.runtimeType}');

    final doc = pdfRenderer.buildPdf(workflowState);
    final bytes = await doc.save();

    // ignore: avoid_print
    print('[PDF] PDF bytes generated: ${bytes.length} bytes');
    // ignore: avoid_print
    print(
      '[PDF] PDF header valid: ${bytes.length >= 5 && String.fromCharCodes(bytes.take(5)) == "%PDF-"}',
    );

    return bytes;
  }

  /// Backward-compatible method accepting dynamic or legacy resume object.
  Future<Uint8List> generatePdf(dynamic resume) async {
    if (resume is Resume) {
      return generatePdfFromDomain(resume);
    }
    throw Exception('Invalid resume object provided for PDF generation.');
  }
}

