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

  const propagationMoves = {
    '09_L10_N7_T2.jpg': 7,
    '10_L11_T2.jpeg': 0,
    '11_L12_T2.jpeg': 0,
    '12_L13_T2.jpeg': 8,
    '13_L14_T2.jpeg': 7,
    '14_L15_N10_T3.jpeg': 13,
    '15_L16_T3.jpeg': 2,
    '16_L17_T3.jpeg': 6,
    '17_L18_T3.jpeg': 4,
  };

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
        '${golden.fixture} solve returns hint API index',
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
        },
        skip: ffiSkip,
      );
    }
  });

  group('Q5 t2/t3 board traces (QA)', () {
    for (final golden in t2T3FixtureGate) {
      test('${golden.fixture} trace for derivation doc', () {
        final propagation = propagationMoves[golden.fixture]!;
        expect(qaExpectedMoveIsEmpty(golden.state, propagation), isTrue);
        // ignore: avoid_print
        print('\n--- QA trace ---\n${qaBoardTrace(
          fixture: golden.fixture,
          gridSize: golden.gridSize,
          state: golden.state,
          regions: golden.regions,
          expectedMove: propagation,
        )}');
      });
    }
  });
}
