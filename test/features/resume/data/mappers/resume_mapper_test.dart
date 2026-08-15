import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/data/mappers/resume_mapper.dart';
import 'package:vitafolio/features/resume/data/models/resume_model.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

void main() {
  group('ResumeMapper', () {
    final now = DateTime.now();
    final resumeDomain = Resume(
      id: const ResumeId('1'),
      title: 'Software Engineer',
      selectedTemplateId: const TemplateId('modern'),
      createdAt: now,
      updatedAt: now,
    );

    test('should map domain to model', () {
      final model = ResumeMapper.toModel(resumeDomain);

      expect(model.id, 1);
      expect(model.title, 'Software Engineer');
      expect(model.selectedTemplateId, 'modern');
      expect(model.createdAt, now);
      expect(model.updatedAt, now);
      expect(model.domainId, '1');
    });

    test('should map model to domain', () {
      final model = ResumeDbModel()
        ..id = 1
        ..title = 'Software Engineer'
        ..selectedTemplateId = 'modern'
        ..createdAt = now
        ..updatedAt = now
        ..domainId = '1';

      final domain = ResumeMapper.toDomain(model);

      expect(domain.id.value, '1');
      expect(domain.title, 'Software Engineer');
      expect(domain.selectedTemplateId.value, 'modern');
      expect(domain.createdAt, now);
      expect(domain.updatedAt, now);
    });
  });
}
