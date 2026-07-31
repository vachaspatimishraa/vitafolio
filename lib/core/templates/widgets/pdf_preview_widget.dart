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
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Preview Error: ${snapshot.error}'));
        }
        final bytes = snapshot.data;
        if (bytes == null) {
          return const Center(child: Text('No Preview Available'));
        }

        return FutureBuilder<List<PdfRaster>>(
          future: Printing.raster(bytes, pages: [0], dpi: 150).toList(),
          builder: (context, rasterSnapshot) {
            if (rasterSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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

            return Image(image: PdfRasterImage(rasters.first));
          },
        );
      },
    );
  }
}
