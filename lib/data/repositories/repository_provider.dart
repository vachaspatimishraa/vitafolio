import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../repositories/resume_repository.dart';
import '../repositories/resume_repository_impl.dart';

final resumeRepositoryProvider = Provider<ResumeRepository>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  final isar = ref.watch(isarProvider);
  return ResumeRepositoryImpl(isarService, isar);
});
