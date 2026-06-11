import 'package:meowdoku_helper/services/ffi_service.dart';

/// Initializes the Rust FFI bridge.
Future<void> setupServices() async {
  await FfiService.initialize();
}
