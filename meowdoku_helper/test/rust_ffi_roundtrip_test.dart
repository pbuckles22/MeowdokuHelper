import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/src/rust/api/meowdoku.dart';

import 'support/native_ffi.dart';

Future<void> main() async {
  final skip = await nativeFfiSkipReason();

  group('Rust FFI roundtrip', () {
    test(
      'calculateNextMove returns solver index from Rust',
      () async {
        await ensureRustLibInitialized();

        const size = 9;
        const chokeX = 2;
        const chokeY = 8;
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
      skip: skip,
    );
  });
}
