/// Abstract interface for OCR text extraction from images or image-based PDF pages.
abstract class ResumeOcrService {
  /// Extracts text from the given image byte payload.
  /// Returns `null` or empty string if text could not be recognized.
  Future<String?> extractTextFromImageBytes(List<int> imageBytes);
}
