import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';
import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/image/t6_solver_goldens.dart';

import 'support/native_ffi.dart';
import 'support/qa_board_trace.dart';

const _qaBlocked = 2;

/// Q1 — QA oracle pre-audit for t6 seq 22–30 (US-7.1).
/// Parse + spec preconditions only; human solve recorded in doc/qa_derivations/.
Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final ffiSkip = await nativeFfiSkipReason();

  group('Q1 t6 oracle pre-audit (QA)', () {
    for (final golden in t6FixtureGate) {
      test('${golden.fixture} parse-lock + expected index preconditions', () async {
        final bytes = Uint8List.fromList(
          await BoardFixture.readBytes(golden.fixture),
        );
        final parsed = parseGridFromImage(decodeJpegImage(bytes));

        expect(parsed.gridSize, golden.gridSize);
        expect(parsed.state, Uint8List.fromList(golden.state));
        expect(parsed.regions, Uint8List.fromList(golden.regions));

        expect(
          qaExpectedMoveIsEmpty(golden.state, golden.expectedMove),
          isTrue,
          reason: 'locked move must target EMPTY cell per product rules',
        );

        // Trace for human oracle doc (stdout in test run).
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

  group('Q1 t6 first-move uniqueness (QA)', () {
    for (final golden in t6FixtureGate) {
      test(
        '${golden.fixture} locked move forced vs branch-variant',
        () async {
          await ensureRustLibInitialized();

          final blocked = List<int>.from(golden.state);
          blocked[golden.expectedMove] = _qaBlocked;

          final alt = solveParsedGrid(
            GridParseShell(
              gridSize: golden.gridSize,
              state: Uint8List.fromList(blocked),
              regions: Uint8List.fromList(golden.regions),
            ),
          );

          final forced = alt == -1;
          // ignore: avoid_print
          print(
            '${golden.fixture} move ${golden.expectedMove}: '
            '${forced ? "FORCED" : "BRANCH_VARIANT"}'
            '${forced ? "" : " (alt first move index=$alt)"}',
          );

          // Record only — goldens may be branch variants until re-oracled.
          expect(qaExpectedMoveIsEmpty(golden.state, golden.expectedMove), isTrue);
        },
        skip: ffiSkip,
      );
    }
  });
}
