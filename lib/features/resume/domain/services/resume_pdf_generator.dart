import 'package:vitafolio/features/resume/domain/entities/resume.dart';

/// Abstract Domain Service Contract defining PDF generation behavior.
/// Free of Syncfusion, pdf package, or file system writing implementation dependencies.
abstract class ResumePdfGenerator {
  /// Generates full production PDF document bytes for a given Resume entity.
  Future<List<int>> generatePdf(Resume resume);

  /// Generates rapid low-res preview PDF document bytes for a given Resume entity.
  Future<List<int>> generatePreview(Resume resume);
}
