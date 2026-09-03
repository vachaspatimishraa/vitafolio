import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';
import 'package:vitafolio/features/education/presentation/viewmodels/education_viewmodel.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';

void main() {
  group('Education Edit and Delete Lifecycle', () {
    test('MockEducationItem toDomain and fromDomain round-trips correctly with Pursuing', () {
      final domain = Education(
        id: 'edu_1',
        degree: 'Bachelor of Technology',
        fieldOfStudy: 'Computer Science',
        institution: 'MIT',
        location: 'Cambridge, MA',
        startYear: '2021',
        endYear: '',
        isCurrentlyStudying: true,
      );

      final item = MockEducationItem.fromDomain(domain);
      expect(item.id, 'edu_1');
      expect(item.dateRange, '2021 - Pursuing');

      final reconstructed = item.toDomain();
      expect(reconstructed.id, 'edu_1');
      expect(reconstructed.startYear, '2021');
      expect(reconstructed.endYear, '');
      expect(reconstructed.isCurrentlyStudying, true);
    });

    test('MockEducationItem handles completed education round-trip', () {
      final domain = Education(
        id: 'edu_2',
        degree: 'Master of Science',
        fieldOfStudy: 'Artificial Intelligence',
        institution: 'Stanford',
        location: 'Stanford, CA',
        startYear: '2019',
        endYear: '2021',
        isCurrentlyStudying: false,
      );

      final item = MockEducationItem.fromDomain(domain);
      expect(item.id, 'edu_2');
      expect(item.dateRange, '2019 - 2021');

      final reconstructed = item.toDomain();
      expect(reconstructed.id, 'edu_2');
      expect(reconstructed.startYear, '2019');
      expect(reconstructed.endYear, '2021');
      expect(reconstructed.isCurrentlyStudying, false);
    });

    test('MockEducationItem does not insert dummy years when start or end is missing', () {
      final domain = Education(
        id: 'edu_3',
        degree: 'High School Diploma',
        fieldOfStudy: '',
        institution: 'Central High',
        location: '',
        startYear: '',
        endYear: '2018',
        isCurrentlyStudying: false,
      );

      final item = MockEducationItem.fromDomain(domain);
      expect(item.dateRange, '2018'); // No dangling dash!
      expect(item.dateRange.contains('2020'), false);
      expect(item.dateRange.contains('2024'), false);
    });

    test('Updating an item in state replaces in-place without duplicating', () {
      final item1 = MockEducationItem(
        id: 'item_1',
        degree: 'B.Sc',
        fieldOfStudy: 'Physics',
        institution: 'Harvard',
        dateRange: '2018 - 2022',
        grade: '3.8',
        description: '',
      );
      final item2 = MockEducationItem(
        id: 'item_2',
        degree: 'M.Sc',
        fieldOfStudy: 'Math',
        institution: 'Oxford',
        dateRange: '2022 - Pursuing',
        grade: '4.0',
        description: '',
      );

      var state = EducationListState(educations: [item1, item2]);
      expect(state.educations.length, 2);

      // User edits item1
      final editedItem1 = MockEducationItem(
        id: 'item_1', // SAME ID!
        degree: 'B.Sc (Hons)',
        fieldOfStudy: 'Applied Physics',
        institution: 'Harvard University',
        dateRange: '2018 - 2022',
        grade: '3.9',
        description: '',
      );

      // Simulation of updateEducation
      final updatedList = state.educations
          .map((e) => e.id == editedItem1.id ? editedItem1 : e)
          .toList();
      state = state.copyWith(educations: updatedList);

      // CRITICAL: length remains 2 (no duplicate was appended!)
      expect(state.educations.length, 2);
      expect(state.educations.first.degree, 'B.Sc (Hons)');
      expect(state.educations.first.fieldOfStudy, 'Applied Physics');
      expect(state.educations.first.grade, '3.9');

      // Now deleting item1 removes ONLY item1
      final afterDelete = state.educations.where((e) => e.id != 'item_1').toList();
      expect(afterDelete.length, 1);
      expect(afterDelete.first.id, 'item_2');
    });

    test('DateRangeFormatter cleanly constructs education date range for AddEducationPage', () {
      // 1. Start and end provided
      final range1 = DateRangeFormatter.formatEducation(
        startYear: '2019',
        endYear: '2023',
        isCurrentlyStudying: false,
        separator: ' - ',
      );
      expect(range1, '2019 - 2023');

      // 2. Currently studying with start year
      final range2 = DateRangeFormatter.formatEducation(
        startYear: '2022',
        endYear: null,
        isCurrentlyStudying: true,
        separator: ' - ',
      );
      expect(range2, '2022 - Pursuing');

      // 3. Only end year provided (no start year) -> NO dangling dash
      final range3 = DateRangeFormatter.formatEducation(
        startYear: null,
        endYear: '2024',
        isCurrentlyStudying: false,
        separator: ' - ',
      );
      expect(range3, '2024');

      // 4. Only start year provided (no end year) -> NO dangling dash
      final range4 = DateRangeFormatter.formatEducation(
        startYear: '2020',
        endYear: null,
        isCurrentlyStudying: false,
        separator: ' - ',
      );
      expect(range4, '2020');

      // 5. Neither provided
      final range5 = DateRangeFormatter.formatEducation(
        startYear: null,
        endYear: null,
        isCurrentlyStudying: false,
        separator: ' - ',
      );
      expect(range5, '');
    });
  });
}
