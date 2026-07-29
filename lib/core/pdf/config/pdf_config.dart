import 'package:pdf/pdf.dart';

/// Configuration class for the PDF generation engine.
class PdfConfig {
  PdfConfig._();

  /// Default page format is A4 (Portrait) with 15mm margins on all sides.
  static PdfPageFormat get defaultPageFormat {
    const double margin = 15.0 * PdfPageFormat.mm;
    return PdfPageFormat.a4.copyWith(
      marginTop: margin,
      marginBottom: margin,
      marginLeft: margin,
      marginRight: margin,
    );
  }

  /// Metadata configurations for the PDF document.
  static PdfMetadata getMetadata({
    required String title,
    String author = 'Vitafolio',
    String subject = 'Professional Resume',
    String creator = 'Vitafolio App',
    String keywords = 'Resume, CV, Professional, Vitafolio',
  }) {
    return PdfMetadata(
      title: title,
      author: author,
      subject: subject,
      creator: creator,
      keywords: keywords,
    );
  }
}

/// Helper class containing metadata fields to configure a PDF document.
class PdfMetadata {
  final String title;
  final String author;
  final String subject;
  final String creator;
  final String keywords;

  const PdfMetadata({
    required this.title,
    required this.author,
    required this.subject,
    required this.creator,
    required this.keywords,
  });
}
