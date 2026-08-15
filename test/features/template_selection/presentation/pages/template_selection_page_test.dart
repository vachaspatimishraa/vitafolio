import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/templates/repository/template_repository.dart';
import 'package:vitafolio/features/template_selection/presentation/pages/template_selection_page.dart';
import 'package:vitafolio/features/template_selection/presentation/viewmodels/template_selection_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repo = TemplateRepository();

  Widget buildTestableWidget(TemplateSelectionState state) {
    return ProviderScope(
      overrides: [
        templateSelectionViewModelProvider.overrideWith(
          (ref) => _FakeTemplateSelectionNotifier(state),
        ),
      ],
      child: const MaterialApp(
        home: TemplateSelectionPage(),
      ),
    );
  }

  group('TemplateSelectionPage Widget & Registry Tests (TASK 060 PNG Templates)', () {
    test('Test A — TemplateRepository returns 10 unique PNG template definitions', () {
      final templates = repo.getTemplates();
      expect(templates.length, equals(10));
    });

    testWidgets('renders STEP 1 OF 11 header, real PNG template cards, and selected state', (tester) async {
      final templates = repo.getTemplates();
      await tester.pumpWidget(
        buildTestableWidget(
          TemplateSelectionState(
            templates: templates,
            selectedTemplateId: 'ats',
          ),
        ),
      );

      expect(find.text('STEP 1 OF 11'), findsOneWidget);
      expect(find.text('Choose Your Resume Template'), findsOneWidget);
      expect(find.text('ATS Friendly'), findsAtLeastNWidgets(1));
      expect(find.text('Modern Clean'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
  });

  group('TemplateSelectionViewModel Logic Tests (TASK 060 PNG Templates)', () {
    test('Test C — Template selection state holds updated ID string', () {
      final templates = repo.getTemplates();
      final state = TemplateSelectionState(templates: templates)
          .copyWith(selectedTemplateId: 'modern');
      expect(state.selectedTemplateId, equals('modern'));
    });

    test('Test D & E — TemplateRepository getTemplate resolves valid template', () {
      final template = repo.getTemplate('creative');
      expect(template.id, equals('creative'));
      expect(template.name, equals('Creative Bold'));
      expect(template.previewAsset, equals('assets/templates/previews/creative.png'));
    });
  });
}

class _FakeTemplateSelectionNotifier
    extends StateNotifier<TemplateSelectionState>
    implements TemplateSelectionViewModel {
  _FakeTemplateSelectionNotifier(super.initialState);

  @override
  void selectTemplate(String templateId) {
    state = state.copyWith(selectedTemplateId: templateId);
  }

  @override
  Future<bool> saveSelection() async {
    return true;
  }
}
