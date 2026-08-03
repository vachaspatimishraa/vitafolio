import 'package:vitafolio/data/models/resume_model.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart' as core;

class PreviewState {
  final ResumeModel? resume;
  final core.ResumeTemplate? selectedTemplate;
  final double scale;
  final bool isLoading;
  final bool isError;
  final String? errorMessage;

  const PreviewState({
    this.resume,
    this.selectedTemplate,
    this.scale = 1.0,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
  });

  PreviewState copyWith({
    ResumeModel? resume,
    core.ResumeTemplate? selectedTemplate,
    double? scale,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PreviewState(
      resume: resume ?? this.resume,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      scale: scale ?? this.scale,
      isLoading: isLoading ?? this.isLoading,
      isError: clearError ? false : (isError ?? this.isError),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
