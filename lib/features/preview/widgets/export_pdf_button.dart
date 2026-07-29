import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/pdf/services/pdf_service.dart';
import '../../../../data/models/embedded/professional_summary.dart';
import '../../../../data/models/embedded/skill_model.dart';
import '../../../../data/models/embedded/template_selection.dart';
import '../../../../data/models/resume_model.dart';
import '../../../../data/repositories/repository_provider.dart';
import '../../workflow/view_model/workflow_view_model.dart';
import '../view_model/preview_view_model.dart';

/// Button that exports the current resume as a PDF using the selected template.
class ExportPdfButton extends ConsumerStatefulWidget {
  const ExportPdfButton({super.key});

  @override
  ConsumerState<ExportPdfButton> createState() => _ExportPdfButtonState();
}

class _ExportPdfButtonState extends ConsumerState<ExportPdfButton> {
  bool _isExporting = false;

  Future<void> _exportPdf() async {
    final previewState = ref.read(previewViewModelProvider);
    final workflowState = ref.read(workflowViewModelProvider);
    final repository = ref.read(resumeRepositoryProvider);

    ResumeModel? resume = previewState.resume;

    if (resume == null) {
      try {
        final allResumes = await repository.getAllResumes();
        if (allResumes.isNotEmpty) {
          resume = allResumes.first;
        }
      } catch (_) {}
    }

    final selectedTemplateId = previewState.selectedTemplate?.id ??
        workflowState.selectedTemplateId ??
        'ats_professional';

    // Merge active domain resume with workflow state data to ensure complete section coverage
    final finalPersonalInfo = (workflowState.personalInfo.fullName?.isNotEmpty ?? false)
        ? workflowState.personalInfo
        : (resume?.personalInfo ?? workflowState.personalInfo);

    final finalSummary = workflowState.summary.isNotEmpty
        ? workflowState.summary
        : (resume?.professionalSummary?.summary ?? workflowState.summary);

    final finalEducation = workflowState.education.isNotEmpty
        ? workflowState.education
        : (resume?.education ?? workflowState.education);

    final finalExperience = workflowState.experience.isNotEmpty
        ? workflowState.experience
        : (resume?.experience ?? workflowState.experience);

    final finalSkillsList = workflowState.skills.isNotEmpty
        ? workflowState.skills
        : (resume?.skills?.map((s) => s.name ?? '').toList() ?? workflowState.skills);

    final finalProjects = workflowState.projects.isNotEmpty
        ? workflowState.projects
        : (resume?.projects ?? workflowState.projects);

    final finalCertifications = workflowState.certifications.isNotEmpty
        ? workflowState.certifications
        : (resume?.certifications ?? workflowState.certifications);

    final finalLanguages = workflowState.languages.isNotEmpty
        ? workflowState.languages
        : (resume?.languages ?? workflowState.languages);

    final safeResumeName = (resume?.resumeName?.isNotEmpty ?? false)
        ? resume!.resumeName!
        : (workflowState.resumeName.isNotEmpty ? workflowState.resumeName : 'My Resume');

    final targetResume = ResumeModel(
      resumeName: safeResumeName,
      personalInfo: finalPersonalInfo,
      professionalSummary: ProfessionalSummary()..summary = finalSummary,
      education: finalEducation,
      experience: finalExperience,
      skills: finalSkillsList.map((s) => SkillModel()..name = s).toList(),
      projects: finalProjects,
      certifications: finalCertifications,
      languages: finalLanguages,
      selectedTemplate: TemplateSelection()..templateId = selectedTemplateId,
    );

    if (resume?.id != null) {
      targetResume.id = resume!.id;
    }

    // Logging verification details
    debugPrint('=== PDF EXPORT DIAGNOSTICS ===');
    debugPrint('Resume ID: ${targetResume.id}');
    debugPrint('Resume Title: ${targetResume.resumeName}');
    debugPrint('Selected Template ID: $selectedTemplateId');
    debugPrint('Experience Entries Count: ${finalExperience.length}');
    debugPrint('Education Entries Count: ${finalEducation.length}');
    debugPrint('Projects Count: ${finalProjects.length}');
    debugPrint('Skills Count: ${finalSkillsList.length}');
    debugPrint('==============================');

    try {
      setState(() {
        _isExporting = true;
      });

      final pdfService = PdfService();
      final bytes = await pdfService.generatePdf(targetResume);

      final tempDir = await getTemporaryDirectory();
      final safeFileName = safeResumeName.replaceAll(RegExp(r'\s+'), '_');
      final file = File('${tempDir.path}/$safeFileName.pdf');
      await file.writeAsBytes(bytes, flush: true);

      await Share.shareXFiles([XFile(file.path)], text: safeResumeName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export PDF: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isExporting ? null : _exportPdf,
      icon: _isExporting
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : const Icon(Icons.download),
      label: Text(_isExporting ? 'Exporting...' : 'Export PDF'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
