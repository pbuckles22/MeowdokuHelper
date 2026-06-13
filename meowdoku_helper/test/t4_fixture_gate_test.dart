import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';
import 'package:meowdoku_helper/image/t4_solver_goldens.dart';

import 'support/native_ffi.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final skip = await nativeFfiSkipReason();

  group('H2 T4 parse goldens (seq 18–19, 21, 31–32)', () {
    for (final golden in t4FixtureGate) {
      test('${golden.fixture} parse matches locked arrays', () async {
        final bytes = Uint8List.fromList(
          await BoardFixture.readBytes(golden.fixture),
        );
        final parsed = parseGridFromImage(decodeJpegImage(bytes));

        expect(parsed.gridSize, golden.gridSize);
        expect(parsed.state, Uint8List.fromList(golden.state));
        expect(parsed.regions, Uint8List.fromList(golden.regions));
      });
    }
  });

  group('H2 T4 solver goldens (seq 18–19, 21, 31–32)', () {
    for (final golden in t4FixtureGate) {
      test(
        '${golden.fixture} solve returns move ${golden.expectedMove}',
        () async {
          await ensureRustLibInitialized();

          final shell = GridParseShell(
            gridSize: golden.gridSize,
            state: Uint8List.fromList(golden.state),
            regions: Uint8List.fromList(golden.regions),
          );
          expect(solveParsedGrid(shell), golden.expectedMove);
        },
        skip: skip,
      );
    }
  });
}
