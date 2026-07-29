import 'package:flutter/material.dart';

class ValidationDialog extends StatelessWidget {
  final List<String> errors;

  const ValidationDialog({super.key, required this.errors});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Missing Information'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please complete the following required fields before proceeding to preview:',
            ),
            const SizedBox(height: 16),
            ...errors.map(
              (error) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(error)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}
