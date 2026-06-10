import '../exceptions/service_exceptions.dart';
import '../src/rust/frb_generated.dart';

/// Thin wrapper around flutter_rust_bridge startup.
///
/// Wordle-specific helpers were removed in Phase 1b. Star Battle board FFI
/// lands in Phase 3 (`calculate_next_move`).
class FfiService {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  /// Initialize the Rust FFI bridge. Safe to call more than once.
  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      await RustLib.init();
    } on Exception catch (e) {
      if (!e.toString().contains(
        'Should not initialize flutter_rust_bridge twice',
      )) {
        throw FfiInitializationException(
          'Failed to initialize Rust FFI: $e',
        );
      }
    }

    _isInitialized = true;
  }
}
