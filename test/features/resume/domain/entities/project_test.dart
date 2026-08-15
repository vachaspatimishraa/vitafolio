import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';

void main() {
  group('Project Entity', () {
    final tStartDate = DateTime(2023, 1, 1);
    final tEndDate = DateTime(2023, 6, 1);

    final tProject = Project(
      id: 'proj-1',
      name: 'Vitafolio',
      role: 'Lead Developer',
      description: 'Resume builder app',
      technologies: const ['Flutter', 'Dart', 'Riverpod'],
      projectUrl: 'https://github.com/example/vitafolio',
      startDate: tStartDate,
      endDate: tEndDate,
      isOngoing: false,
    );

    test('supports value equality', () {
      final tProjectDuplicate = Project(
        id: 'proj-1',
        name: 'Vitafolio',
        role: 'Lead Developer',
        description: 'Resume builder app',
        technologies: const ['Flutter', 'Dart', 'Riverpod'],
        projectUrl: 'https://github.com/example/vitafolio',
        startDate: tStartDate,
        endDate: tEndDate,
        isOngoing: false,
      );

      expect(tProject, equals(tProjectDuplicate));
      expect(tProject.hashCode, equals(tProjectDuplicate.hashCode));
    });

    test('copyWith creates a new copy with modified fields', () {
      final updated = tProject.copyWith(
        name: 'Vitafolio v2',
        isOngoing: true,
      );

      expect(updated.id, 'proj-1');
      expect(updated.name, 'Vitafolio v2');
      expect(updated.isOngoing, isTrue);
      expect(updated.technologies, const ['Flutter', 'Dart', 'Riverpod']);
    });
  });
}
