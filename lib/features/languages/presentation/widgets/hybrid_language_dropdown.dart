import 'package:flutter/material.dart';
import 'package:vitafolio/features/personal_details/presentation/widgets/hybrid_search_dropdown.dart';

const List<String> kDefaultLanguagesList = [
  'English',
  'Hindi',
  'Gujarati',
  'German',
  'French',
  'Spanish',
  'Japanese',
  'Chinese',
  'Arabic',
  'Bengali',
  'Marathi',
  'Telugu',
  'Tamil',
  'Urdu',
  'Kannada',
  'Odia',
  'Malayalam',
  'Punjabi',
  'Russian',
  'Portuguese',
  'Italian',
];

/// Searchable hybrid language dropdown supporting inline anchored overlay search and manual entry.
class HybridLanguageDropdown extends StatelessWidget {
  final String label;
  final String? initialValue;
  final List<String> languages;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const HybridLanguageDropdown({
    super.key,
    this.label = 'Language',
    this.initialValue,
    this.languages = kDefaultLanguagesList,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return HybridSearchDropdown(
      label: label,
      initialValue: initialValue,
      items: languages,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}

