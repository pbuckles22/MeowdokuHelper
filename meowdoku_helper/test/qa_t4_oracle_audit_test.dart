import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';
import 'package:meowdoku_helper/image/t4_solver_goldens.dart';

import 'support/native_ffi.dart';
import 'support/qa_board_trace.dart';

/// H2 — QA oracle audit for T4 fixture gate seq 18–19.
Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final ffiSkip = await nativeFfiSkipReason();

  group('H2 t4 parse-lock (QA)', () {
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

  group('H2 t4 solve regression (QA)', () {
    for (final golden in t4FixtureGate) {
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

  group('H2 t4 board traces (QA)', () {
    for (final golden in t4FixtureGate) {
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
