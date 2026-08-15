import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/core/templates/repository/template_repository.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class ProfileImageState {
  final String? imagePath;
  final bool isLoading;
  final String? errorMessage;
  final bool requiresProfileImage;

  const ProfileImageState({
    this.imagePath,
    this.isLoading = false,
    this.errorMessage,
    this.requiresProfileImage = false,
  });

  ProfileImageState copyWith({
    String? imagePath,
    bool? isLoading,
    String? errorMessage,
    bool? requiresProfileImage,
  }) {
    return ProfileImageState(
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      requiresProfileImage: requiresProfileImage ?? this.requiresProfileImage,
    );
  }
}

class ProfileImageViewModel extends StateNotifier<ProfileImageState> {
  final Ref _ref;
  final GetResume _getResume;
  final UpdateResume _updateResume;
  final TemplateRepository _templateRepo;

  ProfileImageViewModel(
    this._ref,
    this._getResume,
    this._updateResume, {
    TemplateRepository? templateRepo,
  })  : _templateRepo = templateRepo ?? TemplateRepository(),
        super(const ProfileImageState()) {
    _load();
  }

  Future<void> _load() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final resume = await _getResume(activeId);
      bool requiresPhoto = false;

      if (resume != null) {
        final templateIdStr = resume.selectedTemplateId.value;
        final template = _templateRepo.getTemplate(templateIdStr);
        requiresPhoto = template.requiresProfileImage;
      }

      state = state.copyWith(
        imagePath: resume?.personalDetails?.profileImagePath,
        requiresProfileImage: requiresPhoto,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load profile image info',
      );
    }
  }

  Future<void> pickImage() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );

      if (result == null || result.files.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final platformFile = result.files.first;
      final ext = platformFile.name.split('.').last.toLowerCase();

      if (ext != 'jpg' && ext != 'jpeg' && ext != 'png' && ext != 'webp') {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Unsupported image format.\nPlease select a JPG, PNG, or WebP image.',
        );
        return;
      }

      final sizeInMB = platformFile.size / (1024 * 1024);
      if (sizeInMB > 10.0) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Image is too large.\nPlease choose an image smaller than 10 MB.',
        );
        return;
      }

      state = state.copyWith(
        imagePath: platformFile.path,
        isLoading: false,
        errorMessage: null,
      );

      await save();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to select photo. Please try again.',
      );
    }
  }

  Future<void> removeImage() async {
    state = ProfileImageState(
      imagePath: null,
      isLoading: false,
      requiresProfileImage: state.requiresProfileImage,
      errorMessage: null,
    );
    await save();
  }

  Future<bool> save() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId == null) return true;

    try {
      final resume = await _getResume(activeId);
      if (resume != null) {
        final currentDetails = resume.personalDetails ??
            const PersonalDetails(
              fullName: '',
              email: '',
              phoneNumber: '',
              address: '',
            );
        final updatedDetails = currentDetails.copyWith(
          profileImagePath: state.imagePath,
        );
        final updatedResume = resume.copyWith(
          personalDetails: updatedDetails,
          updatedAt: DateTime.now(),
        );
        await _updateResume(updatedResume);
      }
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to save profile image: ${e.toString()}',
      );
      return false;
    }
  }
}

final profileImageViewModelProvider =
    StateNotifierProvider<ProfileImageViewModel, ProfileImageState>((ref) {
  ref.watch(activeResumeIdProvider);
  final getResume = ref.watch(getResumeUseCaseProvider);
  final updateResume = ref.watch(updateResumeUseCaseProvider);
  return ProfileImageViewModel(ref, getResume, updateResume);
});
