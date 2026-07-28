import '../models/workflow_state.dart';

class ValidationService {
  static List<String> validateResume(WorkflowState state) {
    final List<String> errors = [];
    if (state.personalInfo.fullName.trim().isEmpty) {
      errors.add('Full Name');
    }
    if (state.personalInfo.email.trim().isEmpty) {
      errors.add('Email');
    }
    return errors;
  }
}
