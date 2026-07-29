import '../../templates/models/template_model.dart';
import '../../templates/renderers/template_renderer.dart';
import '../../templates/repository/template_repository.dart';

class RendererFactory {
  final TemplateRepository _templateRepository;

  RendererFactory({TemplateRepository? templateRepository})
    : _templateRepository = templateRepository ?? TemplateRepository();

  TemplateRenderer getRenderer(String? templateId) {
    if (templateId != null && templateId.isNotEmpty) {
      final template = _templateRepository.getTemplateById(templateId);
      if (template != null) {
        return template.renderer;
      }
    }
    // Safe fallback to default template (first in repository)
    return TemplateRepository.templates.first.renderer;
  }

  TemplateModel getTemplate(String? templateId) {
    if (templateId != null && templateId.isNotEmpty) {
      final template = _templateRepository.getTemplateById(templateId);
      if (template != null) {
        return template;
      }
    }
    return TemplateRepository.templates.first;
  }
}
