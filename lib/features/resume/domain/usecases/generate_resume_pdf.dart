import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/services/resume_pdf_generator.dart';

/// Use case for generating PDF document bytes for a Resume entity.
class GenerateResumePdf {
  final ResumePdfGenerator generator;

  const GenerateResumePdf(this.generator);

  Future<List<int>> call(Resume resume) {
    return generator.generatePdf(resume);
  }
}
