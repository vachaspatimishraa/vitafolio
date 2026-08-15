import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/profile_image/presentation/pages/profile_image_page.dart';
import 'package:vitafolio/features/profile_image/presentation/viewmodels/profile_image_viewmodel.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

void main() {
  group('ProfileImageViewModel Tests', () {
    test('State initializes with empty/null profile image path', () {
      const state = ProfileImageState();
      expect(state.imagePath, isNull);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.requiresProfileImage, isFalse);
    });

    test('removeImage clears image path from state', () async {
      final repo = FakeResumeRepository(
        Resume(
          id: const ResumeId('test-id'),
          title: 'Test',
          selectedTemplateId: const TemplateId('ats'),
          personalDetails: const PersonalDetails(
            fullName: 'John',
            email: 'john@example.com',
            phoneNumber: '1234567890',
            address: 'City, State, Country',
            profileImagePath: '/path/to/image.jpg',
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          activeResumeIdProvider.overrideWith((ref) => const ResumeId('test-id')),
          getResumeUseCaseProvider.overrideWithValue(GetResume(repo)),
          updateResumeUseCaseProvider.overrideWithValue(UpdateResume(repo)),
        ],
      );

      final viewModel = container.read(profileImageViewModelProvider.notifier);
      await Future.delayed(Duration.zero);

      await viewModel.removeImage();
      final state = container.read(profileImageViewModelProvider);

      expect(state.imagePath, isNull);
    });
  });

  group('ProfileImagePage Widget Tests', () {
    testWidgets('renders Profile Image page title and Upload Photo button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeResumeIdProvider.overrideWith((ref) => null),
          ],
          child: const MaterialApp(
            home: ProfileImagePage(),
          ),
        ),
      );

      expect(find.text('Profile Image'), findsWidgets);
      expect(find.byKey(const Key('upload_photo_button')), findsOneWidget);
    });
  });
}

class FakeResumeRepository implements ResumeRepository {
  final Resume? dummyResume;
  FakeResumeRepository([this.dummyResume]);

  @override
  Future<Resume?> getResume(ResumeId id) async => dummyResume;

  @override
  Future<Resume> updateResume(Resume resume) async => resume;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
