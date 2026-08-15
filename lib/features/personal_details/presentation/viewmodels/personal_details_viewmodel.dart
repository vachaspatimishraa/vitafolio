import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class PersonalDetailsState {
  final String fullName;
  final String jobRole;
  final String phone;
  final String email;
  final String country;
  final String state;
  final String city;
  final String linkedin;
  final String github;
  final String portfolio;
  final bool isLoading;
  final String? errorMessage;

  const PersonalDetailsState({
    this.fullName = '',
    this.jobRole = '',
    this.phone = '',
    this.email = '',
    this.country = '',
    this.state = '',
    this.city = '',
    this.linkedin = '',
    this.github = '',
    this.portfolio = '',
    this.isLoading = false,
    this.errorMessage,
  });


  PersonalDetailsState copyWith({
    String? fullName,
    String? jobRole,
    String? phone,
    String? email,
    String? country,
    String? state,
    String? city,
    String? linkedin,
    String? github,
    String? portfolio,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PersonalDetailsState(
      fullName: fullName ?? this.fullName,
      jobRole: jobRole ?? this.jobRole,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      portfolio: portfolio ?? this.portfolio,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class PersonalDetailsViewModel extends StateNotifier<PersonalDetailsState> {
  final Ref _ref;
  final GetResume _getResume;
  final UpdateResume _updateResume;

  PersonalDetailsViewModel(this._ref, this._getResume, this._updateResume)
    : super(const PersonalDetailsState()) {
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
      if (resume != null && resume.personalDetails != null) {
        final details = resume.personalDetails!;
        String country = '';
        String stateStr = '';
        String city = '';


        if (details.address.contains(', ')) {
          final parts = details.address.split(', ');
          if (parts.length >= 3) {
            city = parts[0];
            stateStr = parts[1];
            country = parts[2];
          } else if (parts.length == 2) {
            city = parts[0];
            stateStr = parts[1];
          } else {
            city = details.address;
          }
        } else {
          city = details.address;
        }

        state = state.copyWith(
          fullName: details.fullName,
          jobRole: details.jobTitle ?? '',
          phone: details.phoneNumber,
          email: details.email,
          country: country,
          state: stateStr,
          city: city,
          linkedin: details.linkedinUrl ?? '',
          github: details.githubUrl ?? '',
          portfolio: details.website ?? '',
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load personal details',
      );
    }
  }

  void updateField({
    String? fullName,
    String? jobRole,
    String? phone,
    String? email,
    String? country,
    String? state,
    String? city,
    String? linkedin,
    String? github,
    String? portfolio,
  }) {
    this.state = this.state.copyWith(
      fullName: fullName,
      jobRole: jobRole,
      phone: phone,
      email: email,
      country: country,
      state: state,
      city: city,
      linkedin: linkedin,
      github: github,
      portfolio: portfolio,
    );
  }


  Future<bool> save() async {
    state = state.copyWith(isLoading: true);
    try {
      final activeId = _ref.read(activeResumeIdProvider);
      Resume? resume;
      if (activeId != null && activeId.value.isNotEmpty) {
        resume = await _getResume(activeId);
      }

      final details = PersonalDetails(
        fullName: state.fullName,
        email: state.email,
        phoneNumber: state.phone,
        address: '${state.city}, ${state.state}, ${state.country}',
        jobTitle: state.jobRole,
        website: state.portfolio,
        linkedinUrl: state.linkedin,
        githubUrl: state.github,
      );


      if (resume != null) {
        String updatedTitle = resume.title;
        if (!resume.isTitleManuallySet && state.jobRole.trim().isNotEmpty) {
          updatedTitle = state.jobRole.trim();
        }
        final updatedResume = resume.copyWith(
          title: updatedTitle,
          personalDetails: details,
          updatedAt: DateTime.now(),
        );
        await _updateResume(updatedResume);
      } else {
        final initialTitle = state.jobRole.trim().isNotEmpty
            ? state.jobRole.trim()
            : 'Untitled Resume';
        final newResume = await _ref
            .read(createResumeUseCaseProvider)
            .call(
              Resume(
                id: const ResumeId(''),
                title: initialTitle,
                selectedTemplateId: const TemplateId('ats'),
                personalDetails: details,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
        _ref.read(activeResumeIdProvider.notifier).state = newResume.id;
      }
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
      return true;
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to save personal details: ${e.toString()}',
        );
      }
      return true;
    }
  }
}

final personalDetailsViewModelProvider =
    StateNotifierProvider<PersonalDetailsViewModel, PersonalDetailsState>((
      ref,
    ) {
      ref.watch(activeResumeIdProvider);
      final getResume = ref.watch(getResumeUseCaseProvider);
      final updateResume = ref.watch(updateResumeUseCaseProvider);
      return PersonalDetailsViewModel(ref, getResume, updateResume);
    });
