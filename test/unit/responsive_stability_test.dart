import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/pdf/services/pdf_service.dart';
import 'package:vitafolio/core/templates/repository/template_repository.dart';
import 'package:vitafolio/data/models/embedded/personal_information.dart';
import 'package:vitafolio/features/education/presentation/widgets/year_picker_field.dart';
import 'package:vitafolio/features/preview/widgets/preview_action_bar.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';

void main() {
  group('Responsive Stability Tests', () {
    const viewports = [
      Size(320, 640),   // Narrow phone portrait
      Size(640, 360),   // Phone landscape
      Size(375, 812),   // Standard phone portrait
      Size(768, 1024),  // Tablet portrait
      Size(1024, 768),  // Tablet landscape
      Size(1280, 800),  // Desktop / large tablet
    ];

    for (final size in viewports) {
      testWidgets('YearPickerField renders without overflow at ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: size.width * 0.9,
                  child: YearPickerField(
                    label: 'Start Year',
                    value: '2022',
                    errorText: 'Start year is required',
                    onYearSelected: (_) {},
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(YearPickerField), findsOneWidget);
        expect(find.text('Start Year'), findsOneWidget);
        expect(find.text('2022'), findsOneWidget);
        expect(find.text('Start year is required'), findsOneWidget);
      });

      testWidgets('PreviewActionBar renders without overflow at ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              bottomNavigationBar: PreviewActionBar(),
            ),
          ),
        );

        expect(find.byType(PreviewActionBar), findsOneWidget);
        expect(find.text('Back to Edit'), findsOneWidget);
      });
    }

    test('All 10 templates render PDF cleanly without profile photo (null photo)', () async {
      final repo = TemplateRepository();
      final templates = repo.getTemplates();
      expect(templates.length, 10);

      // Verify template repository marks requiresProfileImage as false for all
      for (final t in templates) {
        expect(t.requiresProfileImage, false, reason: '${t.id} must not require photo');
      }

      final emptyPhotoState = WorkflowState(
        resumeId: 99,
        resumeName: 'Stability Test',
        personalInfo: PersonalInformation(
          fullName: 'Test Candidate',
          jobTitle: 'Engineer',
          email: 'test@candidate.com',
          phone: '+1 555-0199',
          profileImagePath: null, // NULL PHOTO!
        ),
        summary: 'Experienced developer specializing in mobile platforms.',
        education: [],
        experience: [],
        skills: ['Dart', 'Flutter'],
        projects: [],
        certifications: [],
        languages: [],
      );

      final pdfService = PdfService();
      for (final t in templates) {
        final renderer = pdfService.resolveRenderer(t.id);
        final doc = renderer.buildPdf(emptyPhotoState);
        expect(doc, isNotNull);
        final bytes = await doc.save();
        expect(bytes, isNotEmpty, reason: 'PDF build for ${t.id} must produce non-null bytes');
      }
    });
  });
}
