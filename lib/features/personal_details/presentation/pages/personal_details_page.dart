import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/personal_details/presentation/viewmodels/personal_details_viewmodel.dart';
import 'package:vitafolio/features/personal_details/presentation/widgets/footer_navigation.dart';
import 'package:vitafolio/features/personal_details/presentation/widgets/personal_details_form.dart';
import 'package:vitafolio/features/personal_details/presentation/widgets/resume_progress_stepper.dart';
import 'package:vitafolio/features/personal_details/presentation/widgets/section_header.dart';

/// Personal Details Form Page (Step 2 of 9) matching Stitch UI specs.
class PersonalDetailsPage extends ConsumerStatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  ConsumerState<PersonalDetailsPage> createState() =>
      _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends ConsumerState<PersonalDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _jobRoleController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _linkedinController;
  late TextEditingController _githubController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(personalDetailsViewModelProvider);
    _fullNameController = TextEditingController(text: initialState.fullName);
    _jobRoleController = TextEditingController(text: initialState.jobRole);
    _phoneController = TextEditingController(text: initialState.phone);
    _emailController = TextEditingController(text: initialState.email);
    _linkedinController = TextEditingController(text: initialState.linkedin);
    _githubController = TextEditingController(text: initialState.github);
    _websiteController = TextEditingController(text: initialState.portfolio);
  }

  void _syncControllers(PersonalDetailsState state) {
    if (_fullNameController.text != state.fullName) {
      _fullNameController.text = state.fullName;
    }
    if (_jobRoleController.text != state.jobRole) {
      _jobRoleController.text = state.jobRole;
    }
    if (_phoneController.text != state.phone) {
      _phoneController.text = state.phone;
    }
    if (_emailController.text != state.email) {
      _emailController.text = state.email;
    }
    if (_linkedinController.text != state.linkedin) {
      _linkedinController.text = state.linkedin;
    }
    if (_githubController.text != state.github) {
      _githubController.text = state.github;
    }
    if (_websiteController.text != state.portfolio) {
      _websiteController.text = state.portfolio;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _jobRoleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      debugPrint('PersonalDetails Form validation failed!');
      return;
    }

    ref
        .read(personalDetailsViewModelProvider.notifier)
        .updateField(
          fullName: _fullNameController.text.trim(),
          jobRole: _jobRoleController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          linkedin: _linkedinController.text.trim(),
          github: _githubController.text.trim(),
          portfolio: _websiteController.text.trim(),
        );

    final success = await ref
        .read(personalDetailsViewModelProvider.notifier)
        .save();
    if (!mounted) return;

    if (success) {
      context.push(AppRoutes.profileImage);
    } else {
      final errorMessage =
          ref.read(personalDetailsViewModelProvider).errorMessage ??
          'Failed to save personal details';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _handlePrevious() {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.templates);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(personalDetailsViewModelProvider);

    ref.listen<PersonalDetailsState>(personalDetailsViewModelProvider, (
      prev,
      next,
    ) {
      _syncControllers(next);
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handlePrevious,
        ),
        title: const Text('Personal Details'),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step 2 of 9 Progress Stepper
            const ResumeProgressStepper(currentStepIndex: 1),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      title: 'Tell us about yourself',
                      subtitle:
                          'This information appears at the top of your resume and helps recruiters contact you.',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PersonalDetailsForm(
                      formKey: _formKey,
                      fullNameController: _fullNameController,
                      jobRoleController: _jobRoleController,
                      phoneController: _phoneController,
                      emailController: _emailController,
                      linkedinController: _linkedinController,
                      githubController: _githubController,
                      websiteController: _websiteController,
                      selectedCountry: state.country.isEmpty ? null : state.country,
                      selectedState: state.state.isEmpty ? null : state.state,
                      selectedCity: state.city.isEmpty ? null : state.city,

                      onCountryChanged: (country) {
                        ref
                            .read(personalDetailsViewModelProvider.notifier)
                            .updateField(
                              fullName: _fullNameController.text.trim(),
                              jobRole: _jobRoleController.text.trim(),
                              phone: _phoneController.text.trim(),
                              email: _emailController.text.trim(),
                              linkedin: _linkedinController.text.trim(),
                              github: _githubController.text.trim(),
                              portfolio: _websiteController.text.trim(),
                              country: country,
                              state: '',
                              city: '',
                            );
                      },
                      onStateChanged: (st) {
                        ref
                            .read(personalDetailsViewModelProvider.notifier)
                            .updateField(
                              fullName: _fullNameController.text.trim(),
                              jobRole: _jobRoleController.text.trim(),
                              phone: _phoneController.text.trim(),
                              email: _emailController.text.trim(),
                              linkedin: _linkedinController.text.trim(),
                              github: _githubController.text.trim(),
                              portfolio: _websiteController.text.trim(),
                              state: st,
                              city: '',
                            );
                      },
                      onCityChanged: (city) {
                        ref
                            .read(personalDetailsViewModelProvider.notifier)
                            .updateField(
                              fullName: _fullNameController.text.trim(),
                              jobRole: _jobRoleController.text.trim(),
                              phone: _phoneController.text.trim(),
                              email: _emailController.text.trim(),
                              linkedin: _linkedinController.text.trim(),
                              github: _githubController.text.trim(),
                              portfolio: _websiteController.text.trim(),
                              city: city,
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Navigation Footer
            FooterNavigation(
              onPrevious: _handlePrevious,
              onContinue: _handleContinue,
              isLoading: state.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
