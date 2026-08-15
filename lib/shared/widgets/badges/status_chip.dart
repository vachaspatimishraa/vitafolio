import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

enum StatusChipType {
  atsFriendly,
  remote,
  internship,
  fullTime,
}

/// Vitafolio v2.0 Status Chip
class StatusChip extends StatelessWidget {
  final StatusChipType type;
  final String? customLabel;

  const StatusChip({
    super.key,
    required this.type,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    IconData icon;


    switch (type) {
      case StatusChipType.atsFriendly:
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF059669);
        label = customLabel ?? 'ATS Friendly';
        icon = Icons.verified_rounded;
        break;
      case StatusChipType.remote:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        label = customLabel ?? 'Remote';
        icon = Icons.public_rounded;
        break;
      case StatusChipType.internship:
        bg = const Color(0xFFFFEDD5);
        fg = const Color(0xFFEA580C);
        label = customLabel ?? 'Internship';
        icon = Icons.school_rounded;
        break;
      case StatusChipType.fullTime:
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF047857);
        label = customLabel ?? 'Full Time';
        icon = Icons.work_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),

          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
