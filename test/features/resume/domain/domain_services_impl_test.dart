import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/domain/entities/certification.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/language.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/services/resume_completion_calculator_impl.dart';
import 'package:vitafolio/features/resume/domain/services/resume_validator_impl.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

void main() {
  group('ResumeValidatorImpl Tests', () {
    const validator = ResumeValidatorImpl();

    test('validates empty resume and fails on missing Full Name & Phone', () {
      final emptyResume = Resume(
        id: const ResumeId('r1'),
        title: '',
        selectedTemplateId: const TemplateId(''),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final failures = validator.validate(emptyResume);

      expect(failures, isNotEmpty);
      expect(validator.isComplete(emptyResume), isFalse);
    });

    test('passes validation when ONLY Full Name and Phone Number are provided', () {
      final minimalResume = Resume(
        id: const ResumeId('r-min'),
        title: 'Minimal Resume',
        selectedTemplateId: const TemplateId('ats_friendly'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        personalDetails: const PersonalDetails(
          fullName: 'John Doe',
          email: '',
          phoneNumber: '9876543210',
          address: '',
        ),
      );

      final failures = validator.validate(minimalResume);

      expect(failures, isEmpty);
      expect(validator.isComplete(minimalResume), isTrue);
    });

    test('fails validation if email is provided but malformed', () {
      final malformedEmailResume = Resume(
        id: const ResumeId('r-email'),
        title: 'Bad Email Resume',
        selectedTemplateId: const TemplateId('ats_friendly'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        personalDetails: const PersonalDetails(
          fullName: 'John Doe',
          email: 'invalid-email-no-at',
          phoneNumber: '9876543210',
          address: '',
        ),
      );

      final failures = validator.validate(malformedEmailResume);

      expect(failures, isNotEmpty);
      expect(failures.first.message, contains('valid email address'));
    });

    test('validates complete resume with zero failures across all 10 sections', () {
      final now = DateTime.now();
      final validResume = Resume(
        id: const ResumeId('r2'),
        title: 'Full Resume',
        selectedTemplateId: const TemplateId('tmpl-modern'),
        createdAt: now,
        updatedAt: now,
        personalDetails: const PersonalDetails(
          fullName: 'Jane Doe',
          email: 'jane@example.com',
          phoneNumber: '+123456789',
          address: '456 Tech Ave',
        ),
        summary: const ProfessionalSummary(summaryText: 'Skilled engineer'),
        experiences: const [
          Experience(
            id: 'e1',
            jobTitle: 'Developer',
            company: 'Tech Corp',
            location: 'NY',
            startDate: '2020',
            description: 'Coding',
          ),
        ],
        projects: const [
          Project(
            id: 'p1',
            name: 'Project One',
            role: 'Lead',
            description: 'Project details',
          ),
        ],
        educations: const [
          Education(
            id: 'ed1',
            degree: 'BS CS',
            fieldOfStudy: 'CS',
            institution: 'University',
            location: 'NY',
            startYear: '2016',
            endYear: '2020',
          ),
        ],
        skills: const [Skill(id: 's1', name: 'Flutter')],
        certifications: const [
          Certification(
            id: 'c1',
            name: 'AWS Certified',
            organization: 'Amazon',
            issueDate: '2022',
          ),
        ],
        languages: const [
          Language(
            id: 'l1',
            name: 'English',
            proficiencyLevel: 'Native',
          ),
        ],
      );

      final failures = validator.validate(validResume);

      expect(failures, isEmpty);
      expect(validator.isComplete(validResume), isTrue);
    });
  });

  group('ResumeCompletionCalculatorImpl Tests', () {
    const calculator = ResumeCompletionCalculatorImpl();

    test('calculates 0 progress for totally empty resume', () {
      final emptyResume = Resume(
        id: const ResumeId(''),
        title: '',
        selectedTemplateId: const TemplateId(''),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(calculator.completedSections(emptyResume), equals(0));
      expect(calculator.calculateProgress(emptyResume), equals(0.0));
      expect(calculator.totalSections(), equals(10));
    });

    test('calculates 1.0 (10/10) progress for fully completed resume', () {
      final now = DateTime.now();
      final fullResume = Resume(
        id: const ResumeId('r3'),
        title: 'Senior Portfolio',
        selectedTemplateId: const TemplateId('tmpl-modern'),
        createdAt: now,
        updatedAt: now,
        personalDetails: const PersonalDetails(
          fullName: 'John Smith',
          email: 'john@example.com',
          phoneNumber: '555-0199',
          address: 'Main St',
        ),
        summary: const ProfessionalSummary(summaryText: 'Summary text'),
        experiences: const [
          Experience(
            id: 'e1',
            jobTitle: 'Architect',
            company: 'Design Inc',
            location: 'CA',
            startDate: '2019',
            description: 'Designing systems',
          ),
        ],
        projects: const [
          Project(
            id: 'p1',
            name: 'Project One',
            role: 'Architect',
            description: 'Building system',
          ),
        ],
        educations: const [
          Education(
            id: 'ed1',
            degree: 'MS',
            fieldOfStudy: 'SE',
            institution: 'Stanford',
            location: 'CA',
            startYear: '2017',
            endYear: '2019',
          ),
        ],
        skills: const [Skill(id: 's1', name: 'Architecture')],
        certifications: const [
          Certification(
            id: 'c1',
            name: 'PMP',
            organization: 'PMI',
            issueDate: '2021',
          ),
        ],
        languages: const [
          Language(id: 'l1', name: 'English', proficiencyLevel: 'Native'),
        ],
      );

      expect(calculator.completedSections(fullResume), equals(10));
      expect(calculator.calculateProgress(fullResume), equals(1.0));
    });
  });
}
