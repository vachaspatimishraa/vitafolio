import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/core/fonts/app_font_family.dart';
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';

class CustomFontPage extends ConsumerStatefulWidget {
  const CustomFontPage({super.key});

  @override
  ConsumerState<CustomFontPage> createState() => _CustomFontPageState();
}

class _CustomFontPageState extends ConsumerState<CustomFontPage> {
  late String _selectedFontId;

  @override
  void initState() {
    super.initState();
    final currentResume = ref.read(previewViewModelProvider).resume;
    _selectedFontId = AppFonts.normalizeFontId(currentResume?.fontFamily);
  }

  Future<void> _handleApplyAndPreview() async {
    await ref.read(previewViewModelProvider.notifier).changeFont(_selectedFontId);
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.preview);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF111418) : const Color(0xFF1A1D24);
    final cardColor = isDark ? const Color(0xFF1C222B) : const Color(0xFF222834);
    final cardBorderColor = const Color(0xFF2E3846);
    final selectedBorderColor = const Color(0xFFE89E23);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Custom Font',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: 120,
          ),
          children: [
            // Headline & Subtitle
            const Text(
              'Choose your resume font',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a professional typography style for your resume preview and exports.',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Font List Cards
            ...AppFonts.allFonts.map((font) {
              final isSelected = font.id == _selectedFontId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedFontId = font.id;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? selectedBorderColor
                            : cardBorderColor,
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: selectedBorderColor.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left "Aa" glyph preview
                        SizedBox(
                          width: 44,
                          child: Text(
                            'Aa',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: font.displayName,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Right Font Name and Subtitle Sample
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                font.displayName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: font.displayName,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'John Doe\nSoftware Developer',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                  height: 1.3,
                                  fontFamily: font.displayName,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleApplyAndPreview,
        backgroundColor: const Color(0xFFE89E23),
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.check, size: 20, color: Colors.white),
        label: const Text(
          'Apply & Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
