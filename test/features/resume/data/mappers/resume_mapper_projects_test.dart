import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/data/mappers/resume_mapper.dart';
import 'package:vitafolio/features/resume/data/models/resume_model.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

void main() {
  group('ResumeMapper Projects Mapping', () {
    final tStartDate = DateTime(2023, 1, 1);
    final tEndDate = DateTime(2023, 6, 1);

    final tProject = Project(
      id: 'proj-101',
      name: 'Portfolio Engine',
      role: 'Architect',
      description: 'Engine for portfolio generation',
      technologies: const ['Dart', 'Isar'],
      projectUrl: 'https://vitafolio.dev',
      startDate: tStartDate,
      endDate: tEndDate,
      isOngoing: false,
    );

    final tResume = Resume(
      id: const ResumeId('1'),
      title: 'My Resume',
      selectedTemplateId: const TemplateId('modern_clean'),
      projects: [tProject],
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

    test('toModel correctly maps projects to ProjectDbModel list', () {
      final model = ResumeMapper.toModel(tResume);

      expect(model.projects, isNotNull);
      expect(model.projects!.length, 1);

      final pModel = model.projects!.first;
      expect(pModel.id, 'proj-101');
      expect(pModel.name, 'Portfolio Engine');
      expect(pModel.role, 'Architect');
      expect(pModel.description, 'Engine for portfolio generation');
      expect(pModel.technologies, const ['Dart', 'Isar']);
      expect(pModel.projectUrl, 'https://vitafolio.dev');
      expect(pModel.startDate, tStartDate);
      expect(pModel.endDate, tEndDate);
      expect(pModel.isOngoing, isFalse);
    });

    test('toDomain correctly maps ProjectDbModel list to domain Projects', () {
      final dbModel = ResumeDbModel()
        ..id = 1
        ..title = 'My Resume'
        ..selectedTemplateId = 'modern_clean'
        ..createdAt = DateTime(2025, 1, 1)
        ..updatedAt = DateTime(2025, 1, 1)
        ..projects = [
          ProjectDbModel()
            ..id = 'proj-101'
            ..name = 'Portfolio Engine'
            ..role = 'Architect'
            ..description = 'Engine for portfolio generation'
            ..technologies = ['Dart', 'Isar']
            ..projectUrl = 'https://vitafolio.dev'
            ..startDate = tStartDate
            ..endDate = tEndDate
            ..isOngoing = false,
        ];

      final domainResume = ResumeMapper.toDomain(dbModel);

      expect(domainResume.projects.length, 1);
      final project = domainResume.projects.first;
      expect(project.id, 'proj-101');
      expect(project.name, 'Portfolio Engine');
      expect(project.role, 'Architect');
      expect(project.description, 'Engine for portfolio generation');
      expect(project.technologies, const ['Dart', 'Isar']);
      expect(project.projectUrl, 'https://vitafolio.dev');
      expect(project.startDate, tStartDate);
      expect(project.endDate, tEndDate);
      expect(project.isOngoing, isFalse);
    });
  });
}
