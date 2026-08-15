import 'package:vitafolio/features/resume/domain/entities/resume.dart';

enum SaveStatus { saved, saving, unsaved, error }

class EditorState {
  final Resume? resume;
  final bool isLoading;
  final bool isSaving;
  final SaveStatus saveStatus;
  final List<String> validationErrors;
  final String? errorMessage;
  final bool hasUnsavedChanges;

  const EditorState({
    this.resume,
    this.isLoading = false,
    this.isSaving = false,
    this.saveStatus = SaveStatus.saved,
    this.validationErrors = const [],
    this.errorMessage,
    this.hasUnsavedChanges = false,
  });

  EditorState copyWith({
    Resume? resume,
    bool? isLoading,
    bool? isSaving,
    SaveStatus? saveStatus,
    List<String>? validationErrors,
    String? errorMessage,
    bool? hasUnsavedChanges,
  }) {
    return EditorState(
      resume: resume ?? this.resume,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      saveStatus: saveStatus ?? this.saveStatus,
      validationErrors: validationErrors ?? this.validationErrors,
      errorMessage: errorMessage ?? this.errorMessage,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }
}
