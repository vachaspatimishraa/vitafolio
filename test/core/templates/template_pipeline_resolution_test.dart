import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/templates/repository/template_repository.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/core/pdf/services/pdf_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final templateRepo = TemplateRepository();

  group('TASK 060 Template Pipeline Resolution Tests', () {
    test('Test 1 — Template Repository loads 10 unique PNG template definitions', () {
      final templates = templateRepo.getTemplates();
      expect(templates.length, equals(10));
    });

    test('Test 2 — Resolving Template A vs Template B produces distinct template models & PNG assets', () {
      final templateA = templateRepo.getTemplate('ats');
      final templateB = templateRepo.getTemplate('executive');

      expect(templateA.id, equals('ats'));
      expect(templateB.id, equals('executive'));
      expect(templateA.previewAsset, isNot(equals(templateB.previewAsset)));
    });

    test('Test 3 — PdfService workflowStateFromDomain maps selectedTemplateId cleanly', () async {
      final resumeA = Resume(
        id: const ResumeId('res-a'),
        title: 'Resume A',
        selectedTemplateId: const TemplateId('creative'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final renderDataA = PdfService.workflowStateFromDomain(resumeA);
      expect(renderDataA.selectedTemplateId, equals('creative'));
    });
  });
}
