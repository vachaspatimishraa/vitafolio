import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/features/certifications/presentation/widgets/certification_badge.dart';

/// Card widget rendering certification details including provider badge, dates, credential ID, and options menu.
class CertificationCard extends StatelessWidget {
  final String name;
  final String organization;
  final String issueDate;
  final String? expiryDate;
  final String? credentialId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CertificationCard({
    super.key,
    required this.name,
    required this.organization,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Certification Name & Options Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          Text(
                            organization,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          CertificationBadge(text: organization),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: onEdit,
                  tooltip: 'Edit Certification',
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),

            // Issue Date & Expiry Date Row
            Row(
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Issued $issueDate',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (expiryDate != null && expiryDate!.isNotEmpty) ...[
                  Text(
                    ' • Expires $expiryDate',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ] else ...[
                  Text(
                    ' • No Expiration',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),

            // Optional Credential ID
            if (credentialId != null && credentialId!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(
                    Icons.badge_outlined,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Credential ID: $credentialId',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
