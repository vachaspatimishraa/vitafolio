import 'package:flutter/material.dart';

/// Horizontal scrolling stepper widget for Step 2 (Personal Details).
class ResumeProgressStepper extends StatefulWidget {
  final int currentStepIndex;

  const ResumeProgressStepper({super.key, this.currentStepIndex = 1});

  @override
  State<ResumeProgressStepper> createState() => _ResumeProgressStepperState();
}

class _ResumeProgressStepperState extends State<ResumeProgressStepper> {
  final ScrollController _scrollController = ScrollController();

  static const List<String> _steps = [
    'Template',
    'Personal',
    'Profile Image',
    'Summary',
    'Experience',
    'Projects',
    'Education',
    'Skills',
    'Certifications',
    'Languages',
    'Review & Generate',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToActiveStep();
    });
  }

  @override
  void didUpdateWidget(covariant ResumeProgressStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStepIndex != widget.currentStepIndex) {
      _scrollToActiveStep();
    }
  }

  void _scrollToActiveStep() {
    if (!_scrollController.hasClients) return;
    const double itemEstimatedWidth = 90.0;
    final double targetOffset =
        (widget.currentStepIndex * itemEstimatedWidth) -
        (MediaQuery.of(context).size.width / 2) +
        (itemEstimatedWidth / 2);
    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeColor = colorScheme.primary;
    final completedColor = Colors.green;

    final int percentage =
        (((widget.currentStepIndex + 1) / _steps.length) * 100).round();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STEP ${widget.currentStepIndex + 1} OF ${_steps.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: activeColor,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '$percentage% Completed',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 36,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _steps.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(
                  '›',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              itemBuilder: (context, index) {
                final isSelected = index == widget.currentStepIndex;
                final isPassed = index < widget.currentStepIndex;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPassed)
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: completedColor,
                      )
                    else
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? activeColor
                              : colorScheme.outlineVariant,
                        ),
                      ),
                    const SizedBox(width: 6),
                    Text(
                      _steps[index],
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? activeColor
                            : isPassed
                            ? completedColor
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Divider(
          height: 1,
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}
