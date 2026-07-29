import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class PerformanceMetrics {
  final Duration renderingDuration;
  final Duration exportDuration;
  final int fileSizeBytes;

  const PerformanceMetrics({
    required this.renderingDuration,
    required this.exportDuration,
    required this.fileSizeBytes,
  });

  double get fileSizeMB => fileSizeBytes / (1024 * 1024);
  bool get meetsRenderingTarget => renderingDuration.inMilliseconds <= 2000;
  bool get meetsExportTarget => exportDuration.inMilliseconds <= 3000;
  bool get meetsSizeTarget => fileSizeMB <= 2.0;

  @override
  String toString() {
    return 'PerformanceMetrics('
        'render: ${renderingDuration.inMilliseconds}ms, '
        'export: ${exportDuration.inMilliseconds}ms, '
        'size: ${fileSizeMB.toStringAsFixed(2)}MB)';
  }
}

/// Measures PDF generation performance, export times, and document sizes.
class PerformanceTracker {
  PerformanceTracker._internal();
  static final PerformanceTracker _instance = PerformanceTracker._internal();
  factory PerformanceTracker() => _instance;

  final List<PerformanceMetrics> _history = [];
  Stopwatch? _renderStopwatch;
  Stopwatch? _exportStopwatch;

  void startRenderingTrace() {
    _renderStopwatch = Stopwatch()..start();
  }

  Duration stopRenderingTrace() {
    _renderStopwatch?.stop();
    return _renderStopwatch?.elapsed ?? Duration.zero;
  }

  void startExportTrace() {
    _exportStopwatch = Stopwatch()..start();
  }

  Duration stopExportTrace() {
    _exportStopwatch?.stop();
    return _exportStopwatch?.elapsed ?? Duration.zero;
  }

  void recordMetrics({
    required Duration renderingDuration,
    required Duration exportDuration,
    required int fileSizeBytes,
  }) {
    final metrics = PerformanceMetrics(
      renderingDuration: renderingDuration,
      exportDuration: exportDuration,
      fileSizeBytes: fileSizeBytes,
    );
    _history.add(metrics);

    if (kDebugMode) {
      developer.log('[PdfPerformance] $metrics', name: 'PDF_TRACKER');
    }
  }

  List<PerformanceMetrics> get history => List.unmodifiable(_history);

  PerformanceMetrics? get lastMetrics =>
      _history.isNotEmpty ? _history.last : null;

  void clear() {
    _history.clear();
  }
}
