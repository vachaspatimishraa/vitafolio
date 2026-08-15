import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/services/resume_completion_calculator.dart';

/// Use case for calculating section completion statistics for a Resume entity.
class CalculateResumeCompletion {
  final ResumeCompletionCalculator calculator;

  const CalculateResumeCompletion(this.calculator);

  double call(Resume resume) {
    return calculator.calculateProgress(resume);
  }

  int completedSections(Resume resume) {
    return calculator.completedSections(resume);
  }

  int totalSections() {
    return calculator.totalSections();
  }
}
