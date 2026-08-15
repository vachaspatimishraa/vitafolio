import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/languages/presentation/pages/add_language_page.dart';
import 'package:vitafolio/features/languages/presentation/pages/languages_page.dart';
import 'package:vitafolio/features/languages/presentation/viewmodels/languages_viewmodel.dart';
import 'package:vitafolio/features/languages/presentation/widgets/hybrid_language_dropdown.dart';
import 'package:vitafolio/features/languages/presentation/widgets/language_level_dropdown.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('Languages UI & Flow Widget Tests', () {
    testWidgets('LanguagesPage renders title and empty state or list',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(const LanguagesPage()));
      await tester.pumpAndSettle();

      expect(find.text('Languages'), findsWidgets);
      expect(find.byType(LanguagesPage), findsOneWidget);
    });

    testWidgets('AddLanguagePage renders selectors, live preview, and buttons',
        (tester) async {
      await tester.pumpWidget(
          buildTestWidget(const AddLanguagePage(isEditing: false)));
      await tester.pumpAndSettle();

      expect(find.text('Add Language'), findsWidgets);
      expect(find.text('Language Details'), findsOneWidget);
      expect(find.byType(HybridLanguageDropdown), findsOneWidget);
      expect(find.byType(LanguageLevelDropdown), findsOneWidget);
      expect(find.text('Language Preview'), findsOneWidget);
      expect(find.text('Save Language'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('AddLanguagePage required validation displays error messages',
        (tester) async {
      await tester.pumpWidget(
          buildTestWidget(const AddLanguagePage(isEditing: false)));
      await tester.pumpAndSettle();

      final saveButton = find.text('Save Language');
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Language is required'), findsOneWidget);
      expect(find.text('Proficiency level is required'), findsOneWidget);
    });

    testWidgets(
        'AddLanguagePage populates fields correctly when in edit mode',
        (tester) async {
      const sampleItem = MockLanguageItem(
        id: 'lang-1',
        language: 'German',
        level: 'Advanced',
      );

      await tester.pumpWidget(
        buildTestWidget(
          const AddLanguagePage(
            isEditing: true,
            initialLanguage: sampleItem,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit Language'), findsWidgets);
      expect(find.text('German'), findsWidgets);
      expect(find.text('Advanced'), findsWidgets);
      expect(find.text('Update Language'), findsOneWidget);
    });
  });
}
