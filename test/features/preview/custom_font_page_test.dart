import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/preview/view/custom_font_page.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class FakeResumeRepository implements ResumeRepository {
  Resume? activeResume;

  FakeResumeRepository(this.activeResume);

  @override
  Future<Resume> createResume(Resume resume) async => resume;
  @override
  Future<Resume> updateResume(Resume resume) async => resume;
  @override
  Future<void> deleteResume(ResumeId id) async {}
  @override
  Future<Resume?> getResume(ResumeId id) async => activeResume;
  @override
  Future<List<Resume>> getAllResumes() async => activeResume != null ? [activeResume!] : [];
  @override
  Future<Resume> importResume(String filePath) async => activeResume!;
  @override
  Future<Resume> parseResume(String rawText) async => activeResume!;
  @override
  Future<Resume> saveSelectedTemplate(ResumeId resumeId, TemplateId templateId) async {
    activeResume = activeResume?.copyWith(selectedTemplateId: templateId);
    return activeResume!;
  }
  @override
  Future<Resume> saveSelectedFont(ResumeId resumeId, String fontFamily) async {
    activeResume = activeResume?.copyWith(fontFamily: fontFamily);
    return activeResume!;
  }
  @override
  Future<List<int>> generateResume(ResumeId resumeId) async => [37, 80, 68, 70, 45];
  @override
  Future<Resume> duplicateResume(ResumeId id, [String? nameSuffix]) async => activeResume!;
}

void main() {
  late ProviderContainer container;
  late FakeResumeRepository fakeRepo;

  final initialResume = Resume(
    id: const ResumeId('test_res_1'),
    title: 'Flutter Developer',
    selectedTemplateId: const TemplateId('modern'),
    fontFamily: 'roboto',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUp(() {
    fakeRepo = FakeResumeRepository(initialResume);
    container = ProviderContainer(
      overrides: [
        cleanResumeRepositoryProvider.overrideWithValue(fakeRepo),
        activeResumeIdProvider.overrideWith((ref) => const ResumeId('test_res_1')),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('CustomFontPage & PreviewScreen Font Integration Tests', () {
    testWidgets('CustomFontPage renders headline, subtitle, and font cards', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CustomFontPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Custom Font'), findsOneWidget);
      expect(find.text('Choose your resume font'), findsOneWidget);
      expect(find.text('Apply & Preview'), findsOneWidget);

      // Verify font cards are rendered
      expect(find.text('Poppins'), findsOneWidget);
      expect(find.text('Montserrat'), findsOneWidget);
      expect(find.text('Roboto'), findsOneWidget);
      expect(find.text('Open Sans'), findsOneWidget);
    });

    testWidgets('Selecting a font and tapping Apply & Preview saves font to resume', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to /custom-font
      AppRouter.router.go(AppRoutes.customFont);
      await tester.pumpAndSettle();

      // Tap on 'Montserrat'
      await tester.tap(find.text('Montserrat'));
      await tester.pumpAndSettle();

      // Tap 'Apply & Preview'
      await tester.tap(find.text('Apply & Preview'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify repository updated font to montserrat
      expect(fakeRepo.activeResume?.fontFamily, equals('montserrat'));
    });

    testWidgets('PreviewAppBar renders typography [A] button and tapping it opens CustomFontPage', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      AppRouter.router.go(AppRoutes.preview);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byTooltip('Custom Font'), findsOneWidget);
      await tester.tap(find.byTooltip('Custom Font'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(CustomFontPage), findsOneWidget);
      expect(find.text('Choose your resume font'), findsOneWidget);
    });
  });
}
