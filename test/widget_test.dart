import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/home/view/home_screen.dart';
import 'package:vitafolio/data/repositories/resume_repository.dart';
import 'package:vitafolio/data/models/resume/resume_model.dart';
import 'package:vitafolio/data/repositories/repository_provider.dart';

class FakeResumeRepository extends Fake implements ResumeRepository {
  @override
  Future<List<ResumeModel>> getAllResumes() async {
    return [
      ResumeModel(
        id: '1',
        title: 'Software Engineer Resume',
        lastUpdated: DateTime.now().toIso8601String(),
        status: ResumeStatus.completed,
      ),
    ];
  }

  @override
  Future<List<ResumeModel>> searchResumes(String query) async {
    return getAllResumes();
  }

  @override
  Future<Map<String, int>> getResumeStatistics() async {
    return {
      'total': 1,
      'draft': 0,
      'completed': 1,
    };
  }
}

void main() {
  testWidgets('HomeScreen smoke test', (WidgetTester tester) async {
    // Build HomeScreen with overridden repository provider.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          resumeRepositoryProvider.overrideWithValue(FakeResumeRepository()),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that Greeting Section is shown.
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && (widget.data?.startsWith('Good ') ?? false),
      ),
      findsOneWidget,
    );
    // Verify search bar hints or empty state text.
    expect(find.text('Software Engineer Resume'), findsOneWidget);
  });
}
