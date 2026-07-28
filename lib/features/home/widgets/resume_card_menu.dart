import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/router.dart';
import '../../../data/models/resume/resume_model.dart';
import '../../../shared/widgets/dialogs/delete_dialog.dart';
import '../../workflow/view_model/workflow_view_model.dart';
import '../view_model/home_view_model.dart';

class ResumeCardMenu extends ConsumerWidget {
  final ResumeModel resume;

  const ResumeCardMenu({super.key, required this.resume});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
      onSelected: (value) => _handleMenuAction(context, ref, value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: 8),
              Text(AppStrings.edit),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'preview',
          child: Row(
            children: [
              Icon(Icons.visibility_outlined, size: 20),
              SizedBox(width: 8),
              Text(AppStrings.preview),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              Icon(Icons.copy_outlined, size: 20),
              SizedBox(width: 8),
              Text(AppStrings.duplicate),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'rename',
          child: Row(
            children: [
              Icon(Icons.drive_file_rename_outline, size: 20),
              SizedBox(width: 8),
              Text(AppStrings.rename),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20, color: colorScheme.error),
              const SizedBox(width: 8),
              Text(
                AppStrings.delete,
                style: TextStyle(color: colorScheme.error),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        ref.read(workflowViewModelProvider.notifier).loadExistingResume(resume);
        context.pushNamed(AppRoutes.editor);
        break;
      case 'preview':
        ref.read(workflowViewModelProvider.notifier).loadExistingResume(resume);
        context.pushNamed(AppRoutes.preview);
        break;
      case 'duplicate':
        _showDuplicateConfirmation(context, ref);
        break;
      case 'rename':
        _showRenameDialog(context, ref);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref);
        break;
    }
  }

  void _showDuplicateConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duplicate Resume'),
        content: Text('Create a copy of "${resume.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(homeViewModelProvider.notifier).duplicateResume(resume.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.resumeDuplicated)),
              );
            },
            child: const Text(AppStrings.duplicate),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: resume.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.renameResume),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.renameHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: AppStrings.resumeName,
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != resume.title) {
                Navigator.of(context).pop();
                ref.read(homeViewModelProvider.notifier).renameResume(resume.id, newName);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.resumeRenamed)),
                );
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => DeleteDialog(
        title: AppStrings.deleteResumeTitle,
        message: AppStrings.deleteResumeMessage,
        deleteLabel: AppStrings.delete,
        cancelLabel: AppStrings.cancel,
        onDelete: () {
          ref.read(homeViewModelProvider.notifier).deleteResume(resume.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.resumeDeleted)),
          );
        },
      ),
    );
  }
}
