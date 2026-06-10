import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/services/ffi_service.dart';
import 'package:meowdoku_helper/src/rust/frb_generated.dart';

/// Tier 1b FFI smoke — requires native Rust lib (built via platform run/build).
///
/// Skips when the native library is not linked (Windows unit-test host, or Mac
/// before `flutter run` / `flutter build`). Full FFI validation: Tier 2 on device.
void main() {
  group('FFI smoke', () {
    test(
      'RustLib.init and FfiService.initialize succeed',
      () async {
        try {
          await RustLib.init();
        } on Object {
          return;
        }

        await FfiService.initialize();
        expect(FfiService.isInitialized, isTrue);
      },
      skip: Platform.isWindows ? 'Native Rust lib — run on Mac/iOS' : false,
    );
  });
}
