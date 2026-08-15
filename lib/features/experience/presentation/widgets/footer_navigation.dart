import 'package:flutter/material.dart';
import 'package:vitafolio/shared/widgets/wizard_bottom_action_bar.dart';

/// Sticky bottom navigation footer for wizard steps.
class FooterNavigation extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onContinue;
  final bool isLoading;

  const FooterNavigation({
    super.key,
    required this.onPrevious,
    required this.onContinue,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return WizardBottomActionBar(
      primaryLabel: 'Continue',
      onPrimaryPressed: onContinue,
      secondaryLabel: 'Previous',
      onSecondaryPressed: onPrevious,
      isLoading: isLoading,
    );
  }
}
