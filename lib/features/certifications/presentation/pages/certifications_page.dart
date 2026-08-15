import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/certifications/presentation/viewmodels/certifications_viewmodel.dart';
import 'package:vitafolio/features/certifications/presentation/widgets/certification_card.dart';
import 'package:vitafolio/features/certifications/presentation/widgets/empty_certification_state.dart';
import 'package:vitafolio/features/certifications/presentation/widgets/footer_action_bar.dart';
import 'package:vitafolio/features/certifications/presentation/widgets/resume_progress_stepper.dart';
import 'package:vitafolio/shared/widgets/section_add_button.dart';

/// Certifications screen assembly (Step 7 of 9) utilizing reusable Antigravity components.
class CertificationsPage extends ConsumerWidget {
  const CertificationsPage({super.key});

  void _handlePrevious(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.skills);
    }
  }

  void _handleContinue(BuildContext context) {
    context.push(AppRoutes.languages);
  }

  void _handleAddCertification(BuildContext context) {
    context.push(AppRoutes.addCertification);
  }

  void _handleEditCertification(
    BuildContext context,
    MockCertificationItem item,
  ) {
    context.push(
      AppRoutes.addCertification,
      extra: {
        'isEditing': true,
        'item': item,
      },
    );
  }

  void _handleDeleteCertification(BuildContext context, WidgetRef ref, String id) {
    ref.read(certificationsViewModelProvider.notifier).deleteCertification(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Certification removed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(certificationsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handlePrevious(context),
        ),
        title: const Text(
          'Certifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
            // Resume Progress Stepper (Step 7 of 9)
            const ResumeProgressStepper(currentStepIndex: 8),

            // Main Content Area
            Expanded(
              child: state.certifications.isEmpty
                  ? EmptyCertificationState(onAdd: () => _handleAddCertification(context))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          Text(
                            'Certifications & Licenses',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Showcase industry certifications, courses, and professional credentials.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Certification Card List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.certifications.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final cert = state.certifications[index];
                              return CertificationCard(
                                name: cert.name,
                                organization: cert.organization,
                                issueDate: cert.issueDate,
                                expiryDate: cert.expiryDate,
                                credentialId: cert.credentialId,
                                onEdit: () =>
                                    _handleEditCertification(context, cert),
                                onDelete: () => _handleDeleteCertification(
                                  context,
                                  ref,
                                  cert.id,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          SectionAddButton(
                            label: 'Add Certification',
                            onPressed: () => _handleAddCertification(context),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),

            // Sticky Footer Navigation Action Bar
            FooterActionBar(
              onPrevious: () => _handlePrevious(context),
              onContinue: () => _handleContinue(context),
              isLoading: state.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
