import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/professional_summary/presentation/viewmodels/professional_summary_viewmodel.dart';
import 'package:vitafolio/features/professional_summary/presentation/widgets/footer_navigation.dart';
import 'package:vitafolio/features/professional_summary/presentation/widgets/summary_editor_card.dart';
import 'package:vitafolio/shared/widgets/helpers/resume_progress_stepper.dart';

/// Screen for entering professional summary matching Stitch design.
class ProfessionalSummaryPage extends ConsumerStatefulWidget {
  const ProfessionalSummaryPage({super.key});

  @override
  ConsumerState<ProfessionalSummaryPage> createState() =>
      _ProfessionalSummaryPageState();
}

class _ProfessionalSummaryPageState
    extends ConsumerState<ProfessionalSummaryPage> {
  late TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(professionalSummaryViewModelProvider);
    _summaryController = TextEditingController(text: initialState.summary);
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  void _handlePrevious() {
    if (Navigator.of(context).canPop()) {
      if (context.mounted) {
        context.pop();
      }
    } else {
      context.go(AppRoutes.profileImage);
    }
  }

  Future<void> _handleContinue() async {
    ref
        .read(professionalSummaryViewModelProvider.notifier)
        .setSummary(_summaryController.text);
    await ref.read(professionalSummaryViewModelProvider.notifier).save();
    if (mounted) {
      context.push(AppRoutes.experience);
    }
  }

  void _handleUseSample() {
    ref
        .read(professionalSummaryViewModelProvider.notifier)
        .useSampleSummary();
    final updatedSummary =
        ref.read(professionalSummaryViewModelProvider).summary;
    _summaryController.text = updatedSummary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(professionalSummaryViewModelProvider);

    if (_summaryController.text != state.summary) {
      _summaryController.text = state.summary;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handlePrevious,
        ),
        title: const Text(
          'Professional Summary',
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
            // Step 4 of 11 Progress Stepper (Index 3)
            const ResumeProgressStepper(currentStepIndex: 3),

            // Scrollable Content Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Title & Subtitle
                    Text(
                      'Introduce Yourself',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Write a short professional summary that highlights your experience, strengths, and career goals.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Summary Editor Card with live character counter & sample trigger
                    SummaryEditorCard(
                      controller: _summaryController,
                      onChanged: (text) {
                        ref
                            .read(professionalSummaryViewModelProvider.notifier)
                            .setSummary(text);
                      },
                      onUseSample: _handleUseSample,
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
