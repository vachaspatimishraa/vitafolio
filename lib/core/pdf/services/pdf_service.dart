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

    return WorkflowState(
      resumeId: int.tryParse(resume.id.value),
      resumeName: resume.title,
      personalInfo: PersonalInformation(
        fullName: resume.personalDetails?.fullName,
        jobTitle: resume.personalDetails?.jobTitle,
        email: resume.personalDetails?.email,
        phone: resume.personalDetails?.phoneNumber,
        linkedIn: resume.personalDetails?.linkedinUrl,
        github: resume.personalDetails?.githubUrl,
        portfolioWebsite: resume.personalDetails?.website,
        profileImagePath: resume.personalDetails?.profileImagePath,
      ),
      summary: resume.summary?.summaryText ?? '',
      education: resume.educations
          .map(
            (e) => EducationModel(
              id: e.id,
              degree: e.degree,
              fieldOfStudy: e.fieldOfStudy,
              school: e.institution,
              grade: e.grade,
              isCurrentlyStudying: e.isCurrentlyStudying,
            ),
          )
          .toList(),
      experience: resume.experiences
          .map(
            (e) => ExperienceModel(
              id: e.id,
              position: e.jobTitle,
              company: e.company,
              location: e.location,
              isCurrentlyWorking: e.isCurrentRole,
              description: e.description,
            ),
          )
          .toList(),
      skills: resume.skills.map((s) => s.name).toList(),
      projects: resume.projects
          .map(
            (p) => ProjectModel(
              id: p.id,
              projectName: p.name,
              description: p.description,
              technologies: p.technologies.join(', '),
            ),
          )
          .toList(),
      certifications: resume.certifications
          .map(
            (c) => CertificationModel(
              id: c.id,
              certificateName: c.name,
              organization: c.organization,
              credentialUrl: c.credentialId,
            ),
          )
          .toList(),
      languages: resume.languages
          .map(
            (l) => LanguageModel(
              id: l.id,
              language: l.name,
              proficiency: _parseProficiency(l.proficiencyLevel),
            ),
          )
          .toList(),
      selectedTemplateId: templateId,
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

