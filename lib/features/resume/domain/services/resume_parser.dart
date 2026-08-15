import 'package:vitafolio/features/resume/domain/entities/resume.dart';

/// Abstract Domain Service Contract for parsing uploaded file content into a Resume entity.
/// Free of infrastructure, file IO, OCR, or AI service implementations.
abstract class ResumeParser {
  /// Parses content at a file path into a domain Resume entity.
  Future<Resume> parseFile(String filePath);

  /// Parses raw text string into a domain Resume entity.
  Future<Resume> parseText(String rawText);
}
