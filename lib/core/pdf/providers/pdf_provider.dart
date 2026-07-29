import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/pdf_service.dart';

/// Provider exposing the [PdfService] instance for Riverpod dependency injection.
final pdfServiceProvider = Provider<PdfService>((ref) {
  return PdfService();
});
