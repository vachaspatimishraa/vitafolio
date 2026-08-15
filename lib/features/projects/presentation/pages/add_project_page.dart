import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/features/projects/presentation/viewmodels/projects_viewmodel.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/shared/widgets/helpers/resume_progress_stepper.dart';

class AddProjectPage extends ConsumerStatefulWidget {
  final bool isEditing;
  final Project? initialProject;

  const AddProjectPage({
    super.key,
    this.isEditing = false,
    this.initialProject,
  });

  @override
  ConsumerState<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends ConsumerState<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _descriptionController;
  late TextEditingController _projectUrlController;
  late TextEditingController _techInputController;

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isOngoing = false;
  List<String> _technologies = [];
  String? _dateError;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProject;
    _nameController = TextEditingController(text: p?.name ?? '');
    _roleController = TextEditingController(text: p?.role ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _projectUrlController = TextEditingController(text: p?.projectUrl ?? '');
    _techInputController = TextEditingController();

    _startDate = p?.startDate;
    _endDate = p?.endDate;
    _isOngoing = p?.isOngoing ?? false;
    _technologies = p?.technologies != null ? List.from(p!.technologies) : [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _descriptionController.dispose();
    _projectUrlController.dispose();
    _techInputController.dispose();
    super.dispose();
  }

  void _addTechnology() {
    final text = _techInputController.text.trim();
    if (text.isNotEmpty && !_technologies.contains(text)) {
      setState(() {
        _technologies.add(text);
        _techInputController.clear();
      });
    }
  }

  void _removeTechnology(String tech) {
    setState(() {
      _technologies.remove(tech);
    });
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _validateDates();
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_isOngoing) return;
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _validateDates();
      });
    }
  }

  bool _validateDates() {
    if (_startDate != null && _endDate != null && !_isOngoing) {
      if (_endDate!.isBefore(_startDate!)) {
        setState(() {
          _dateError = 'End date cannot be earlier than start date';
        });
        return false;
      }
    }
    setState(() {
      _dateError = null;
    });
    return true;
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    final urlRegExp = RegExp(
      r'^(https?:\/\/)?([\w\d-]+\.)+[\w\d]{2,}(\/.*)?$',
      caseSensitive: false,
    );
    if (!urlRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid URL (e.g. https://github.com/user/project)';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateDates()) return;

    final id = widget.isEditing && widget.initialProject != null
        ? widget.initialProject!.id
        : 'proj_${DateTime.now().millisecondsSinceEpoch}';

    final project = Project(
      id: id,
      name: _nameController.text.trim(),
      role: _roleController.text.trim(),
      description: _descriptionController.text.trim(),
      technologies: _technologies,
      projectUrl: _projectUrlController.text.trim(),
      startDate: _startDate,
      endDate: _isOngoing ? null : _endDate,
      isOngoing: _isOngoing,
    );

    final viewModel = ref.read(projectsViewModelProvider.notifier);
    if (widget.isEditing) {
      await viewModel.updateProject(project);
    } else {
      await viewModel.addProject(project);
    }

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.isEditing ? 'Edit Project' : 'Add Project',
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
            const ResumeProgressStepper(currentStepIndex: 5),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Project Name *',
                          hintText: 'e.g. Vitafolio Mobile App',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Project name is required'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Role
                      TextFormField(
                        controller: _roleController,
                        decoration: const InputDecoration(
                          labelText: 'Your Role / Position',
                          hintText: 'e.g. Lead Developer, UI/UX Designer',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description *',
                          hintText:
                              'Describe the purpose of the project, features, and your contributions...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Description is required'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Project URL
                      TextFormField(
                        controller: _projectUrlController,
                        keyboardType: TextInputType.url,
                        decoration: const InputDecoration(
                          labelText: 'Project URL',
                          hintText: 'e.g. https://github.com/username/project',
                          prefixIcon: Icon(Icons.link),
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateUrl,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Technologies Used
                      Text(
                        'Technologies Used',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _techInputController,
                              decoration: const InputDecoration(
                                hintText: 'Add technology (e.g. Flutter)',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onSubmitted: (_) => _addTechnology(),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          IconButton.filled(
                            onPressed: _addTechnology,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      if (_technologies.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: _technologies.map((tech) {
                            return Chip(
                              label: Text(tech),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () => _removeTechnology(tech),
                              backgroundColor: colorScheme.primaryContainer,
                              labelStyle: TextStyle(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),

                      // Currently Working Switch
                      SwitchListTile(
                        title: const Text('Currently Working on this Project'),
                        value: _isOngoing,
                        onChanged: (val) {
                          setState(() {
                            _isOngoing = val;
                            if (val) _endDate = null;
                            _validateDates();
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Start & End Dates
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _selectStartDate,
                              icon: const Icon(Icons.calendar_today, size: 18),
                              label: Text(
                                _startDate != null
                                    ? dateFormat.format(_startDate!)
                                    : 'Start Date',
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isOngoing ? null : _selectEndDate,
                              icon: const Icon(Icons.calendar_today, size: 18),
                              label: Text(
                                _isOngoing
                                    ? 'Present'
                                    : (_endDate != null
                                        ? dateFormat.format(_endDate!)
                                        : 'End Date'),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_dateError != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _dateError!,
                          style: TextStyle(
                            color: colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: _save,
                          child: Text(
                            widget.isEditing ? 'Save Changes' : 'Save Project',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
