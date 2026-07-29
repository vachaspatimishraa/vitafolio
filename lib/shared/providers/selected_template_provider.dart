import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedTemplateIdProvider = StateProvider<String>(
  (ref) => 'modern_clean',
);
