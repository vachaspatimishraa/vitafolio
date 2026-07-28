import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';

abstract class TemplateRenderer {
  Widget render(WorkflowState resumeData, BuildContext context);
}
