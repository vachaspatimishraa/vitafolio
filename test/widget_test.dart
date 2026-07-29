import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/app/app.dart';
import 'package:vitafolio/data/models/resume_model.dart';
import 'package:vitafolio/data/models/enums/resume_status.dart';
import 'package:vitafolio/data/repositories/resume_repository.dart';
import 'package:vitafolio/data/repositories/repository_provider.dart';

class FakeResumeRepository implements ResumeRepository {
  @override
  Future<ResumeModel> createResume(ResumeModel resume) async => resume;
  @override
  Future<ResumeModel?> getResume(int id) async => null;
  @override
  Future<List<ResumeModel>> getAllResumes() async => [];
  @override
  Future<void> updateResume(ResumeModel resume) async {}
  @override
  Future<void> deleteResume(int id) async {}
  @override
  Future<ResumeModel> duplicateResume(int id, String defaultSuffix) async =>
      ResumeModel();
  @override
  Future<void> renameResume(int id, String newName) async {}
  @override
  Future<List<ResumeModel>> searchResumes(String query) async => [];
  @override
  Future<List<ResumeModel>> filterResumes(ResumeStatus status) async => [];
  @override
  Future<List<ResumeModel>> sortResumes(
    List<ResumeModel> resumes,
    String sortBy,
  ) async => resumes;
  @override
  Future<Map<String, int>> getResumeStatistics() async => {};
  @override
  Future<bool> checkResumeExists(int id) async => false;
  @override
  Future<void> updateSelectedTemplate(int id, String templateId) async {}
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          resumeRepositoryProvider.overrideWithValue(FakeResumeRepository()),
        ],
        child: const App(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
