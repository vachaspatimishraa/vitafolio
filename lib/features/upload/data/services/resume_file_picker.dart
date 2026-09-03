import 'dart:io';
import 'package:file_picker/file_picker.dart';

/// Clean Architecture abstraction for file picking operations.
abstract class ResumeFilePicker {
  Future<PickedResumeFile?> pickResumeFile();
}

class PickedResumeFile {
  final String? path;
  final String name;
  final double sizeInMB;
  final List<int>? bytes;

  const PickedResumeFile({
    this.path,
    required this.name,
    required this.sizeInMB,
    this.bytes,
  });
}

/// Production implementation using native system document file picker.
class ProductionResumeFilePicker implements ResumeFilePicker {
  const ProductionResumeFilePicker();

  @override
  Future<PickedResumeFile?> pickResumeFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg', 'webp'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final platformFile = result.files.first;
    final sizeInMB = platformFile.size / (1024 * 1024);

    List<int>? fileBytes = platformFile.bytes;
    if ((fileBytes == null || fileBytes.isEmpty) && platformFile.path != null) {
      try {
        final f = File(platformFile.path!);
        if (f.existsSync()) {
          fileBytes = await f.readAsBytes();
        }
      } catch (_) {}
    }

    return PickedResumeFile(
      path: platformFile.path,
      name: platformFile.name,
      sizeInMB: sizeInMB,
      bytes: fileBytes,
    );
  }
}
