import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vitafolio/features/preview/view/preview_screen.dart';
import 'package:vitafolio/features/preview/widgets/preview_action_bar.dart';
import 'package:vitafolio/features/preview/widgets/preview_app_bar.dart';
import 'package:vitafolio/features/preview/widgets/resume_canvas.dart';
import 'package:vitafolio/features/preview/widgets/template_selector.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class _FakeResumeRepository implements ResumeRepository {
  final Resume resume;
  _FakeResumeRepository(this.resume);

  @override
  Future<Resume> createResume(Resume resume) async => resume;

  @override
  Future<void> deleteResume(ResumeId id) async {}

  @override
  Future<Resume> duplicateResume(ResumeId id, [String? nameSuffix]) async => resume;

  @override
  Future<List<Resume>> getAllResumes() async => [resume];

  @override
  Future<Resume?> getResume(ResumeId id) async => resume;

  @override
  Future<Resume> importResume(String filePath) async => resume;

  @override
  Future<Resume> parseResume(String rawText) async => resume;

  @override
  Future<Resume> saveSelectedTemplate(ResumeId resumeId, TemplateId templateId) async => resume;

  @override
  Future<Resume> updateResume(Resume resume) async => resume;

  @override
  Future<List<int>> generateResume(ResumeId resumeId) async => [1, 2, 3];
}

void main() {
  final sampleResume = Resume(
    id: const ResumeId('1'),
    title: 'Test Active Resume',
    selectedTemplateId: const TemplateId('ats_professional'),
    personalDetails: const PersonalDetails(
      fullName: 'Jane Developer',
      email: 'jane@example.com',
      phoneNumber: '+1 555 0199',
      address: 'San Francisco, CA',
      jobTitle: 'Senior Flutter Developer',
    ),
    summary: const ProfessionalSummary(
      summaryText: 'Expert mobile developer building high quality apps.',
    ),
    skills: const [
      Skill(id: 's1', name: 'Flutter'),
      Skill(id: 's2', name: 'Dart'),
    ],
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  testWidgets('Preview UI Regression Test: "Action Required" section must NOT exist on PreviewScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cleanResumeRepositoryProvider.overrideWithValue(_FakeResumeRepository(sampleResume)),
          activeResumeIdProvider.overrideWith((ref) => const ResumeId('1')),
        ],
        child: const MaterialApp(
          home: PreviewScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    // 1. Verify Preview App Bar, Resume Canvas, Action Bar exist (TemplateSelector removed per Task 070)
    expect(find.byType(PreviewAppBar), findsOneWidget);
    expect(find.byType(TemplateSelector), findsNothing);
    expect(find.byType(ResumeCanvas), findsOneWidget);
    expect(find.byType(PreviewActionBar), findsOneWidget);

    // 2. CRITICAL REGRESSION ASSERTION: "Action Required" must NOT exist on Preview Screen
    expect(find.text('Action Required'), findsNothing);
    expect(find.textContaining('Action Required', findRichText: true), findsNothing);
  });
}
