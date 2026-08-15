import 'package:flutter/material.dart';

/// Searchable dropdown with manual text entry option, anchored directly below the field.
class HybridSearchDropdown extends StatefulWidget {
  final String label;
  final String? initialValue;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final FormFieldValidator<String>? validator;

  const HybridSearchDropdown({
    super.key,
    required this.label,
    this.initialValue,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.validator,
  });


  @override
  State<HybridSearchDropdown> createState() => _HybridSearchDropdownState();
}

class _HybridSearchDropdownState extends State<HybridSearchDropdown> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant HybridSearchDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.initialValue ?? '';
          if (_isOpen) {
            _updateOverlay();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _hideOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  void _showOverlay() {
    if (_isOpen) {
      _updateOverlay();
      return;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _hideOverlay() {
    if (!_isOpen) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    return OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        final queryRaw = _controller.text.trim();
        final query = queryRaw.toLowerCase();
        final filteredItems = widget.items.where((item) {
          if (query.isEmpty) return true;
          return item.toLowerCase().contains(query);
        }).toList();

        final hasExactMatch = filteredItems.any((item) => item.toLowerCase() == query);
        final showAddOption = queryRaw.isNotEmpty && !hasExactMatch;
        final totalItemCount = filteredItems.length + (showAddOption ? 1 : 0);

        final itemHeight = 48.0;
        final maxDropdownHeight = 220.0;
        final contentHeight = totalItemCount == 0
            ? 56.0
            : (totalItemCount * itemHeight > maxDropdownHeight
                  ? maxDropdownHeight
                  : totalItemCount * itemHeight);


        return Positioned(
          width: size.width > 0 ? size.width : 200,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 4.0),
            child: TapRegion(
              onTapOutside: (_) {
                _focusNode.unfocus();
              },
              child: Material(
                elevation: 6.0,
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.surface,
                shadowColor: Colors.black.withValues(alpha: 0.2),
                child: Container(
                  height: contentHeight,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                    ),
                  ),
                  child: totalItemCount == 0
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'No matching results',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: totalItemCount,
                          itemBuilder: (context, index) {
                            if (showAddOption && index == filteredItems.length) {
                              return InkWell(
                                onTap: () {
                                  _controller.text = queryRaw;
                                  widget.onChanged(queryRaw);
                                  _focusNode.unfocus();
                                },
                                child: Container(
                                  height: itemHeight,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 18,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '+ Add "$queryRaw"',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: colorScheme.primary,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final item = filteredItems[index];
                            final isSelected = item == _controller.text;
                            return InkWell(
                              onTap: () {
                                _controller.text = item;
                                widget.onChanged(item);
                                _focusNode.unfocus();
                              },
                              child: Container(
                                height: itemHeight,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                color: isSelected
                                    ? colorScheme.primaryContainer.withValues(
                                        alpha: 0.4,
                                      )
                                    : Colors.transparent,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: colorScheme.onSurface,
                                            ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        size: 18,
                                        color: colorScheme.primary,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        validator: widget.validator,
        decoration: InputDecoration(

          labelText: widget.label,
          errorText: widget.errorText,
          prefixIcon: const Icon(Icons.search, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: Icon(_isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            onPressed: _toggleOverlay,
          ),
        ),
        onChanged: (val) {
          widget.onChanged(val);
          if (_isOpen) {
            _updateOverlay();
          } else {
            _showOverlay();
          }
        },
      ),
    );
  }
}
