import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/features/home/widgets/greeting_section.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GreetingSection(),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
