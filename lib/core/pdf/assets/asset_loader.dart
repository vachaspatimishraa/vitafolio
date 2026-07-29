import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:pdf/widgets.dart' as pw;

/// Asset Loader responsible for loading, caching, and preparing image assets for PDFs.
class AssetLoader {
  static final AssetLoader instance = AssetLoader._();
  AssetLoader._();

  final Map<String, pw.MemoryImage> _cachedImages = {};

  /// Loads an image asset from the bundle and caches it.
  ///
  /// Supports PNG, JPG, JPEG.
  Future<pw.MemoryImage> loadAssetImage(String path) async {
    if (_cachedImages.containsKey(path)) {
      return _cachedImages[path]!;
    }

    try {
      final bytes = await rootBundle.load(path);
      final image = pw.MemoryImage(bytes.buffer.asUint8List());
      _cachedImages[path] = image;
      return image;
    } catch (e) {
      throw Exception('Failed to load asset image: $path. Error: $e');
    }
  }

  /// Converts a byte array (e.g. from file pickers, local DB, or camera) into a [pw.MemoryImage].
  ///
  /// This prepares the architecture for future profile photo support.
  pw.MemoryImage loadImageFromBytes(Uint8List bytes) {
    return pw.MemoryImage(bytes);
  }

  /// Clears the asset image cache.
  void clearCache() {
    _cachedImages.clear();
  }
}
