import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/certifications/presentation/pages/add_certification_page.dart';
import 'package:vitafolio/features/certifications/presentation/pages/certifications_page.dart';
import 'package:vitafolio/features/certifications/presentation/viewmodels/certifications_viewmodel.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('Certifications UI & Flow Widget Tests', () {
    testWidgets('CertificationsPage renders title and empty state or list',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(const CertificationsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Certifications'), findsWidgets);
      expect(find.byType(CertificationsPage), findsOneWidget);
    });

    testWidgets('AddCertificationPage renders form fields when adding new certification',
        (tester) async {
      await tester.pumpWidget(
          buildTestWidget(const AddCertificationPage(isEditing: false)));
      await tester.pumpAndSettle();

      expect(find.text('Add Certification'), findsWidgets);
      expect(find.text('Certification Name *'), findsOneWidget);
      expect(find.text('Issuing Organization *'), findsOneWidget);
      expect(find.text('Issue Date *'), findsOneWidget);
      expect(find.text('Expiry Date'), findsOneWidget);
      expect(find.text('This certification does not expire'), findsOneWidget);
      expect(find.text('Credential ID'), findsOneWidget);
      expect(find.byType(AddCertificationPage), findsOneWidget);
    });

    testWidgets(
        'AddCertificationPage required validation displays error messages when fields are empty',
        (tester) async {
      await tester.pumpWidget(
          buildTestWidget(const AddCertificationPage(isEditing: false)));
      await tester.pumpAndSettle();

      final saveButton = find.text('Save Certification');
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Certification name is required'), findsOneWidget);
      expect(find.text('Issuing organization is required'), findsOneWidget);
    });

    testWidgets(
        'AddCertificationPage populates fields correctly when in edit mode',
        (tester) async {
      const sampleItem = MockCertificationItem(
        id: 'cert-1',
        name: 'AWS Certified Solutions Architect',
        organization: 'Amazon Web Services',
        issueDate: 'Aug 2024',
        expiryDate: 'Aug 2027',
        credentialId: 'AWS-12345',
      );

      await tester.pumpWidget(
        buildTestWidget(
          const AddCertificationPage(
            isEditing: true,
            initialItem: sampleItem,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit Certification'), findsWidgets);
      expect(find.text('AWS Certified Solutions Architect'), findsOneWidget);
      expect(find.text('Amazon Web Services'), findsOneWidget);
      expect(find.text('Aug 2024'), findsOneWidget);
      expect(find.text('Aug 2027'), findsOneWidget);
      expect(find.text('AWS-12345'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });
  });
}
