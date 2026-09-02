/// Represents the 16 supported fonts for resume styling, preview, PDF, and Word export.
class AppFontItem {
  final String id;
  final String displayName;
  final String category; // 'Sans-Serif', 'Serif', 'Display'
  final String fallbackFamily;

  const AppFontItem({
    required this.id,
    required this.displayName,
    required this.category,
    required this.fallbackFamily,
  });
}

class AppFonts {
  const AppFonts._();

  static const String defaultFontId = 'roboto';

  static const List<AppFontItem> allFonts = [
    AppFontItem(
      id: 'poppins',
      displayName: 'Poppins',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
    AppFontItem(
      id: 'montserrat',
      displayName: 'Montserrat',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
    AppFontItem(
      id: 'roboto',
      displayName: 'Roboto',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
    AppFontItem(
      id: 'open_sans',
      displayName: 'Open Sans',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
    AppFontItem(
      id: 'lato',
      displayName: 'Lato',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
    AppFontItem(
      id: 'inter',
      displayName: 'Inter',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
    AppFontItem(
      id: 'nunito',
      displayName: 'Nunito',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
    AppFontItem(
      id: 'raleway',
      displayName: 'Raleway',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
    AppFontItem(
      id: 'lora',
      displayName: 'Lora',
      category: 'Serif',
      fallbackFamily: 'serif',
    ),
    AppFontItem(
      id: 'merriweather',
      displayName: 'Merriweather',
      category: 'Serif',
      fallbackFamily: 'serif',
    ),
    AppFontItem(
      id: 'playfair_display',
      displayName: 'Playfair Display',
      category: 'Serif',
      fallbackFamily: 'serif',
    ),
    AppFontItem(
      id: 'pt_serif',
      displayName: 'PT Serif',
      category: 'Serif',
      fallbackFamily: 'serif',
    ),
    AppFontItem(
      id: 'source_sans_pro',
      displayName: 'Source Sans Pro',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
    AppFontItem(
      id: 'ubuntu',
      displayName: 'Ubuntu',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
    AppFontItem(
      id: 'cinzel',
      displayName: 'Cinzel',
      category: 'Display',
      fallbackFamily: 'serif',
    ),
    AppFontItem(
      id: 'oswald',
      displayName: 'Oswald',
      category: 'Sans-Serif',
      fallbackFamily: 'sans-serif',
    ),
  ];

  static AppFontItem getById(String? id) {
    if (id == null || id.trim().isEmpty) {
      return allFonts.firstWhere((f) => f.id == defaultFontId);
    }
    final normalized = id.toLowerCase().replaceAll(' ', '_').trim();
    return allFonts.firstWhere(
      (f) => f.id == normalized || f.displayName.toLowerCase() == id.toLowerCase(),
      orElse: () => allFonts.firstWhere((f) => f.id == defaultFontId),
    );
  }

  static String normalizeFontId(String? raw) {
    return getById(raw).id;
  }

  static String getDisplayName(String? raw) {
    return getById(raw).displayName;
  }
}
