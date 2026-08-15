import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_strings.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';
import 'package:vitafolio/features/home/view_model/home_view_model.dart';
import 'package:vitafolio/shared/widgets/dialogs/delete_dialog.dart';

class ResumeCardMenu extends ConsumerWidget {
  final Resume resume;

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
          value: 'rename',
          child: Row(
            children: [
              Icon(Icons.drive_file_rename_outline, size: 20),
              SizedBox(width: 8),
              Text('Rename'),
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
        ref.read(activeResumeIdProvider.notifier).state = resume.id;
        context.push(AppRoutes.templates);
        break;
      case 'rename':
        _showRenameDialog(context, ref);
        break;
      case 'preview':
        ref.read(activeResumeIdProvider.notifier).state = resume.id;
        context.push(AppRoutes.preview);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref);
        break;
    }
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: resume.title);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rename Resume'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            maxLength: 100,
            decoration: const InputDecoration(
              labelText: 'Resume Name',
              hintText: 'Enter resume name',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a valid resume name';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final newName = controller.text.trim();
                final updatedResume = resume.copyWith(
                  title: newName,
                  isTitleManuallySet: true,
                  updatedAt: DateTime.now(),
                );
                await ref.read(updateResumeUseCaseProvider).call(updatedResume);
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                ref.read(homeViewModelProvider.notifier).refreshResumes();
              }
            },
            child: const Text('Save'),
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
          ref.read(deleteResumeUseCaseProvider).call(resume.id);
          ref.read(homeViewModelProvider.notifier).refreshResumes();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.resumeDeleted)),
          );
        },
      ),
    );
  }
}
