import 'package:meowdoku_helper/exceptions/service_exceptions.dart';
import 'package:meowdoku_helper/src/rust/frb_generated.dart';

/// Thin wrapper around flutter_rust_bridge startup.
///
/// Star Battle board FFI (`calculate_next_move`) is exposed from `api/meowdoku`.
abstract final class FfiService {
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
        throw FfiInitializationException('Failed to initialize Rust FFI: $e');
      }
    }

    _isInitialized = true;
  }
}
