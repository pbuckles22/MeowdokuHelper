import 'services/ffi_service.dart';

/// Initializes the Rust FFI bridge. Wordle game services removed in Phase 1b.
Future<void> setupServices() async {
  await FfiService.initialize();
}

/// No-op reset for test compatibility.
void resetAllServices() {
  // FfiService stays initialized for the process lifetime.
}
