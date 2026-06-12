import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/grid_goldens.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';
import 'package:meowdoku_helper/image/t2_t3_solver_goldens.dart';
import 'package:meowdoku_helper/image/t6_solver_goldens.dart';

import 'support/native_ffi.dart';
import 'support/qa_board_trace.dart';
import 'support/qa_t1_from_spec.dart';

/// Phase 7 Q6 — P2 oracle audit: seq 01–02 solve goldens + integration smoke.
Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final ffiSkip = await nativeFfiSkipReason();

  group('Q6 phase2 parse-lock (QA)', () {
    for (final golden in phase2SolveGoldens) {
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

  group('Q6 phase2 T1 spec oracle (QA)', () {
    for (final golden in phase2SolveGoldens) {
      test('${golden.fixture} T1 spec first move matches locked index', () {
        final specMove = qaSpecT1FirstMove(
          golden.state,
          golden.regions,
          golden.gridSize,
        );
        expect(specMove, golden.expectedMove);
        expect(qaExpectedMoveIsEmpty(golden.state, specMove!), isTrue);
      });
    }
  });

  group('Q6 phase2 solve regression (QA)', () {
    for (final golden in phase2SolveGoldens) {
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

  group('Q6 phase2 board traces (QA)', () {
    for (final golden in phase2SolveGoldens) {
      test('${golden.fixture} trace for derivation doc', () {
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

  const integrationCases = <({
    String fixture,
    int parsedGridSize,
    int expectedMoveIndex,
    String tierGate,
  })>[
    (
      fixture: '08_L09_N9_T1.jpg',
      parsedGridSize: 8,
      expectedMoveIndex: 11,
      tierGate: 'T1',
    ),
    (
      fixture: '14_L15_N10_T3.jpeg',
      parsedGridSize: 12,
      expectedMoveIndex: 13,
      tierGate: 'T3',
    ),
    (
      fixture: '29_L23_N10_T6.jpeg',
      parsedGridSize: 10,
      expectedMoveIndex: 2,
      tierGate: 'T6',
    ),
    (
      fixture: '30_L25_N10_T6.jpeg',
      parsedGridSize: 10,
      expectedMoveIndex: 6,
      tierGate: 'T6',
    ),
  ];

  group('Q6 integration parse-lock (QA)', () {
    for (final c in integrationCases) {
      test('${c.fixture} parse gridSize matches catalog', () async {
        final bytes = Uint8List.fromList(
          await BoardFixture.readBytes(c.fixture),
        );
        final parsed = parseGridFromImage(decodeJpegImage(bytes));
        expect(parsed.gridSize, c.parsedGridSize);
      });
    }

    test('seq 08 parse matches grid_goldens locked arrays', () async {
      final bytes = Uint8List.fromList(
        await BoardFixture.readBytes(seq08Golden.fixture),
      );
      final parsed = parseGridFromImage(decodeJpegImage(bytes));
      expect(parsed.gridSize, seq08Golden.gridSize);
      expect(parsed.state, Uint8List.fromList(seq08Golden.state));
      expect(parsed.regions, Uint8List.fromList(seq08Golden.regions));
    });

    test('seq 14 parse matches t2_t3 gate locked arrays', () async {
      final golden = t2T3FixtureGate.firstWhere(
        (g) => g.fixture == '14_L15_N10_T3.jpeg',
      );
      final bytes = Uint8List.fromList(
        await BoardFixture.readBytes(golden.fixture),
      );
      final parsed = parseGridFromImage(decodeJpegImage(bytes));
      expect(parsed.gridSize, golden.gridSize);
      expect(parsed.state, Uint8List.fromList(golden.state));
      expect(parsed.regions, Uint8List.fromList(golden.regions));
    });

    for (final c in integrationCases.where((c) => c.tierGate == 'T6')) {
      test('${c.fixture} parse matches t6 gate locked arrays', () async {
        final golden = t6FixtureGate.firstWhere((g) => g.fixture == c.fixture);
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

  group('Q6 integration solve regression (QA)', () {
    for (final c in integrationCases) {
      test(
        '${c.fixture} solve returns locked E2E index',
        () async {
          await ensureRustLibInitialized();

          List<int> state;
          List<int> regions;
          var gridSize = c.parsedGridSize;

          if (c.fixture == seq08Golden.fixture) {
            state = seq08Golden.state;
            regions = seq08Golden.regions;
            gridSize = seq08Golden.gridSize;
          } else if (c.fixture == '14_L15_N10_T3.jpeg') {
            final golden = t2T3FixtureGate.firstWhere(
              (g) => g.fixture == c.fixture,
            );
            state = golden.state;
            regions = golden.regions;
            gridSize = golden.gridSize;
          } else {
            final golden = t6FixtureGate.firstWhere(
              (g) => g.fixture == c.fixture,
            );
            state = golden.state;
            regions = golden.regions;
            gridSize = golden.gridSize;
          }

          final idx = solveParsedGrid(
            GridParseShell(
              gridSize: gridSize,
              state: Uint8List.fromList(state),
              regions: Uint8List.fromList(regions),
            ),
          );

          expect(idx, c.expectedMoveIndex);
          expect(qaExpectedMoveIsEmpty(state, idx), isTrue);
        },
        skip: ffiSkip,
      );
    }
  });

  group('Q6 integration board traces (QA)', () {
    test('seq 08 trace for derivation doc', () {
      // ignore: avoid_print
      print('\n--- QA trace ---\n${qaBoardTrace(
        fixture: seq08Golden.fixture,
        gridSize: seq08Golden.gridSize,
        state: seq08Golden.state,
        regions: seq08Golden.regions,
        expectedMove: 11,
      )}');
    });

    for (final c in integrationCases.where((c) => c.fixture != seq08Golden.fixture)) {
      test('${c.fixture} trace for derivation doc', () {
        late List<int> state;
        late List<int> regions;
        late int gridSize;

        if (c.fixture == '14_L15_N10_T3.jpeg') {
          final golden = t2T3FixtureGate.firstWhere(
            (g) => g.fixture == c.fixture,
          );
          state = golden.state;
          regions = golden.regions;
          gridSize = golden.gridSize;
        } else {
          final golden = t6FixtureGate.firstWhere(
            (g) => g.fixture == c.fixture,
          );
          state = golden.state;
          regions = golden.regions;
          gridSize = golden.gridSize;
        }

        // ignore: avoid_print
        print('\n--- QA trace ---\n${qaBoardTrace(
          fixture: c.fixture,
          gridSize: gridSize,
          state: state,
          regions: regions,
          expectedMove: c.expectedMoveIndex,
        )}');
      });
    }
  });
}
