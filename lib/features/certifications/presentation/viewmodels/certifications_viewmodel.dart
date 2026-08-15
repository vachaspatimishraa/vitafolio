import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/resume/domain/entities/certification.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';

class MockCertificationItem {
  final String id;
  final String name;
  final String organization;
  final String issueDate;
  final String? expiryDate;
  final String? credentialId;

  const MockCertificationItem({
    required this.id,
    required this.name,
    required this.organization,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
  });

  factory MockCertificationItem.fromDomain(Certification domain) {
    return MockCertificationItem(
      id: domain.id,
      name: domain.name,
      organization: domain.organization,
      issueDate: domain.issueDate,
      expiryDate: domain.expiryDate,
      credentialId: domain.credentialId,
    );
  }

  Certification toDomain() {
    return Certification(
      id: id,
      name: name,
      organization: organization,
      issueDate: issueDate,
      expiryDate: expiryDate,
      credentialId: credentialId,
    );
  }
}

class CertificationsListState {
  final List<MockCertificationItem> certifications;
  final bool isLoading;
  final String? errorMessage;

  const CertificationsListState({
    this.certifications = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CertificationsListState copyWith({
    List<MockCertificationItem>? certifications,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CertificationsListState(
      certifications: certifications ?? this.certifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class CertificationsViewModel extends StateNotifier<CertificationsListState> {
  final Ref _ref;
  final GetResume _getResume;
  final UpdateResume _updateResume;

  CertificationsViewModel(this._ref, this._getResume, this._updateResume)
      : super(const CertificationsListState()) {
    _load();
  }

  Future<void> _load() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final resume = await _getResume(activeId);
      if (resume != null) {
        state = state.copyWith(
          certifications: resume.certifications
              .map(MockCertificationItem.fromDomain)
              .toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load certifications',
      );
    }
  }

  Future<void> _save() async {
    final activeId = _ref.read(activeResumeIdProvider);
    if (activeId == null) return;

    try {
      final resume = await _getResume(activeId);
      if (resume != null) {
        final updatedResume = resume.copyWith(
          certifications: state.certifications.map((c) => c.toDomain()).toList(),
          updatedAt: DateTime.now(),
        );
        await _updateResume(updatedResume);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to save certifications');
    }
  }

  void deleteCertification(String id) {
    state = state.copyWith(
      certifications:
          state.certifications.where((item) => item.id != id).toList(),
    );
    _save();
  }

  void addCertification(MockCertificationItem item) {
    state = state.copyWith(
      certifications: [...state.certifications, item],
    );
    _save();
  }

  void updateCertification(MockCertificationItem item) {
    state = state.copyWith(
      certifications: state.certifications
          .map((c) => c.id == item.id ? item : c)
          .toList(),
    );
    _save();
  }
}

final certificationsViewModelProvider = StateNotifierProvider.autoDispose<
    CertificationsViewModel, CertificationsListState>((ref) {
  ref.watch(activeResumeIdProvider);
  final getResume = ref.watch(getResumeUseCaseProvider);
  final updateResume = ref.watch(updateResumeUseCaseProvider);
  return CertificationsViewModel(ref, getResume, updateResume);
});
