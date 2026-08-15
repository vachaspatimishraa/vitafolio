import 'package:flutter/material.dart';

/// Material 3 Reusable Hybrid Search Field supporting inline auto-suggest
/// and custom manual text entry fallback without external search screens.
class AppHybridSearchField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? initialValue;
  final List<String> suggestions;
  final ValueChanged<String> onSelected;
  final IconData? prefixIcon;
  final String? errorText;

  const AppHybridSearchField({
    super.key,
    required this.label,
    this.hintText,
    this.initialValue,
    this.suggestions = const [],
    required this.onSelected,
    this.prefixIcon = Icons.search,
    this.errorText,
  });

  @override
  State<AppHybridSearchField> createState() => _AppHybridSearchFieldState();
}

class _AppHybridSearchFieldState extends State<AppHybridSearchField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant AppHybridSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitValue(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      widget.onSelected(trimmed);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RawAutocomplete<String>(
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.trim();
        if (query.isEmpty) {
          return widget.suggestions;
        }

        final matches = widget.suggestions
            .where((s) => s.toLowerCase().contains(query.toLowerCase()))
            .toList();

        // If query does not match any exact suggestion, append explicit Custom Option
        final exactMatchExists = widget.suggestions.any(
          (s) => s.toLowerCase() == query.toLowerCase(),
        );

        if (!exactMatchExists && query.isNotEmpty) {
          matches.add('Add "$query" (Custom)');
        }

        return matches;
      },
      onSelected: (String selection) {
        if (selection.startsWith('Add "') && selection.endsWith('" (Custom)')) {
          final customText =
              selection.substring(5, selection.length - 10).trim();
          _submitValue(customText);
        } else {
          _submitValue(selection);
        }
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hintText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Add item',
              onPressed: () => _submitValue(textEditingController.text),
            ),
          ),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: _submitValue,
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.surfaceContainerHigh,
            child: Container(
              width: MediaQuery.of(context).size.width - 48,
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  final isCustomOption = option.startsWith('Add "') && option.endsWith('" (Custom)');

                  return ListTile(
                    dense: true,
                    leading: Icon(
                      isCustomOption ? Icons.add : Icons.search,
                      color: isCustomOption ? colorScheme.primary : colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    title: Text(
                      option,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isCustomOption ? colorScheme.primary : colorScheme.onSurface,
                        fontWeight: isCustomOption ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
