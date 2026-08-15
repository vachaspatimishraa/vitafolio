import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Searchable location dropdown component supporting search filter and manual typing.
class HybridLocationDropdown extends StatefulWidget {
  final String label;
  final String? initialValue;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const HybridLocationDropdown({
    super.key,
    required this.label,
    this.initialValue,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<HybridLocationDropdown> createState() => _HybridLocationDropdownState();
}

class _HybridLocationDropdownState extends State<HybridLocationDropdown> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSearchSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusBottomSheet),
        ),
      ),
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filteredItems = widget.items
                .where((item) =>
                    item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: AppSpacing.md,
                left: AppSpacing.md,
                right: AppSpacing.md,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select ${widget.label}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search or type location manually...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusTextField),
                        ),
                      ),
                      onChanged: (query) {
                        setSheetState(() {
                          searchQuery = query;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredItems.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              _controller.text = item;
                              widget.onChanged(item);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.errorText,
        prefixIcon: const Icon(Icons.location_on_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusTextField),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: () => _showSearchSheet(context),
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
