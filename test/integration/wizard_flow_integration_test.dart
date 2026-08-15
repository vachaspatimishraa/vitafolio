import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/personal_details/presentation/widgets/hybrid_search_dropdown.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';

import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/usecases/create_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/delete_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_all_resumes.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class InMemoryResumeRepository implements ResumeRepository {
  final Map<String, Resume> _storage = {};

  @override
  Future<Resume> createResume(Resume resume) async {
    final id = resume.id.value.isEmpty
        ? 'test-resume-${DateTime.now().millisecondsSinceEpoch}'
        : resume.id.value;
    final created = resume.copyWith(id: ResumeId(id));
    _storage[id] = created;
    return created;
  }

  @override
  Future<Resume> updateResume(Resume resume) async {
    _storage[resume.id.value] = resume;
    return resume;
  }

  @override
  Future<void> deleteResume(ResumeId id) async {
    _storage.remove(id.value);
  }

  @override
  Future<Resume?> getResume(ResumeId id) async {
    return _storage[id.value];
  }

  @override
  Future<List<Resume>> getAllResumes() async {
    return _storage.values.toList();
  }

  @override
  Future<Resume> importResume(String filePath) async {
    throw UnimplementedError();
  }

  @override
  Future<Resume> parseResume(String rawText) async {
    throw UnimplementedError();
  }

  @override
  Future<Resume> saveSelectedTemplate(
    ResumeId resumeId,
    TemplateId templateId,
  ) async {
    final existing = _storage[resumeId.value];
    if (existing != null) {
      final updated = existing.copyWith(selectedTemplateId: templateId);
      _storage[resumeId.value] = updated;
      return updated;
    }
    throw UnimplementedError();
  }

  @override
  Future<List<int>> generateResume(ResumeId resumeId) async {
    return [1, 2, 3, 4];
  }

  @override
  Future<Resume> duplicateResume(ResumeId id, [String? nameSuffix]) async {
    final existing = _storage[id.value];
    if (existing == null) throw Exception('Resume not found');
    final suffix = nameSuffix ?? ' (Copy)';
    final newId = 'dup-${DateTime.now().millisecondsSinceEpoch}';
    final duplicated = existing.copyWith(
      id: ResumeId(newId),
      title: '${existing.title}$suffix',
    );
    _storage[newId] = duplicated;
    return duplicated;
  }
}

void main() {
  late InMemoryResumeRepository fakeRepo;

  setUp(() {
    fakeRepo = InMemoryResumeRepository();
  });

  Widget buildAppWidget({ResumeId? initialActiveId}) {
    return ProviderScope(
      overrides: [
        cleanResumeRepositoryProvider.overrideWithValue(fakeRepo),
        getResumeUseCaseProvider.overrideWithValue(GetResume(fakeRepo)),
        updateResumeUseCaseProvider.overrideWithValue(UpdateResume(fakeRepo)),
        createResumeUseCaseProvider.overrideWithValue(CreateResume(fakeRepo)),
        deleteResumeUseCaseProvider.overrideWithValue(DeleteResume(fakeRepo)),
        getAllResumesUseCaseProvider.overrideWithValue(GetAllResumes(fakeRepo)),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          if (initialActiveId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(activeResumeIdProvider.notifier).state = initialActiveId;
            });
          }
          return MaterialApp.router(routerConfig: AppRouter.router);
        },
      ),
    );
  }

  group('Full Wizard Navigation Flow Integration Tests', () {
    testWidgets('Step 1 to Step 10 Navigation Test', (tester) async {
      final initialResume = Resume(
        id: const ResumeId('test-active-1'),
        title: 'My Testing Resume',
        selectedTemplateId: const TemplateId('ats_pro'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await fakeRepo.createResume(initialResume);

      await tester.pumpWidget(
        buildAppWidget(initialActiveId: const ResumeId('test-active-1')),
      );
      await tester.pumpAndSettle();

      // Navigate directly to /templates
      AppRouter.router.go(AppRoutes.templates);
      await tester.pumpAndSettle();

      // 1. Step 1: Template Selection (Controlled Empty State during reset)
      expect(find.text('Choose Your Resume Template'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // 2. Step 2: Personal Details
      expect(find.text('Tell us about yourself'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name *'),
        'Alex Mercer',
      );
      await tester.enterText(
        find.widgetWithText(HybridSearchDropdown, 'Job Role'),
        'Senior Architect',
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'),
        'alex.mercer@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number *'),
        '9876543210',
      );

      await tester.tap(find.text('Save & Continue'));
      await tester.pumpAndSettle();

      // 3. Step 3: Profile Image
      expect(find.text('Profile Image'), findsWidgets);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // 4. Step 4: Professional Summary
      expect(find.text('Introduce Yourself'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // 4. Step 4: Experience
      expect(find.text('No Experience Added'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // 5. Step 5: Projects
      expect(find.text('No Projects Added Yet'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // 6. Step 6: Education
      expect(find.text('No Education Added'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // 7. Step 7: Skills
      expect(find.text('Professional Skills'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // 8. Step 8: Certifications
      expect(find.text('No Certifications Added'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // 9. Step 9: Languages
      expect(find.text('No Languages Added'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // 10. Step 10: Review & Generate
      expect(find.text('Review Your Resume'), findsOneWidget);
    });
  });
}
