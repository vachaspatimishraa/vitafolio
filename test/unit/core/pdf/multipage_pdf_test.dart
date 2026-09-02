import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/pdf/services/pdf_service.dart';
import 'package:vitafolio/features/resume/domain/entities/certification.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/language.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Multipage PDF Generation Tests', () {
    final pdfService = PdfService();

    final shortResume = Resume(
      id: const ResumeId('short_1'),
      title: 'Short Resume',
      selectedTemplateId: const TemplateId('ats'),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      personalDetails: const PersonalDetails(
        fullName: 'Short Profile',
        jobTitle: 'Junior Dev',
        email: 'short@test.com',
        phoneNumber: '+1 555-0100',
        address: 'New York, NY',
      ),
      summary: const ProfessionalSummary(summaryText: 'Brief summary.'),
      experiences: const [
        Experience(
          id: 'exp-1',
          jobTitle: 'Intern',
          company: 'Small Co',
          location: 'Remote',
          startDate: '2023',
          endDate: '2024',
          description: 'Basic internship tasks.',
        ),
      ],
      educations: const [
        Education(
          id: 'edu-1',
          institution: 'City College',
          degree: 'B.Sc.',
          fieldOfStudy: 'Information Technology',
          location: 'New York, NY',
          startYear: '2019',
          endYear: '2023',
        ),
      ],
      skills: const [
        Skill(id: 's-1', name: 'Dart'),
      ],
      projects: const [],
      certifications: const [],
      languages: const [
        Language(id: 'l-1', name: 'English', proficiencyLevel: 'Fluent'),
      ],
    );

    final longResume = Resume(
      id: const ResumeId('long_1'),
      title: 'Long Resume',
      selectedTemplateId: const TemplateId('ats'),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      personalDetails: const PersonalDetails(
        fullName: 'Dr. Alexander Hamilton Montgomery',
        jobTitle: 'Distinguished Fellow & Global Architecture Director',
        email: 'alex.montgomery@enterprise.org',
        phoneNumber: '+1 (555) 987-6543',
        address: 'San Francisco, CA',
        linkedinUrl: 'linkedin.com/in/alex-montgomery',
        githubUrl: 'github.com/alex-montgomery',
        website: 'https://alexmontgomery.tech',
      ),
      summary: const ProfessionalSummary(
        summaryText:
            'Visionary enterprise architect with over fifteen years of distinguished experience delivering highly resilient, fault-tolerant distributed platforms, leading multi-continental engineering organizations of 120+ software specialists, spearheading cloud-native modernization strategies, driving multi-million-dollar technology investments, and establishing engineering standards across fortune 50 corporations.',
      ),
      experiences: const [
        Experience(
          id: 'exp-1',
          jobTitle: 'VP of Distributed Infrastructure',
          company: 'OmniGlobal Cloud Systems',
          location: 'San Francisco, CA',
          startDate: '2022',
          endDate: 'Present',
          isCurrentRole: true,
          description:
              '• Directed global architectural governance across 14 Tier-1 datacenters and multi-cloud footprints.\n• Reduced operational infrastructure expenditure by 34% through automated workload scheduling.\n• Mentored 8 principal engineers and formulated quarterly technical development roadmaps.\n• Spearheaded high-throughput streaming systems handling in excess of 450,000 TPS.',
        ),
        Experience(
          id: 'exp-2',
          jobTitle: 'Principal Mobile & Backend Architect',
          company: 'HyperScale Technologies Inc.',
          location: 'New York, NY',
          startDate: '2018',
          endDate: '2022',
          description:
              '• Architected core cross-platform client architecture deployed to over 15 million active consumer endpoints.\n• Designed low-latency synchronization protocols using delta-compression algorithms.\n• Coordinated cross-functional teams spanning 4 continents to deliver real-time financial dashboards.\n• Championed rigorous unit and integration testing culture achieving 98% branch coverage.',
        ),
        Experience(
          id: 'exp-3',
          jobTitle: 'Senior Staff Systems Engineer',
          company: 'Quantum Dynamics Labs',
          location: 'Boston, MA',
          startDate: '2014',
          endDate: '2018',
          description:
              '• Developed embedded telemetry collection frameworks operating with sub-millisecond precision.\n• Led root-cause analysis investigations for mission-critical production anomalies.\n• Authored 12 internal engineering whitepapers adopted across the enterprise.',
        ),
        Experience(
          id: 'exp-4',
          jobTitle: 'Lead Software Specialist',
          company: 'CyberCore Networks',
          location: 'Austin, TX',
          startDate: '2010',
          endDate: '2014',
          description:
              '• Implemented cryptographic authentication microservices satisfying strict compliance standards.\n• Re-architected legacy relational database schemas into distributed partitioned storage engines.\n• Collaborated closely with security auditors to achieve SOC2 Type II certifications.',
        ),
      ],
      projects: const [
        Project(
          id: 'p-1',
          name: 'Distributed Resilient Ledger Engine',
          role: 'Principal Systems Architect',
          description:
              'Engineered a zero-dependency Byzantine fault-tolerant consensus engine with dynamic peer discovery.',
          technologies: ['Dart', 'C++', 'gRPC', 'Protobuf'],
        ),
        Project(
          id: 'p-2',
          name: 'Real-Time Neural Audio Processor',
          role: 'Lead ML Engineer',
          description:
              'Developed on-device neural denoising filters running in WebAssembly and Flutter with <10ms latency.',
          technologies: ['Flutter', 'Rust', 'WebAssembly'],
        ),
        Project(
          id: 'p-3',
          name: 'High-Concurrency Event Bus',
          role: 'Backend Systems Lead',
          description:
              'Implemented lock-free ring-buffer pipeline processing over 2 million events per second per core.',
          technologies: ['Go', 'Kafka', 'Redis'],
        ),
        Project(
          id: 'p-4',
          name: 'Vitafolio Architecture Suite',
          role: 'Lead Mobile Architect',
          description:
              'Complete resume authoring suite featuring multi-page PDF generation and native Word export.',
          technologies: ['Flutter', 'OpenXML', 'Riverpod'],
        ),
      ],
      educations: const [
        Education(
          id: 'edu-1',
          institution: 'Massachusetts Institute of Technology',
          degree: 'Ph.D.',
          fieldOfStudy: 'Distributed Systems',
          location: 'Cambridge, MA',
          startYear: '2006',
          endYear: '2010',
          grade: '4.0 GPA (Summa Cum Laude)',
        ),
        Education(
          id: 'edu-2',
          institution: 'Carnegie Mellon University',
          degree: 'Bachelor of Science',
          fieldOfStudy: 'Software Engineering',
          location: 'Pittsburgh, PA',
          startYear: '2002',
          endYear: '2006',
          grade: '3.95 GPA',
        ),
      ],
      skills: const [
        Skill(id: 's-1', name: 'Distributed Systems'),
        Skill(id: 's-2', name: 'Cloud Native Architecture'),
        Skill(id: 's-3', name: 'Flutter & Dart'),
        Skill(id: 's-4', name: 'Kubernetes & Docker'),
        Skill(id: 's-5', name: 'gRPC & Microservices'),
        Skill(id: 's-6', name: 'High-Throughput Streaming'),
        Skill(id: 's-7', name: 'Database Optimization'),
        Skill(id: 's-8', name: 'Performance Profiling'),
        Skill(id: 's-9', name: 'Security & Compliance'),
        Skill(id: 's-10', name: 'Team Leadership'),
      ],
      certifications: const [
        Certification(
          id: 'c-1',
          name: 'AWS Certified Solutions Architect - Professional',
          organization: 'Amazon Web Services',
          issueDate: '2023',
        ),
        Certification(
          id: 'c-2',
          name: 'Google Cloud Certified Fellow',
          organization: 'Google Cloud',
          issueDate: '2022',
        ),
        Certification(
          id: 'c-3',
          name: 'Certified Kubernetes Administrator (CKA)',
          organization: 'Cloud Native Computing Foundation',
          issueDate: '2021',
        ),
      ],
      languages: const [
        Language(id: 'l-1', name: 'English', proficiencyLevel: 'Native'),
        Language(id: 'l-2', name: 'German', proficiencyLevel: 'Professional'),
        Language(id: 'l-3', name: 'French', proficiencyLevel: 'Conversational'),
      ],
    );

    test('short resume generates valid PDF bytes', () async {
      final bytes = await pdfService.generatePdfFromDomain(shortResume);
      expect(bytes, isNotEmpty);
      expect(bytes.length, greaterThan(1000));
    });

    test('long resume generates multi-page PDF document without throwing for all templates', () async {
      final templates = [
        'ats',
        'modern',
        'classic',
        'minimal',
        'executive',
        'awesome',
        'academic',
        'compact',
        'elegant',
        'simple',
      ];

      for (final templateId in templates) {
        final resumeWithTemplate = longResume.copyWith(
          selectedTemplateId: TemplateId(templateId),
        );
        final bytes = await pdfService.generatePdfFromDomain(resumeWithTemplate);
        expect(bytes, isNotEmpty, reason: 'Failed for template: $templateId');
        expect(bytes.length, greaterThan(2000), reason: 'Too small for template: $templateId');
      }
    });
  });
}
