import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/certifications/presentation/viewmodels/certifications_viewmodel.dart';
import 'package:vitafolio/features/certifications/presentation/widgets/resume_progress_stepper.dart';
import 'package:vitafolio/shared/widgets/helpers/sticky_bottom_navigation.dart';

/// Dedicated Add or Edit Certification Page (Step 7 of 9).
class AddCertificationPage extends ConsumerStatefulWidget {
  final bool isEditing;
  final MockCertificationItem? initialItem;

  const AddCertificationPage({
    super.key,
    this.isEditing = false,
    this.initialItem,
  });

  @override
  ConsumerState<AddCertificationPage> createState() =>
      _AddCertificationPageState();
}

class _AddCertificationPageState extends ConsumerState<AddCertificationPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _orgController;
  late TextEditingController _credentialIdController;

  DateTime? _issueDate;
  DateTime? _expiryDate;
  bool _doesNotExpire = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;

    _nameController = TextEditingController(text: item?.name ?? '');
    _orgController = TextEditingController(text: item?.organization ?? '');
    _credentialIdController =
        TextEditingController(text: item?.credentialId ?? '');

    if (item != null) {
      _issueDate = _parseDateString(item.issueDate);
      if (item.expiryDate == null || item.expiryDate!.isEmpty) {
        _doesNotExpire = true;
        _expiryDate = null;
      } else {
        _doesNotExpire = false;
        _expiryDate = _parseDateString(item.expiryDate!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orgController.dispose();
    _credentialIdController.dispose();
    super.dispose();
  }

  DateTime? _parseDateString(String dateStr) {
    if (dateStr.isEmpty) return null;
    try {
      final parts = dateStr.split(' ');
      if (parts.length == 2) {
        final monthStr = parts[0];
        final year = int.parse(parts[1]);
        final month = _monthIndex(monthStr);
        return DateTime(year, month);
      }
    } catch (_) {}
    return null;
  }

  int _monthIndex(String monthStr) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final idx = months.indexOf(monthStr);
    return idx != -1 ? idx + 1 : 1;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _handleCancel() {
    FocusScope.of(context).unfocus();
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.certifications);
    }
  }

  Future<void> _selectIssueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _issueDate ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _issueDate = picked;
        if (_expiryDate != null && _expiryDate!.isBefore(picked)) {
          _expiryDate = null;
        }
      });
    }
  }

  Future<void> _selectExpiryDate() async {
    if (_doesNotExpire) return;
    final initial = _expiryDate ?? _issueDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _issueDate ?? DateTime(1970),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  void _handleSave() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_issueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Issue date is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_doesNotExpire && _expiryDate != null && _issueDate != null) {
      if (_expiryDate!.isBefore(_issueDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expiry date cannot be before issue date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() {
      _isSaving = true;
    });

    final issueDateStr = _formatDate(_issueDate!);
    final expiryDateStr =
        (!_doesNotExpire && _expiryDate != null) ? _formatDate(_expiryDate!) : null;

    final id = widget.initialItem?.id ??
        'cert-${DateTime.now().millisecondsSinceEpoch}';

    final newItem = MockCertificationItem(
      id: id,
      name: _nameController.text.trim(),
      organization: _orgController.text.trim(),
      issueDate: issueDateStr,
      expiryDate: expiryDateStr,
      credentialId: _credentialIdController.text.trim().isNotEmpty
          ? _credentialIdController.text.trim()
          : null,
    );

    if (widget.isEditing) {
      ref.read(certificationsViewModelProvider.notifier).updateCertification(newItem);
    } else {
      ref.read(certificationsViewModelProvider.notifier).addCertification(newItem);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditing
              ? 'Certification updated successfully'
              : 'Certification added successfully',
        ),
        duration: const Duration(seconds: 1),
      ),
    );

    _handleCancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleCancel,
        ),
        title: Text(
          widget.isEditing ? 'Edit Certification' : 'Add Certification',
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            // Progress stepper: Step 7 of 9
            const ResumeProgressStepper(currentStepIndex: 8),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading & Description
                      Text(
                        widget.isEditing
                            ? 'Edit Certification'
                            : 'Add Certification',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Showcase a certification, course, or professional credential that strengthens your resume.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Certification Name Field
                      Text(
                        'Certification Name *',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'e.g. Google Associate Cloud Engineer',
                          prefixIcon:
                              const Icon(Icons.workspace_premium_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusTextField),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Certification name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Issuing Organization Field
                      Text(
                        'Issuing Organization *',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _orgController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'e.g. Google Cloud',
                          prefixIcon: const Icon(Icons.business_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusTextField),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Issuing organization is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Issue Date & Expiry Date Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Issue Date Picker
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Issue Date *',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                InkWell(
                                  onTap: _selectIssueDate,
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusTextField),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      hintText: 'Select Date',
                                      prefixIcon: const Icon(
                                          Icons.calendar_today_outlined),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppSpacing.radiusTextField),
                                      ),
                                    ),
                                    child: Text(
                                      _issueDate != null
                                          ? _formatDate(_issueDate!)
                                          : 'Select Date',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: _issueDate != null
                                            ? colorScheme.onSurface
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),

                          // Expiry Date Picker
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expiry Date',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _doesNotExpire
                                        ? colorScheme.onSurface
                                            .withValues(alpha: 0.38)
                                        : colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                InkWell(
                                  onTap: _doesNotExpire ? null : _selectExpiryDate,
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusTextField),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      enabled: !_doesNotExpire,
                                      hintText: _doesNotExpire
                                          ? 'N/A'
                                          : 'Select Date',
                                      prefixIcon: Icon(
                                        Icons.calendar_today_outlined,
                                        color: _doesNotExpire
                                            ? colorScheme.onSurface
                                                .withValues(alpha: 0.38)
                                            : null,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppSpacing.radiusTextField),
                                      ),
                                    ),
                                    child: Text(
                                      _doesNotExpire
                                          ? 'Does not expire'
                                          : (_expiryDate != null
                                              ? _formatDate(_expiryDate!)
                                              : 'Select Date'),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: _doesNotExpire
                                            ? colorScheme.onSurface
                                                .withValues(alpha: 0.38)
                                            : (_expiryDate != null
                                                ? colorScheme.onSurface
                                                : colorScheme.onSurfaceVariant),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Checkbox: This certification does not expire
                      CheckboxListTile(
                        value: _doesNotExpire,
                        onChanged: (val) {
                          setState(() {
                            _doesNotExpire = val ?? false;
                            if (_doesNotExpire) {
                              _expiryDate = null;
                            }
                          });
                        },
                        title: const Text('This certification does not expire'),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Credential ID Field
                      Text(
                        'Credential ID',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _credentialIdController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'e.g. ABC123XYZ',
                          prefixIcon: const Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusTextField),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),

            // Sticky Bottom Navigation Bar (Cancel / Save)
            StickyBottomNavigation(
              secondaryLabel: 'Cancel',
              onSecondaryPressed: _handleCancel,
              primaryLabel: widget.isEditing ? 'Save Changes' : 'Save Certification',
              onPrimaryPressed: _isSaving ? null : _handleSave,
              isPrimaryLoading: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}
