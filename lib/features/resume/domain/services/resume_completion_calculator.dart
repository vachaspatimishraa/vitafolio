import 'package:vitafolio/features/resume/domain/entities/resume.dart';

/// Abstract Domain Service Contract defining completion percentage calculations.
abstract class ResumeCompletionCalculator {
  /// Calculates the progress completion ratio (0.0 to 1.0) for a given Resume entity.
  double calculateProgress(Resume resume);

  /// Returns the total number of completed sections for a given Resume entity.
  int completedSections(Resume resume);

  /// Returns the total number of evaluable resume sections (default: 9).
  int totalSections();
}
