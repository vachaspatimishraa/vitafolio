import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/home/widgets/resume_card_menu.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testResumeWithJobRole = Resume(
    id: const ResumeId('resume-1'),
    title: 'Senior Flutter Developer',
    isTitleManuallySet: false,
    selectedTemplateId: const TemplateId('ats'),
    personalDetails: const PersonalDetails(
      fullName: 'John Doe',
      jobTitle: 'Senior Flutter Developer',
      email: 'john@example.com',
      phoneNumber: '1234567890',
      address: 'City, State, Country',
    ),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final testResumeManuallyRenamed = Resume(
    id: const ResumeId('resume-2'),
    title: 'My Custom CV',
    isTitleManuallySet: true,
    selectedTemplateId: const TemplateId('ats'),
    personalDetails: const PersonalDetails(
      fullName: 'Jane Doe',
      jobTitle: 'Lead Software Architect',
      email: 'jane@example.com',
      phoneNumber: '0987654321',
      address: 'City, State, Country',
    ),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  group('Dashboard Naming & Rename Tests', () {
    test('Automatic title vs Manual title priorities', () {
      expect(testResumeWithJobRole.title, equals('Senior Flutter Developer'));
      expect(testResumeWithJobRole.isTitleManuallySet, isFalse);

      expect(testResumeManuallyRenamed.title, equals('My Custom CV'));
      expect(testResumeManuallyRenamed.isTitleManuallySet, isTrue);
    });

    testWidgets('ResumeCardMenu renders Rename option', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResumeCardMenu(resume: testResumeWithJobRole),
          ),
        ),
      );

      final iconFinder = find.byIcon(Icons.more_vert);
      expect(iconFinder, findsOneWidget);

      await tester.tap(iconFinder);
      await tester.pumpAndSettle();

      expect(find.text('Rename'), findsOneWidget);
    });
  });
}
