import '../base/pdf_renderer.dart';
import '../templates/ats_pdf_renderer.dart';
import '../templates/creative_pdf_renderer.dart';
import '../templates/executive_pdf_renderer.dart';
import '../templates/minimal_pdf_renderer.dart';
import '../templates/modern_pdf_renderer.dart';

class RendererFactory {
  static final RendererFactory _instance = RendererFactory._internal();

  factory RendererFactory() => _instance;

  RendererFactory._internal();

  PdfRenderer getRenderer(String templateId) {
    switch (templateId) {
      case 'modern_clean':
        return ModernPdfRenderer();
      case 'ats_pro':
      case 'ats_professional':
        return AtsPdfRenderer();
      case 'minimal_elegant':
      case 'minimal':
        return MinimalPdfRenderer();
      case 'executive_classic':
      case 'executive':
        return ExecutivePdfRenderer();
      case 'creative_modern':
      case 'creative':
        return CreativePdfRenderer();
      default:
        return AtsPdfRenderer();
    }
  }
}
