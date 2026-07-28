import '../../../../data/models/resume/resume_model.dart';
import '../../templates/models/template_model.dart';

class PreviewState {
  final ResumeModel? resume;
  final TemplateModel? selectedTemplate;
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
    TemplateModel? selectedTemplate,
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
