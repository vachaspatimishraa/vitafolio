import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/preview/view/preview_screen.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/review_resume/presentation/pages/review_resume_page.dart';
import 'package:vitafolio/features/review_resume/presentation/viewmodels/review_resume_viewmodel.dart';

void main() {
  Widget buildTestableWidget(ReviewResumeState state) {
    return ProviderScope(
      overrides: [
        reviewResumeViewModelProvider.overrideWith(
          (ref) => _FakeReviewResumeNotifier(state),
        ),
      ],
      child: const MaterialApp(
        home: ReviewResumePage(),
      ),
    );
  }

  group('ReviewResumePage Widget Tests', () {
    testWidgets('renders loading state when isLoading is true', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const ReviewResumeState(isLoading: true)),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading resume details...'), findsOneWidget);
    });

    testWidgets('renders error state with retry button when errorMessage exists',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ReviewResumeState(
            errorMessage: 'Failed to load resume for review',
          ),
        ),
      );

      expect(find.text('Failed to load resume for review'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
    });

    testWidgets('renders empty state when resume is null', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const ReviewResumeState(resume: null)),
      );

      expect(find.text('No Active Resume Selected'), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, 'Create / Select Resume'),
        findsOneWidget,
      );
    });

    testWidgets('renders loaded state with preview and sections when resume is present',
        (tester) async {
      final sampleResume = Resume(
        id: const ResumeId('test-1'),
        title: 'Jane Portfolio',
        selectedTemplateId: const TemplateId('ats_friendly'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        buildTestableWidget(
          ReviewResumeState(
            resume: sampleResume,
            templateName: 'Modern Clean',
            completedSections: 5,
            totalSections: 10,
            completionPercentage: 0.5,
          ),
        ),
      );

      expect(find.text('Review Your Resume'), findsOneWidget);
      expect(find.text('Modern Clean'), findsOneWidget);
      expect(find.text('Resume Sections'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);
      expect(find.text('Generate Resume'), findsOneWidget);
    });

    testWidgets('tapping Generate Resume button navigates to preview screen', (tester) async {
      final sampleResume = Resume(
        id: const ResumeId('test-1'),
        title: 'Jane Portfolio',
        selectedTemplateId: const TemplateId('ats_friendly'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            reviewResumeViewModelProvider.overrideWith(
              (ref) => _FakeReviewResumeNotifier(
                ReviewResumeState(
                  resume: sampleResume,
                  templateName: 'Modern Clean',
                  completedSections: 5,
                  totalSections: 10,
                  completionPercentage: 0.5,
                ),
              ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      AppRouter.router.go(AppRoutes.review);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Generate Resume'), findsOneWidget);
      await tester.tap(find.text('Generate Resume'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(PreviewScreen), findsOneWidget);
    });
  });
}

class _FakeReviewResumeNotifier extends StateNotifier<ReviewResumeState>
    implements ReviewResumeViewModel {
  _FakeReviewResumeNotifier(super.initialState);

  @override
  Future<void> loadResume() async {}

  @override
  void selectSection(String sectionTitle) {}

  @override
  void setGenerating(bool generating) {}

  @override
  Future<List<int>?> generateResume() async {
    return [1, 2, 3];
  }
}
