import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/src/rust/api/meowdoku.dart';
import 'package:meowdoku_helper/src/rust/frb_generated.dart';

/// Tier 1b — Dart calls Star Battle `calculateNextMove` via FRB.
void main() {
  group('Rust FFI roundtrip', () {
    test(
      'calculateNextMove returns solver index from Rust',
      () async {
        try {
          await RustLib.init();
        } on Object {
          return;
        }

        final size = 9;
        final chokeX = 2;
        final chokeY = 8;
        final state = List<int>.filled(size * size, 2);
        state[chokeY * size + chokeX] = 0;
        state[4 * size + 4] = 1;

        final regions = List<int>.generate(
          size * size,
          (idx) => ((idx % size + idx ~/ size) % size) + 1,
        );

        final idx = calculateNextMove(
          state: state,
          regions: regions,
          gridSize: size,
        );
        expect(idx, chokeY * size + chokeX);
      },
      skip: Platform.isWindows ? 'Native Rust lib — run on Mac/iOS' : false,
    );
  });
}
