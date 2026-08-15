import 'package:flutter/material.dart';
import 'package:vitafolio/data/models/embedded/personal_information.dart';

class ContactInformation extends StatelessWidget {
  final PersonalInformation personalInfo;

  const ContactInformation({super.key, required this.personalInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(fontSize: 10);

    final items = [
      if (personalInfo.phone?.isNotEmpty == true) personalInfo.phone!,
      if (personalInfo.email?.isNotEmpty == true) personalInfo.email!,
      if (personalInfo.linkedIn?.isNotEmpty == true) personalInfo.linkedIn!,
      if (personalInfo.github?.isNotEmpty == true) personalInfo.github!,
      if (personalInfo.portfolioWebsite?.isNotEmpty == true)
        personalInfo.portfolioWebsite!,
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text('|', style: textStyle),
          ),
        );
      }
      children.add(Text(items[i], style: textStyle));
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 0.0,
      runSpacing: 4.0,
      children: children,
    );
  }
}
