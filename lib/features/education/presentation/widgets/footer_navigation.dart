import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 54,
              child: OutlinedButton(
                onPressed: isLoading ? null : onPrevious,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: BorderSide(color: colorScheme.outline),
                ),
                child: Text(
                  'Previous',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: isLoading ? null : onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: colorScheme.onPrimary,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
