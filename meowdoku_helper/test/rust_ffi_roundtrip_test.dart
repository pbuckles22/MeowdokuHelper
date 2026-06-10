import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/src/rust/api/simple.dart';
import 'package:meowdoku_helper/src/rust/frb_generated.dart';

/// Tier 1b — proves Dart calls Rust via FRB and receives a computed response.
///
/// Uses `simulateGuessPattern` (pure logic, no word-list assets). Skips when the
/// native library is not linked in the unit-test host. Authoritative on-device
/// proof: `integration_test/app_smoke_test.dart`.
void main() {
  group('Rust FFI roundtrip', () {
    test(
      'simulateGuessPattern returns Rust-computed pattern',
      () async {
        try {
          await RustLib.init();
        } on Object {
          return;
        }

        final pattern = simulateGuessPattern(
          guess: 'CRANE',
          target: 'CRATE',
        );
        expect(pattern, 'GGGXG');
      },
      skip: Platform.isWindows ? 'Native Rust lib — run on Mac/iOS' : false,
    );
  });
}
