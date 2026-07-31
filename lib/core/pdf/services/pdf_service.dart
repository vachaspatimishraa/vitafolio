import 'package:flutter/foundation.dart';
import '../../../../data/models/resume_model.dart';
import '../../../../data/models/embedded/personal_information.dart';
import '../../../../features/workflow/models/workflow_state.dart';
import '../../templates/repository/template_repository.dart' as core_repo;

/// Centralized service responsible for managing PDF document lifecycle, optimization, and export generation.
class PdfService {
  final core_repo.TemplateRepository _templateRepository;

  PdfService({core_repo.TemplateRepository? templateRepository})
    : _templateRepository =
          templateRepository ?? core_repo.TemplateRepository();

  /// Primary API method to generate an optimized PDF from a [ResumeModel].
  Future<Uint8List> generatePdf(ResumeModel resume) async {
    try {
      final templateId =
          resume.selectedTemplate?.templateId ?? 'ats_professional';
      final template = _templateRepository.getTemplate(templateId);

      final renderData = WorkflowState(
        personalInfo: resume.personalInfo ?? PersonalInformation(),
        summary: resume.professionalSummary?.summary ?? '',
        education: resume.education ?? [],
        experience: resume.experience ?? [],
        skills: resume.skills?.map((s) => s.name ?? '').toList() ?? [],
        projects: resume.projects ?? [],
        certifications: resume.certifications ?? [],
        languages: resume.languages ?? [],
        selectedTemplateId: templateId,
      );

      final doc = template.renderer.buildPdf(renderData);
      return await doc.save();
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[PdfService] Failed to generate PDF: $e\n$st');
      }
      // Fallback to ATS renderer if any error occurs
      final template = _templateRepository.defaultTemplate();
      final renderData = WorkflowState(
        personalInfo: resume.personalInfo ?? PersonalInformation(),
        summary: resume.professionalSummary?.summary ?? '',
        education: resume.education ?? [],
        experience: resume.experience ?? [],
        skills: resume.skills?.map((s) => s.name ?? '').toList() ?? [],
        projects: resume.projects ?? [],
        certifications: resume.certifications ?? [],
        languages: resume.languages ?? [],
        selectedTemplateId: template.id,
      );
      final doc = template.renderer.buildPdf(renderData);
      return await doc.save();
    }
  }

  /// Alias for backward compatibility if `generateResumePdf` is called elsewhere.
  Future<Uint8List> generateResumePdf(
    ResumeModel resume, {
    String fontFamilyName = 'Roboto',
    String themeName = 'modern',
  }) async {
    return generatePdf(resume);
  }
}
