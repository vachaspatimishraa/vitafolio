import 'package:flutter/material.dart';
import '../../workflow/models/workflow_state.dart';

class ContactInformation extends StatelessWidget {
  final ResumePersonalInfo personalInfo;

  const ContactInformation({super.key, required this.personalInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(fontSize: 10);

    final items = [
      if (personalInfo.email.isNotEmpty) personalInfo.email,
      if (personalInfo.phone.isNotEmpty) personalInfo.phone,
      if (personalInfo.address.isNotEmpty) personalInfo.address,
      if (personalInfo.city.isNotEmpty || personalInfo.country.isNotEmpty)
        '${personalInfo.city}${personalInfo.city.isNotEmpty && personalInfo.country.isNotEmpty ? ", " : ""}${personalInfo.country}',
      if (personalInfo.linkedIn.isNotEmpty) personalInfo.linkedIn,
      if (personalInfo.github.isNotEmpty) personalInfo.github,
      if (personalInfo.portfolio.isNotEmpty) personalInfo.portfolio,
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12.0,
      runSpacing: 4.0,
      children: items.map((item) {
        return Text(item, style: textStyle);
      }).toList(),
    );
  }
}
