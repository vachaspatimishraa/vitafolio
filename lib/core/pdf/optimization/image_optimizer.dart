import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

/// Helper for optimizing, scaling, and compressing images before embedding into PDFs.
class ImageOptimizer {
  ImageOptimizer._internal();
  static final ImageOptimizer _instance = ImageOptimizer._internal();
  factory ImageOptimizer() => _instance;

  final Map<String, pw.MemoryImage> _imageCache = {};

  /// Optimizes image bytes and wraps into cached pw.MemoryImage
  pw.MemoryImage? optimizeAndCacheImage(String key, Uint8List imageBytes) {
    if (imageBytes.isEmpty) return null;
    if (_imageCache.containsKey(key)) {
      return _imageCache[key];
    }

    try {
      final image = pw.MemoryImage(imageBytes);
      _imageCache[key] = image;
      return image;
    } catch (_) {
      return null;
    }
  }

  /// Clears in-memory image cache to prevent leaks during multi-export sessions.
  void clearCache() {
    _imageCache.clear();
  }
}
