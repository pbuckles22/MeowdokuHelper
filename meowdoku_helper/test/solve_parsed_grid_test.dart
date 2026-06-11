import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/image/grid_goldens.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

import 'support/native_ffi.dart';

Future<void> main() async {
  final skip = await nativeFfiSkipReason();

  group('US-3.1 solve parsed grid', () {
    for (final golden in phase2Goldens) {
      test('${golden.fixture} returns move ${golden.expectedMove}', () async {
        await ensureRustLibInitialized();

        final shell = GridParseShell(
          gridSize: golden.gridSize,
          state: Uint8List.fromList(golden.state),
          regions: Uint8List.fromList(golden.regions),
        );

        expect(solveParsedGrid(shell), golden.expectedMove);
      }, skip: skip);
    }
  });
}
