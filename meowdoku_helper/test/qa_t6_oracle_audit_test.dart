import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';
import 'package:meowdoku_helper/image/t6_solver_goldens.dart';

import 'support/qa_board_trace.dart';

/// Q1 — QA oracle pre-audit for t6 seq 22–30 (US-7.1).
/// Parse + spec preconditions only; human solve recorded in doc/qa_derivations/.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
}
