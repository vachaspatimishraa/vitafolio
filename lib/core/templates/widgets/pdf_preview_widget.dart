import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewWidget extends StatelessWidget {
  final pw.Document pdf;

  const PdfPreviewWidget({super.key, required this.pdf});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: pdf.save(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Preview Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        final bytes = snapshot.data;
        if (bytes == null) {
          return const Center(child: Text('No Preview Available'));
        }

        return FutureBuilder<List<PdfRaster>>(
          future: Printing.raster(bytes, dpi: 150).toList(),
          builder: (context, rasterSnapshot) {
            if (rasterSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (rasterSnapshot.hasError) {
              return Center(
                child: Text('Raster Error: ${rasterSnapshot.error}'),
              );
            }
            final rasters = rasterSnapshot.data;
            if (rasters == null || rasters.isEmpty) {
              return const Center(child: Text('Could not render page'));
            }

            const a4AspectRatio = 1 / 1.4142; // A4 aspect ratio (width / height)

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < rasters.length; i++) ...[
                  if (i > 0) const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.14),
                          blurRadius: 16,
                          spreadRadius: 1,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: AspectRatio(
                        aspectRatio: a4AspectRatio,
                        child: Image(
                          image: PdfRasterImage(rasters[i]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  if (rasters.length > 1) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Page ${i + 1} of ${rasters.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            );
          },
        );
      },
    );
  }
}
