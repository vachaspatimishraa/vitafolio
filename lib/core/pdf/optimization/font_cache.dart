import 'package:pdf/widgets.dart' as pw;

import 'package:vitafolio/core/pdf/fonts/font_manager.dart';

/// Single source of truth for TTF font loading and caching in PDF generation.
/// Guarantees fonts load only once and provides consistent typography.
class FontCache {
  FontCache._internal();
  static final FontCache _instance = FontCache._internal();
  factory FontCache() => _instance;

  pw.Font? _regularFont;
  pw.Font? _mediumFont;
  pw.Font? _boldFont;
  pw.Font? _italicFont;

  bool _isInitialized = false;

  /// Preloads standard fonts into memory cache.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final fontManager = FontManager.instance;
      final roboto = await fontManager.getFontFamily('roboto');

      _regularFont = roboto.regular;
      _mediumFont = roboto.medium;
      _boldFont = roboto.bold;
      _italicFont = pw.Font.helveticaOblique(); // Use built-in italic fallback
    } catch (_) {
      _regularFont = pw.Font.helvetica();
      _boldFont = pw.Font.helveticaBold();
      _italicFont = pw.Font.helveticaOblique();
      _mediumFont = pw.Font.helveticaBold();
    }

    _isInitialized = true;
  }

  pw.Font get regular => _regularFont ?? pw.Font.helvetica();
  pw.Font get medium => _mediumFont ?? pw.Font.helveticaBold();
  pw.Font get bold => _boldFont ?? pw.Font.helveticaBold();
  pw.Font get italic => _italicFont ?? pw.Font.helveticaOblique();

  /// Theme-ready Font Theme for pw.Document
  pw.ThemeData get pdfThemeData {
    final baseFont = regular;
    final boldFont = bold;
    final italicFont = italic;

    return pw.ThemeData.withFont(
      base: baseFont,
      bold: boldFont,
      italic: italicFont,
      boldItalic: boldFont,
    );
  }

  /// Clears cache when memory cleanup is triggered.
  void clear() {
    _regularFont = null;
    _mediumFont = null;
    _boldFont = null;
    _italicFont = null;
    _isInitialized = false;
  }
}
