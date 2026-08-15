import 'package:vitafolio/features/resume/data/dto/resume_dto.dart';

/// Abstract contract for parsing resumes from multiple file formats.
abstract class ResumeParserService {
  /// Parses PDF file bytes into structured ResumeDto.
  Future<ResumeDto> parsePdf(List<int> bytes);

  /// Parses DOCX file bytes into structured ResumeDto.
  Future<ResumeDto> parseDocx(List<int> bytes);

  /// Parses Image file bytes via OCR into structured ResumeDto.
  Future<ResumeDto> parseImage(List<int> bytes);

  /// Parses raw string content into structured ResumeDto.
  Future<ResumeDto> parseText(String rawText);
}
