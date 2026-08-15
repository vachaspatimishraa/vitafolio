import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/domain/entities/certification.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/language.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/entities/template.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

void main() {
  group('Resume Domain Entities & Value Objects Tests', () {
    test('ResumeId equality and copy', () {
      const id1 = ResumeId('res-123');
      const id2 = ResumeId('res-123');
      const id3 = ResumeId('res-456');

      expect(id1, equals(id2));
      expect(id1 == id3, isFalse);
      expect(id1.toString(), contains('res-123'));
    });

    test('TemplateId equality and copy', () {
      const t1 = TemplateId('tmpl-modern');
      const t2 = TemplateId('tmpl-modern');

      expect(t1, equals(t2));
    });

    test('PersonalDetails immutability and copyWith', () {
      const details = PersonalDetails(
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        address: '123 Tech Street',
      );

      final updated = details.copyWith(fullName: 'Jane Doe');

      expect(updated.fullName, equals('Jane Doe'));
      expect(updated.email, equals('john@example.com'));
      expect(details.fullName, equals('John Doe'));
    });

    test('Resume Root Entity equality and copyWith', () {
      final now = DateTime.now();
      final resume = Resume(
        id: const ResumeId('res-1'),
        title: 'Software Engineer',
        selectedTemplateId: const TemplateId('tmpl-1'),
        createdAt: now,
        updatedAt: now,
      );

      final updated = resume.copyWith(title: 'Senior Software Engineer');

      expect(updated.title, equals('Senior Software Engineer'));
      expect(updated.id, equals(const ResumeId('res-1')));
    });

    test('Sub-entities copyWith test', () {
      const summary = ProfessionalSummary(summaryText: 'Initial summary');
      expect(summary.copyWith(summaryText: 'New').summaryText, equals('New'));

      const exp = Experience(
        id: 'e1',
        jobTitle: 'Dev',
        company: 'Corp',
        location: 'NYC',
        startDate: '2020',
        description: 'Code',
      );
      expect(exp.copyWith(jobTitle: 'Lead').jobTitle, equals('Lead'));

      const edu = Education(
        id: 'ed1',
        degree: 'BS',
        fieldOfStudy: 'CS',
        institution: 'MIT',
        location: 'MA',
        startYear: '2016',
        endYear: '2020',
      );
      expect(edu.copyWith(degree: 'MS').degree, equals('MS'));

      const skill = Skill(id: 's1', name: 'Flutter');
      expect(skill.copyWith(level: 'Expert').level, equals('Expert'));

      const cert = Certification(
        id: 'c1',
        name: 'AWS SA',
        organization: 'Amazon',
        issueDate: '2022',
      );
      expect(cert.copyWith(name: 'AWS Dev').name, equals('AWS Dev'));

      const lang = Language(id: 'l1', name: 'English', proficiencyLevel: 'Native');
      expect(lang.copyWith(proficiencyLevel: 'C2').proficiencyLevel, equals('C2'));

      const tmpl = ResumeTemplate(
        id: TemplateId('t1'),
        name: 'Modern',
        description: 'Clean',
        thumbnailUrl: 'img.png',
      );
      expect(tmpl.copyWith(name: 'Executive').name, equals('Executive'));
    });
  });
}
