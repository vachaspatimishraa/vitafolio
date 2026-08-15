import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/education/presentation/pages/add_education_page.dart';
import 'package:vitafolio/features/education/presentation/pages/education_list_page.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('Education UI Flow Widget Tests', () {
    testWidgets('EducationListPage renders title and empty state or cards', (tester) async {
      await tester.pumpWidget(buildTestWidget(const EducationListPage()));
      await tester.pumpAndSettle();

      expect(find.text('Education'), findsWidgets);
      expect(find.byType(EducationListPage), findsOneWidget);
    });

    testWidgets('AddEducationPage renders form fields when adding new education', (tester) async {
      await tester.pumpWidget(buildTestWidget(const AddEducationPage(isEditing: false)));
      await tester.pumpAndSettle();

      expect(find.text('Add Education'), findsOneWidget);
      expect(find.text('Add Qualification'), findsOneWidget);
      expect(find.text('Degree *'), findsOneWidget);
      expect(find.text('Field of Study *'), findsOneWidget);
      expect(find.text('Institution Name *'), findsOneWidget);
      expect(find.byType(AddEducationPage), findsOneWidget);
    });

    testWidgets('AddEducationPage required field validation displays error snackbar when empty', (tester) async {
      await tester.pumpWidget(buildTestWidget(const AddEducationPage(isEditing: false)));
      await tester.pumpAndSettle();

      final saveButton = find.text('Save');
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Please complete required fields (Degree, Field of Study, Institution)'), findsOneWidget);
    });
  });
}
