import '../core/security/exception_handler.dart';

/// Crash Recovery Service for managing auto-save state recovery,
/// background process safety, and graceful fallbacks.
class CrashRecoveryService {
  CrashRecoveryService._();

  static final CrashRecoveryService _instance = CrashRecoveryService._();
  static CrashRecoveryService get instance => _instance;

  int? _lastEditingResumeId;
  Map<String, dynamic>? _unsavedStateCache;

  /// Caches transient state during active resume editing
  void cacheTransientState(int resumeId, Map<String, dynamic> stateData) {
    ExceptionHandler.runSafely(() {
      _lastEditingResumeId = resumeId;
      _unsavedStateCache = Map<String, dynamic>.from(stateData);
    }, context: 'CrashRecoveryService.cacheTransientState');
  }

  /// Clears transient state cache after successful database save
  void clearTransientState() {
    _lastEditingResumeId = null;
    _unsavedStateCache = null;
  }

  /// Gets last recovered resume ID if app was interrupted
  int? get lastEditingResumeId => _lastEditingResumeId;

  /// Returns cached unsaved state
  Map<String, dynamic>? get unsavedStateCache => _unsavedStateCache;
}
