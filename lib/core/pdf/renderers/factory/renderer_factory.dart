import 'package:vitafolio/core/pdf/renderers/base/pdf_renderer.dart';
import 'package:vitafolio/core/pdf/renderers/templates/ats_pdf_renderer.dart';
import 'package:vitafolio/core/pdf/renderers/templates/modern_pdf_renderer.dart';
import 'package:vitafolio/core/pdf/renderers/templates/minimal_pdf_renderer.dart';
import 'package:vitafolio/core/pdf/renderers/templates/executive_pdf_renderer.dart';
import 'package:vitafolio/core/pdf/renderers/templates/creative_pdf_renderer.dart';

class RendererFactory {
  static final RendererFactory _instance = RendererFactory._internal();

  factory RendererFactory() => _instance;

  RendererFactory._internal();

  PdfRenderer getRenderer(String templateId) {
    final cleanId = templateId.toLowerCase();
    if (cleanId.contains('modern')) {
      return ModernPdfRenderer();
    } else if (cleanId.contains('minimal')) {
      return MinimalPdfRenderer();
    } else if (cleanId.contains('executive')) {
      return ExecutivePdfRenderer();
    } else if (cleanId.contains('creative')) {
      return CreativePdfRenderer();
    }
    return AtsPdfRenderer();
  }
}

