import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:vitafolio/core/pdf/services/pdf_service.dart';
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';

/// Button that exports the current domain resume as a PDF using the selected template.
class ExportPdfButton extends ConsumerStatefulWidget {
  const ExportPdfButton({super.key});

  @override
  ConsumerState<ExportPdfButton> createState() => _ExportPdfButtonState();
}

class _ExportPdfButtonState extends ConsumerState<ExportPdfButton> {
  bool _isExporting = false;

  Future<void> _exportPdf() async {
    final previewState = ref.read(previewViewModelProvider);
    final targetResume = previewState.resume;

    if (targetResume == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active resume to export.')),
      );
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isExporting ? null : _exportPdf,
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
      label: Text(_isExporting ? 'Exporting...' : 'Export PDF'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
