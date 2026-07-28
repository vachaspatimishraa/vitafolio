import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/workflow/view_model/workflow_view_model.dart';
import '../../features/workflow/models/workflow_state.dart';

final workflowProvider = Provider<WorkflowState>((ref) {
  return ref.watch(workflowViewModelProvider);
});
