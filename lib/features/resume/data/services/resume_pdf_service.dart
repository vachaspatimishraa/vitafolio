import 'package:vitafolio/features/resume/data/dto/resume_dto.dart';

/// Abstract contract for generating PDF documents from DTO models.
abstract class ResumePdfService {
  /// Generates full production PDF document bytes for a ResumeDto.
  Future<List<int>> generatePdf(ResumeDto resumeDto);

  /// Generates rapid low-res preview PDF document bytes for a ResumeDto.
  Future<List<int>> generatePreview(ResumeDto resumeDto);
}
