import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/core/database/database_provider.dart';
import 'package:vitafolio/data/repositories/resume_repository.dart';
import 'package:vitafolio/data/repositories/resume_repository_impl.dart';

final resumeRepositoryProvider = Provider<ResumeRepository>((ref) {
  final dataSource = ref.watch(isarDataSourceProvider);
  final isar = ref.watch(isarProvider);
  return ResumeRepositoryImpl(dataSource, isar);
});
