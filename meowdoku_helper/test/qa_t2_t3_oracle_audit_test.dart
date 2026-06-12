import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';
import 'package:meowdoku_helper/image/t2_t3_solver_goldens.dart';

import 'support/native_ffi.dart';
import 'support/qa_board_trace.dart';

/// Q5 — QA oracle audit for T2/T3 fixture gate seq 09–17.
Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final ffiSkip = await nativeFfiSkipReason();

  group('Q5 t2/t3 parse-lock (QA)', () {
    for (final golden in t2T3FixtureGate) {
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

  group('Q5 t2/t3 solve regression (QA)', () {
    for (final golden in t2T3FixtureGate) {
      test(
        '${golden.fixture} solve returns locked index',
        () async {
          await ensureRustLibInitialized();

          final idx = solveParsedGrid(
            GridParseShell(
              gridSize: golden.gridSize,
              state: Uint8List.fromList(golden.state),
              regions: Uint8List.fromList(golden.regions),
            ),
          );

          expect(idx, golden.expectedMove);
          expect(qaExpectedMoveIsEmpty(golden.state, idx), isTrue);
        },
        skip: ffiSkip,
      );
    }
  });

  group('Q5 t2/t3 board traces (QA)', () {
    for (final golden in t2T3FixtureGate) {
      test('${golden.fixture} trace for derivation doc', () {
        expect(
          qaExpectedMoveIsEmpty(golden.state, golden.expectedMove),
          isTrue,
        );
        // ignore: avoid_print
        print('\n--- QA trace ---\n${qaBoardTrace(
          fixture: golden.fixture,
          gridSize: golden.gridSize,
          state: golden.state,
          regions: golden.regions,
          expectedMove: golden.expectedMove,
        )}');
      });
    }
  });
}
