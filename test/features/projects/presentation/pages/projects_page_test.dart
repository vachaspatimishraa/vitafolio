import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/projects/presentation/pages/projects_page.dart';
import 'package:vitafolio/features/projects/presentation/viewmodels/projects_viewmodel.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';

void main() {
  Widget buildTestableWidget(ProjectsListState state) {
    return ProviderScope(
      overrides: [
        projectsViewModelProvider.overrideWith(
          (ref) => _FakeProjectsNotifier(state),
        ),
      ],
      child: const MaterialApp(
        home: ProjectsPage(),
      ),
    );
  }

  group('ProjectsPage Widget Tests', () {
    testWidgets('renders empty state and bottom bar when no projects exist',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget(const ProjectsListState()));

      expect(find.text('Projects'), findsOneWidget); // AppBar title
      expect(find.text('No Projects Added Yet'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // Verify NO floating action button exists
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets(
        'renders project card, in-section Add Project button, and bottom bar matching Education pattern',
        (tester) async {
      final sampleProject = Project(
        id: 'p1',
        name: 'Vitafolio App',
        role: 'Lead Architect',
        description: 'Resume builder application',
        technologies: const ['Flutter', 'Riverpod'],
      );

      await tester.pumpWidget(
        buildTestableWidget(
          ProjectsListState(projects: [sampleProject]),
        ),
      );

      // Project details rendered
      expect(find.text('Vitafolio App'), findsOneWidget);
      expect(find.text('Lead Architect'), findsOneWidget);
      expect(find.text('Resume builder application'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);

      // In-section Add Project button exists in body (matching Education UI pattern)
      expect(find.text('Add Project'), findsOneWidget);

      // Verify NO FAB exists
      expect(find.byType(FloatingActionButton), findsNothing);

      // Bottom bar actions present (Previous | Continue)
      expect(find.text('Previous'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
  });
}

class _FakeProjectsNotifier extends StateNotifier<ProjectsListState>
    implements ProjectsViewModel {
  _FakeProjectsNotifier(super.initialState);

  @override
  Future<void> loadProjects() async {}

  @override
  Future<void> save() async {}

  @override
  Future<void> addProject(Project project) async {}

  @override
  Future<void> updateProject(Project project) async {}

  @override
  Future<void> deleteProject(String id) async {}
}
