import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:vitafolio/core/docx/docx_export_service.dart';
import 'package:vitafolio/core/pdf/services/pdf_service.dart';
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';

/// Button that presents export options (PDF and Microsoft Word .docx) for the current active resume.
class ExportPdfButton extends ConsumerStatefulWidget {
  const ExportPdfButton({super.key});

  @override
  ConsumerState<ExportPdfButton> createState() => _ExportPdfButtonState();
}

class _ExportPdfButtonState extends ConsumerState<ExportPdfButton> {
  bool _isExporting = false;

  void _showExportOptionsSheet() {
    final previewState = ref.read(previewViewModelProvider);
    final targetResume = previewState.resume;

    if (targetResume == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active resume to export.')),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Export Resume',
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose your preferred document format',
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 20),
              // PDF Option
              _buildExportOptionTile(
                context: ctx,
                icon: Icons.picture_as_pdf_rounded,
                iconColor: const Color(0xFFE53935),
                title: 'PDF Document (.pdf)',
                subtitle: 'High-quality printable A4 multipage document',
                onTap: () {
                  Navigator.pop(ctx);
                  _exportPdf(targetResume);
                },
              ),
              const SizedBox(height: 12),
              // Word DOCX Option
              _buildExportOptionTile(
                context: ctx,
                icon: Icons.description_rounded,
                iconColor: const Color(0xFF1976D2),
                title: 'Microsoft Word (.docx)',
                subtitle: 'Editable document compatible with Word & Google Docs',
                onTap: () {
                  Navigator.pop(ctx);
                  _exportDocx(targetResume);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportOptionTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportPdf(Resume targetResume) async {
    try {
      setState(() {
        _isExporting = true;
      });

      final pdfService = PdfService();
      final bytes = await pdfService.generatePdfFromDomain(targetResume);

      final tempDir = await getTemporaryDirectory();
      final safeFileName = targetResume.title.replaceAll(RegExp(r'\s+'), '_');
      final file = File('${tempDir.path}/$safeFileName.pdf');
      await file.writeAsBytes(bytes, flush: true);

      await Share.shareXFiles([XFile(file.path)], text: targetResume.title);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to export PDF: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<void> _exportDocx(Resume targetResume) async {
    try {
      setState(() {
        _isExporting = true;
      });

      const docxService = DocxExportService();
      final bytes = docxService.generateDocx(targetResume);

      final tempDir = await getTemporaryDirectory();
      final safeFileName = targetResume.title.replaceAll(RegExp(r'\s+'), '_');
      final file = File('${tempDir.path}/$safeFileName.docx');
      await file.writeAsBytes(bytes, flush: true);

      await Share.shareXFiles([XFile(file.path)], text: targetResume.title);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to export Word (.docx): $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isExporting ? null : _showExportOptionsSheet,
      icon: _isExporting
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : const Icon(Icons.download),
      label: Text(_isExporting ? 'Exporting...' : 'Export Resume'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE89E23),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}

