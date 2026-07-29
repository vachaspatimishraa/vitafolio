import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/resume_model.dart';

final currentResumeProvider = StateProvider<ResumeModel?>((ref) => null);
