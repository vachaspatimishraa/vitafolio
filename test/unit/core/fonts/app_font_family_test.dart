import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/fonts/app_font_family.dart';

void main() {
  group('AppFonts Registry Tests', () {
    test('Defines exactly 16 supported fonts', () {
      expect(AppFonts.allFonts.length, equals(16));
    });

    test('All 16 fonts have unique IDs and display names', () {
      final ids = AppFonts.allFonts.map((f) => f.id).toSet();
      final names = AppFonts.allFonts.map((f) => f.displayName).toSet();

      expect(ids.length, equals(16));
      expect(names.length, equals(16));
    });

    test('getById normalizes and resolves correctly', () {
      expect(AppFonts.getById('poppins').displayName, equals('Poppins'));
      expect(AppFonts.getById('Poppins').id, equals('poppins'));
      expect(AppFonts.getById('open_sans').displayName, equals('Open Sans'));
      expect(AppFonts.getById('Open Sans').id, equals('open_sans'));
      expect(AppFonts.getById('unknown_font').id, equals(AppFonts.defaultFontId));
      expect(AppFonts.getById(null).id, equals(AppFonts.defaultFontId));
    });
  });
}
