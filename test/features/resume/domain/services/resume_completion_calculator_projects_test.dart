import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/services/resume_completion_calculator_impl.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

void main() {
  group('ResumeCompletionCalculator Projects Section', () {
    const calculator = ResumeCompletionCalculatorImpl();

    test('totalSections returns 10', () {
      expect(calculator.totalSections(), 10);
    });

    test('counts Projects as completed when valid project exists', () {
      final resumeWithProject = Resume(
        id: const ResumeId('1'),
        title: 'Test Resume',
        selectedTemplateId: const TemplateId('modern'),
        projects: const [
          Project(
            id: '1',
            name: 'Vitafolio',
            role: 'Dev',
            description: 'Awesome app',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final count = calculator.completedSections(resumeWithProject);
      // Title (1) + Template (1) + Projects (1) = 3
      expect(count, 3);
    });

    test('does not count Projects as completed when project has empty name', () {
      final resumeWithInvalidProject = Resume(
        id: const ResumeId('1'),
        title: 'Test Resume',
        selectedTemplateId: const TemplateId('modern'),
        projects: const [
          Project(
            id: '1',
            name: '',
            role: 'Dev',
            description: 'Awesome app',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final count = calculator.completedSections(resumeWithInvalidProject);
      // Title (1) + Template (1) = 2
      expect(count, 2);
    });
  });
}
