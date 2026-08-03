import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vitafolio/core/pdf/fonts/font_manager.dart';

/// Centralized PDF Theme definition to ensure consistent typography and styling.
class PdfTheme {
  /// The active font family for this theme.
  final PdfFontFamily fontFamily;

  // Colors
  final PdfColor primary;
  final PdfColor secondary;
  final PdfColor accent;
  final PdfColor background;
  final PdfColor text;
  final PdfColor textMuted;
  final PdfColor divider;

  // Typography Styles
  final pw.TextStyle h1;
  final pw.TextStyle h2;
  final pw.TextStyle h3;
  final pw.TextStyle body;
  final pw.TextStyle bodyMedium;
  final pw.TextStyle bodyBold;
  final pw.TextStyle caption;

  // Layout & Spacing
  final double sectionSpacing;
  final double itemSpacing;
  final double defaultPadding;
  final double dividerHeight;

  PdfTheme({
    required this.fontFamily,
    PdfColor? primary,
    PdfColor? secondary,
    PdfColor? accent,
    PdfColor? background,
    PdfColor? text,
    PdfColor? textMuted,
    PdfColor? divider,
    this.sectionSpacing = 16.0,
    this.itemSpacing = 8.0,
    this.defaultPadding = 12.0,
    this.dividerHeight = 0.5,
  }) : primary = primary ?? PdfColor.fromInt(0xFF0F172A), // Slate 900
       secondary = secondary ?? PdfColor.fromInt(0xFF475569), // Slate 600
       accent = accent ?? PdfColor.fromInt(0xFF3B82F6), // Blue 500
       background = background ?? PdfColor.fromInt(0xFFFFFFFF),
       text = text ?? PdfColor.fromInt(0xFF0F172A),
       textMuted = textMuted ?? PdfColor.fromInt(0xFF64748B), // Slate 500
       divider = divider ?? PdfColor.fromInt(0xFFE2E8F0), // Slate 200
       h1 = pw.TextStyle(
         font: fontFamily.bold,
         fontSize: 20.0,
         color: primary ?? PdfColor.fromInt(0xFF0F172A),
       ),
       h2 = pw.TextStyle(
         font: fontFamily.bold,
         fontSize: 14.0,
         color: primary ?? PdfColor.fromInt(0xFF0F172A),
       ),
       h3 = pw.TextStyle(
         font: fontFamily.semiBold,
         fontSize: 11.0,
         color: secondary ?? PdfColor.fromInt(0xFF475569),
       ),
       body = pw.TextStyle(
         font: fontFamily.regular,
         fontSize: 9.5,
         color: text ?? PdfColor.fromInt(0xFF0F172A),
         lineSpacing: 1.3,
       ),
       bodyMedium = pw.TextStyle(
         font: fontFamily.medium,
         fontSize: 9.5,
         color: text ?? PdfColor.fromInt(0xFF0F172A),
         lineSpacing: 1.3,
       ),
       bodyBold = pw.TextStyle(
         font: fontFamily.bold,
         fontSize: 9.5,
         color: text ?? PdfColor.fromInt(0xFF0F172A),
         lineSpacing: 1.3,
       ),
       caption = pw.TextStyle(
         font: fontFamily.regular,
         fontSize: 8.0,
         color: textMuted ?? PdfColor.fromInt(0xFF64748B),
       );

  /// Factory constructor to create a modern theme variant.
  factory PdfTheme.modern(PdfFontFamily fontFamily) {
    return PdfTheme(
      fontFamily: fontFamily,
      primary: PdfColor.fromInt(0xFF0F172A),
      secondary: PdfColor.fromInt(0xFF475569),
      accent: PdfColor.fromInt(0xFF3B82F6),
      divider: PdfColor.fromInt(0xFFE2E8F0),
    );
  }

  /// Factory constructor to create a classic professional theme variant (e.g. navy/charcoal).
  factory PdfTheme.classic(PdfFontFamily fontFamily) {
    return PdfTheme(
      fontFamily: fontFamily,
      primary: PdfColor.fromInt(0xFF1E3A8A), // Navy 900
      secondary: PdfColor.fromInt(0xFF1F2937), // Cool Gray 800
      accent: PdfColor.fromInt(0xFF0D9488), // Teal 600
      divider: PdfColor.fromInt(0xFFD1D5DB),
    );
  }
}
