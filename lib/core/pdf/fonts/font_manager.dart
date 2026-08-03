import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

/// Represents a loaded font family with multiple weights.
class PdfFontFamily {
  final String name;
  final pw.Font regular;
  final pw.Font medium;
  final pw.Font semiBold;
  final pw.Font bold;

  const PdfFontFamily({
    required this.name,
    required this.regular,
    required this.medium,
    required this.semiBold,
    required this.bold,
  });

  /// Factory constructor to create a font family using built-in Helvetica fallback.
  factory PdfFontFamily.fallback(String name) {
    return PdfFontFamily(
      name: name,
      regular: pw.Font.helvetica(),
      medium:
          pw.Font.helveticaBold(), // Helvetica has no medium; fallback to bold
      semiBold: pw.Font.helveticaBold(),
      bold: pw.Font.helveticaBold(),
    );
  }
}

/// Font Manager responsible for loading, caching, and providing offline fonts.
class FontManager {
  static final FontManager instance = FontManager._();
  FontManager._();

  final Map<String, PdfFontFamily> _cachedFonts = {};

  /// Preloads specific fonts into cache for performance.
  Future<void> preloadFonts(List<String> families) async {
    for (final family in families) {
      await getFontFamily(family);
    }
  }

  /// Retrieves a loaded font family from cache or loads it from assets.
  ///
  /// Falls back to built-in Helvetica fonts if loading fails to prevent crashes.
  Future<PdfFontFamily> getFontFamily(String familyName) async {
    final normalized = familyName.toLowerCase().replaceAll(' ', '_').trim();
    if (_cachedFonts.containsKey(normalized)) {
      return _cachedFonts[normalized]!;
    }

    try {
      final PdfFontFamily family;
      switch (normalized) {
        case 'inter':
          family = PdfFontFamily(
            name: 'Inter',
            regular: pw.Font.ttf(
              await rootBundle.load('assets/fonts/inter/Inter-Regular.ttf'),
            ),
            medium: pw.Font.ttf(
              await rootBundle.load('assets/fonts/inter/Inter-Medium.ttf'),
            ),
            semiBold: pw.Font.ttf(
              await rootBundle.load('assets/fonts/inter/Inter-SemiBold.ttf'),
            ),
            bold: pw.Font.ttf(
              await rootBundle.load('assets/fonts/inter/Inter-Bold.ttf'),
            ),
          );
          break;
        case 'open_sans':
          family = PdfFontFamily(
            name: 'Open Sans',
            regular: pw.Font.ttf(
              await rootBundle.load(
                'assets/fonts/open_sans/OpenSans-Regular.ttf',
              ),
            ),
            medium: pw.Font.ttf(
              await rootBundle.load(
                'assets/fonts/open_sans/OpenSans-Medium.ttf',
              ),
            ),
            semiBold: pw.Font.ttf(
              await rootBundle.load(
                'assets/fonts/open_sans/OpenSans-SemiBold.ttf',
              ),
            ),
            bold: pw.Font.ttf(
              await rootBundle.load('assets/fonts/open_sans/OpenSans-Bold.ttf'),
            ),
          );
          break;
        case 'roboto':
          family = PdfFontFamily(
            name: 'Roboto',
            regular: pw.Font.ttf(
              await rootBundle.load('assets/fonts/roboto/Roboto-Regular.ttf'),
            ),
            medium: pw.Font.ttf(
              await rootBundle.load('assets/fonts/roboto/Roboto-Medium.ttf'),
            ),
            semiBold: pw.Font.ttf(
              await rootBundle.load('assets/fonts/roboto/Roboto-SemiBold.ttf'),
            ),
            bold: pw.Font.ttf(
              await rootBundle.load('assets/fonts/roboto/Roboto-Bold.ttf'),
            ),
          );
          break;
        default:
          throw Exception('Unsupported font family: $familyName');
      }
      _cachedFonts[normalized] = family;
      return family;
    } catch (e) {
      // Return Helvetica fallback to ensure app does not crash
      final fallback = PdfFontFamily.fallback(familyName);
      _cachedFonts[normalized] = fallback;
      return fallback;
    }
  }

  /// Clears the font cache.
  void clearCache() {
    _cachedFonts.clear();
  }
}
