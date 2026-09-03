import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vitafolio/features/resume/domain/services/resume_ocr_service.dart';

/// Real production Android OCR implementation using Google ML Kit Text Recognition.
class ProductionResumeOcrService implements ResumeOcrService {
  final TextRecognizer _recognizer;

  ProductionResumeOcrService({TextRecognizer? recognizer})
      : _recognizer = recognizer ?? TextRecognizer(script: TextRecognitionScript.latin);

  @override
  Future<String?> extractTextFromImageBytes(List<int> imageBytes) async {
    if (kDebugMode) {
      print('[ResumeOcrService] Implementation: ProductionResumeOcrService (Google ML Kit)');
      print('[ResumeOcrService] Initializing Android OCR engine');
      print('[ResumeOcrService] OCR engine: Google ML Kit Text Recognition');
      print('[ResumeOcrService] OCR script: Latin');
      print('[ResumeOcrService] OCR request started with ${imageBytes.length} image bytes');
    }

    if (imageBytes.isEmpty) {
      if (kDebugMode) {
        print('[ResumeOcrService] ERROR: OCR image bytes are empty. Code: OCR_IMAGE_EMPTY');
      }
      return null;
    }

    File? tempFile;
    try {
      final tempDir = await getTemporaryDirectory();
      String fileExt = 'png';
      if (imageBytes.length >= 2 && imageBytes[0] == 0xFF && imageBytes[1] == 0xD8) {
        fileExt = 'jpg';
      }
      final tempPath = '${tempDir.path}/ocr_input_${DateTime.now().microsecondsSinceEpoch}.$fileExt';
      tempFile = File(tempPath);
      await tempFile.writeAsBytes(imageBytes);

      final inputImage = InputImage.fromFilePath(tempPath);
      if (kDebugMode) {
        print('[ResumeOcrService] Input image created successfully from file path');
        print('[ResumeOcrService] Sending image to OCR engine...');
      }

      final recognizedText = await _recognizer.processImage(inputImage);
      final text = recognizedText.text.trim();

      if (kDebugMode) {
        print('[ResumeOcrService] OCR engine returned successfully');
        print('[ResumeOcrService] Recognized text length: ${text.length}');
        if (text.isEmpty) {
          print('[ResumeOcrService] Diagnostic State: OCR_EMPTY_RESULT');
        }
      }

      return text;
    } catch (e, stack) {
      if (kDebugMode) {
        print('[ResumeOcrService] ERROR: OCR processing failed: $e. Diagnostic State: OCR_PROCESSING_FAILED');
        print('[ResumeOcrService] Stack trace: $stack');
      }
      return null;
    } finally {
      if (tempFile != null && await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
    }
  }

  /// Disposes the underlying Google ML Kit TextRecognizer.
  Future<void> dispose() async {
    await _recognizer.close();
  }
}
