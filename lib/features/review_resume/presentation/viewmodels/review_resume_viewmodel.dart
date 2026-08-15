import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/core/templates/repository/template_repository.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/calculate_resume_completion.dart';
import 'package:vitafolio/features/resume/domain/usecases/generate_resume_pdf.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/validate_resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class SectionStatus {
  final String title;
  final String route;
  final bool isCompleted;

  const SectionStatus({
    required this.title,
    required this.route,
    required this.isCompleted,
  });
}

class ReviewResumeState {
  final Resume? resume;
  final String templateName;
  final String? previewImage;
  final bool isAtsFriendly;
  final int completedSections;
  final int totalSections;
  final double completionPercentage;
  final List<SectionStatus> sections;
  final bool isGenerating;
  final String? selectedSection;
  final bool isLoading;
  final String? errorMessage;

  const ReviewResumeState({
    this.resume,
    this.templateName = 'Modern Professional',
    this.previewImage,
    this.isAtsFriendly = true,
    this.completedSections = 0,
    this.totalSections = 10,
    this.completionPercentage = 0.0,
    this.sections = const [
      SectionStatus(
        title: 'Document Title',
        route: '/templates',
        isCompleted: false,
      ),
      SectionStatus(
        title: 'Template Selection',
        route: '/templates',
        isCompleted: false,
      ),
      SectionStatus(
        title: 'Personal Details',
        route: '/personal',
        isCompleted: false,
      ),
      SectionStatus(
        title: 'Professional Summary',
        route: '/summary',
        isCompleted: false,
      ),
      SectionStatus(
        title: 'Work Experience',
        route: '/experience',
        isCompleted: false,
      ),
      SectionStatus(
        title: 'Projects',
        route: '/projects',
        isCompleted: false,
      ),
      SectionStatus(
        title: 'Education',
        route: '/education',
        isCompleted: false,
      ),
      SectionStatus(
        title: 'Technical Skills',
        route: '/skills',
        isCompleted: false,
      ),
      SectionStatus(
        title: 'Certifications',
        route: '/certifications',
        isCompleted: false,
      ),
      SectionStatus(
        title: 'Languages',
        route: '/languages',
        isCompleted: false,
      ),
    ],
    this.isGenerating = false,
    this.selectedSection,
    this.isLoading = false,
    this.errorMessage,
  });

  ReviewResumeState copyWith({
    Resume? resume,
    String? templateName,
    String? previewImage,
    bool? isAtsFriendly,
    int? completedSections,
    int? totalSections,
    double? completionPercentage,
    List<SectionStatus>? sections,
    bool? isGenerating,
    String? selectedSection,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReviewResumeState(
      resume: resume ?? this.resume,
      templateName: templateName ?? this.templateName,
      previewImage: previewImage ?? this.previewImage,
      isAtsFriendly: isAtsFriendly ?? this.isAtsFriendly,
      completedSections: completedSections ?? this.completedSections,
      totalSections: totalSections ?? this.totalSections,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      sections: sections ?? this.sections,
      isGenerating: isGenerating ?? this.isGenerating,
      selectedSection: selectedSection ?? this.selectedSection,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ReviewResumeViewModel extends StateNotifier<ReviewResumeState> {
  final Ref _ref;
  final GetResume _getResume;
  final CalculateResumeCompletion _calculateCompletion;
  final ValidateResume _validateResume;
  final GenerateResumePdf _generatePdf;

  ReviewResumeViewModel(
    this._ref,
    this._getResume,
    this._calculateCompletion,
    this._validateResume,
    this._generatePdf,
  ) : super(const ReviewResumeState(isLoading: true)) {
    loadResume();
  }

  Future<void> loadResume() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      ResumeId? activeId = _ref.read(activeResumeIdProvider);
      debugPrint('REVIEW: Active Resume ID = ${activeId?.value}');

      if (activeId == null || activeId.value.isEmpty) {
        final getAllResumes = _ref.read(getAllResumesUseCaseProvider);
        final allResumes = await getAllResumes();
        debugPrint('REVIEW: Fallback getAllResumes count = ${allResumes.length}');
        if (allResumes.isNotEmpty) {
          activeId = allResumes.first.id;
          _ref.read(activeResumeIdProvider.notifier).state = activeId;
        }
      }

      if (activeId != null && activeId.value.isNotEmpty) {
        final resume = await _getResume(activeId);
        debugPrint('REVIEW: Fetched Resume = ${resume?.id.value}, title = ${resume?.title}');

        if (resume != null) {
          final progress = _calculateCompletion(resume);
          final completedCount = _calculateCompletion.completedSections(resume);
          final total = _calculateCompletion.totalSections();

          final updatedSections = state.sections.map((section) {
            bool isCompleted = false;
            switch (section.title) {
              case 'Document Title':
                isCompleted = resume.title.trim().isNotEmpty;
                break;
              case 'Template Selection':
                isCompleted = resume.selectedTemplateId.value.trim().isNotEmpty;
                break;
              case 'Personal Details':
                isCompleted =
                    resume.personalDetails != null &&
                    resume.personalDetails!.fullName.trim().isNotEmpty &&
                    resume.personalDetails!.email.trim().isNotEmpty &&
                    resume.personalDetails!.phoneNumber.trim().isNotEmpty;
                break;
              case 'Professional Summary':
                isCompleted =
                    resume.summary != null &&
                    resume.summary!.summaryText.trim().isNotEmpty;
                break;
              case 'Work Experience':
                isCompleted =
                    resume.experiences.isNotEmpty &&
                    resume.experiences.every(
                      (exp) =>
                          exp.jobTitle.trim().isNotEmpty &&
                          exp.company.trim().isNotEmpty,
                    );
                break;
              case 'Projects':
                isCompleted =
                    resume.projects.isNotEmpty &&
                    resume.projects.every(
                      (p) =>
                          p.name.trim().isNotEmpty &&
                          p.description.trim().isNotEmpty,
                    );
                break;
              case 'Education':
                isCompleted =
                    resume.educations.isNotEmpty &&
                    resume.educations.every(
                      (edu) =>
                          edu.degree.trim().isNotEmpty &&
                          edu.institution.trim().isNotEmpty,
                    );
                break;
              case 'Technical Skills':
                isCompleted =
                    resume.skills.isNotEmpty &&
                    resume.skills.every((s) => s.name.trim().isNotEmpty);
                break;
              case 'Certifications':
                isCompleted =
                    resume.certifications.isNotEmpty &&
                    resume.certifications.every(
                      (c) =>
                          c.name.trim().isNotEmpty &&
                          c.organization.trim().isNotEmpty,
                    );
                break;
              case 'Languages':
                isCompleted =
                    resume.languages.isNotEmpty &&
                    resume.languages.every(
                      (l) =>
                          l.name.trim().isNotEmpty &&
                          l.proficiencyLevel.trim().isNotEmpty,
                    );
                break;
            }
            return SectionStatus(
              title: section.title,
              route: section.route,
              isCompleted: isCompleted,
            );
          }).toList();

          final templateObj = TemplateRepository().getTemplate(
            resume.selectedTemplateId.value,
          );

          state = state.copyWith(
            resume: resume,
            templateName: templateObj.name,
            previewImage: templateObj.previewAsset,
            isAtsFriendly: templateObj.atsRating >= 5,
            completionPercentage: progress,
            completedSections: completedCount,
            totalSections: total,
            sections: updatedSections,
            isLoading: false,
          );
          return;
        }
      }

      debugPrint('REVIEW: No active resume resolved.');
      state = state.copyWith(
        isLoading: false,
        resume: null,
      );
    } catch (e, stack) {
      debugPrint('REVIEW LOAD ERROR: $e\n$stack');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load resume for review: $e',
      );
    }
  }

  void selectSection(String sectionTitle) {
    state = state.copyWith(selectedSection: sectionTitle);
  }

  void setGenerating(bool generating) {
    state = state.copyWith(isGenerating: generating);
  }

  Future<List<int>?> generateResume() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId == null) return null;

    state = state.copyWith(isGenerating: true);
    try {
      final resume = await _getResume(activeId);
      if (resume != null) {
        final failures = _validateResume(resume);
        if (failures.isNotEmpty) {
          final errorText = failures.map((f) => f.message).join(' and ');
          state = state.copyWith(
            isGenerating: false,
            errorMessage: 'Please check required fields: $errorText.',
          );
          return null;
        }
        final bytes = await _generatePdf(resume);
        state = state.copyWith(isGenerating: false);
        return bytes;
      }
      state = state.copyWith(isGenerating: false);
      return null;
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: 'Failed to generate resume PDF: ${e.toString()}',
      );
      return null;
    }
  }
}

final reviewResumeViewModelProvider =
    StateNotifierProvider.autoDispose<ReviewResumeViewModel, ReviewResumeState>(
      (ref) {
        ref.watch(activeResumeIdProvider);
        final getResume = ref.watch(getResumeUseCaseProvider);
        final calculateCompletion = ref.watch(
          calculateResumeCompletionUseCaseProvider,
        );
        final validateResume = ref.watch(validateResumeUseCaseProvider);
        final generatePdf = ref.watch(generateResumePdfUseCaseProvider);
        return ReviewResumeViewModel(
          ref,
          getResume,
          calculateCompletion,
          validateResume,
          generatePdf,
        );
      },
    );
