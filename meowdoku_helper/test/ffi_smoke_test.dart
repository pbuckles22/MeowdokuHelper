import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/services/ffi_service.dart';
import 'package:meowdoku_helper/src/rust/frb_generated.dart';

/// Tier 1b FFI smoke — requires native Rust lib (built via iOS/macOS/Android run).
///
/// On Windows host unit tests, skip; run on Mac with a device/simulator before merge.
void main() {
  group('FFI smoke', () {
    test('RustLib.init and FfiService.initialize succeed', () async {
      if (Platform.isWindows) {
        // Native .dll is not linked for `flutter test` on Windows; validate on Mac/iOS.
        return;
      }

      await RustLib.init();
      await FfiService.initialize();
      expect(FfiService.isInitialized, isTrue);
    }, skip: Platform.isWindows ? 'Native Rust lib — run on Mac/iOS' : false);
  });
}
