import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';
import 'package:meowdoku_helper/image/t6_solver_goldens.dart';

import 'support/native_ffi.dart';
import 'support/qa_board_trace.dart';

/// Q1 — QA oracle audit for t6 seq 22–30 (US-7.1 / US-7.2).
Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final ffiSkip = await nativeFfiSkipReason();

  group('Q1 t6 parse-lock (QA)', () {
    for (final golden in t6FixtureGate) {
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

  group('Q1 t6 solve regression (QA)', () {
    for (final golden in t6FixtureGate) {
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
        },
        skip: ffiSkip,
      );
    }
  });

  group('Q1 t6 branch probe traces (QA)', () {
    const probes = <String, int>{
      '22_L31_N8_T6.jpeg': 0,
      '23_L22_N9_T6.jpeg': 8,
      '24_L27_N9_T6.jpeg': 9,
      '25_L32_N9_T6.jpeg': 1,
      '26_L29_N9_T6.jpeg': 7,
      '27_L24_N9_T6.jpeg': 4,
      '28_L30_N9_T6.jpeg': 9,
      '29_L23_N10_T6.jpeg': 2,
      '30_L25_N10_T6.jpeg': 6,
    };

    for (final golden in t6FixtureGate) {
      test('${golden.fixture} probe trace for uniqueness audit', () {
        final probe = probes[golden.fixture]!;
        expect(qaExpectedMoveIsEmpty(golden.state, probe), isTrue);
        // ignore: avoid_print
        print('\n--- QA trace ---\n${qaBoardTrace(
          fixture: golden.fixture,
          gridSize: golden.gridSize,
          state: golden.state,
          regions: golden.regions,
          expectedMove: probe,
        )}');
      });
    }
  });
}
