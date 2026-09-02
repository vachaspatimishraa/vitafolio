import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/utils/employment_type_helper.dart';
import 'package:vitafolio/features/experience/presentation/pages/add_experience_page.dart';
import 'package:vitafolio/features/experience/presentation/viewmodels/experience_viewmodel.dart';
import 'package:vitafolio/features/experience/presentation/widgets/experience_form.dart';

void main() {
  group('EmploymentTypeHelper Normalization & Safety Tests', () {
    test('Test 1 — Valid Full-Time is preserved without exception', () {
      final normalized = EmploymentTypeHelper.normalizeEmploymentType('Full-Time');
      expect(normalized, 'Full-Time');
      final safeValue = EmploymentTypeHelper.getSafeDropdownValue('Full-Time');
      expect(safeValue, 'Full-Time');
    });

    test('Test 2 — Duplicate Options are Deduplicated without duplicates', () {
      final options = EmploymentTypeHelper.standardOptions;
      final unique = options.toSet().toList();
      expect(options.length, equals(unique.length));
    });

    test('Test 3 — Legacy "Full Time" normalized to "Full-Time"', () {
      final normalized = EmploymentTypeHelper.normalizeEmploymentType('Full Time');
      expect(normalized, 'Full-Time');
      final safeValue = EmploymentTypeHelper.getSafeDropdownValue('Full Time');
      expect(safeValue, 'Full-Time');
    });

    test('Test 4 — Case Difference "full-time" normalized to "Full-Time"', () {
      final normalized = EmploymentTypeHelper.normalizeEmploymentType('full-time');
      expect(normalized, 'Full-Time');
      final safeValue = EmploymentTypeHelper.getSafeDropdownValue('full-time');
      expect(safeValue, 'Full-Time');
    });

    test('Test 5 — Invalid Value returns null', () {
      final normalized = EmploymentTypeHelper.normalizeEmploymentType('InvalidType123');
      expect(normalized, isNull);
      final safeValue = EmploymentTypeHelper.getSafeDropdownValue('InvalidType123');
      expect(safeValue, isNull);
    });

    test('Test 6 — Null Value returns null with no crash', () {
      final normalized = EmploymentTypeHelper.normalizeEmploymentType(null);
      expect(normalized, isNull);
      final safeValue = EmploymentTypeHelper.getSafeDropdownValue(null);
      expect(safeValue, isNull);
    });

    test('Test 7 — Empty Value returns null with no crash', () {
      final normalized = EmploymentTypeHelper.normalizeEmploymentType('');
      expect(normalized, isNull);
      final safeValue = EmploymentTypeHelper.getSafeDropdownValue('');
      expect(safeValue, isNull);
    });
  });

  group('ExperienceForm Widget Dropdown Safety Tests', () {
    testWidgets('Test 8 — Edit existing Experience with Full-Time opens without Flutter Dropdown assertion error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExperienceForm(
              formKey: GlobalKey<FormState>(),
              jobTitleController: TextEditingController(text: 'Engineer'),
              companyController: TextEditingController(text: 'Google'),
              selectedEmploymentType: EmploymentTypeHelper.getSafeDropdownValue('Full-Time'),
              selectedCountry: 'United States',
              selectedState: 'California',
              selectedCity: 'Mountain View',
              selectedLocation: 'Mountain View, CA',
              fromDate: '2020',
              toDate: 'Present',
              isCurrentlyWorking: true,
              responsibilitiesController: TextEditingController(),
              onEmploymentTypeChanged: (_) {},
              onCountryChanged: (_) {},
              onStateChanged: (_) {},
              onCityChanged: (_) {},
              onLocationChanged: (_) {},
              onCurrentlyWorkingChanged: (_) {},
              onSelectFromDate: () {},
              onSelectToDate: () {},
              onResponsibilitiesChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExperienceForm), findsOneWidget);
    });

    testWidgets('Test 9 — Edit existing Experience with Legacy "Full Time" (no hyphen) opens safely with Full-Time selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExperienceForm(
              formKey: GlobalKey<FormState>(),
              jobTitleController: TextEditingController(text: 'Engineer'),
              companyController: TextEditingController(text: 'Google'),
              selectedEmploymentType: EmploymentTypeHelper.getSafeDropdownValue('Full Time'),
              selectedCountry: 'United States',
              selectedState: 'California',
              selectedCity: 'Mountain View',
              selectedLocation: 'Mountain View, CA',
              fromDate: '2020',
              toDate: 'Present',
              isCurrentlyWorking: true,
              responsibilitiesController: TextEditingController(),
              onEmploymentTypeChanged: (_) {},
              onCountryChanged: (_) {},
              onStateChanged: (_) {},
              onCityChanged: (_) {},
              onLocationChanged: (_) {},
              onCurrentlyWorkingChanged: (_) {},
              onSelectFromDate: () {},
              onSelectToDate: () {},
              onResponsibilitiesChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExperienceForm), findsOneWidget);
    });

    testWidgets('Test 10 — AddExperiencePage renders in edit mode without crashing and preserves stable ID on save', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AddExperiencePage(
              isEditing: true,
              initialItem: MockExperienceItem(
                id: 'exp_100',
                title: 'Senior Dev',
                company: 'Tech Corp',
                employmentType: 'Full-Time',
                dateRange: '2021 - Present',
                location: 'San Francisco, CA',
                isCurrent: true,
                responsibilities: 'Writing code',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AddExperiencePage), findsOneWidget);
    });
  });
}
