import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/image/decode_isolate.dart';
import 'package:meowdoku_helper/main.dart';
import 'package:meowdoku_helper/src/rust/api/meowdoku.dart';

import 'fixture_loader.dart';

/// Phase 3 E2E fixture (doc/plan/FIXTURES.md seq 08). Catalog N=9; parser N=8.
const _seq08Fixture = '08_L09_N9_T1.jpg';
const _seq08ParsedGridSize = 8;
const _seq08ExpectedMoveIndex = 41;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app launches placeholder shell', (tester) async {
    await tester.pumpWidget(const MeowdokuHelperApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('MeowdokuHelper'), findsWidgets);
    expect(find.byIcon(Icons.pets), findsOneWidget);
  });

  testWidgets('rust bridge returns solver move index', (tester) async {
    await tester.pumpWidget(const MeowdokuHelperApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

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
  });

  testWidgets('US-3.3 seq-08 fixture parse solve FFI pipeline', (tester) async {
    await tester.pumpWidget(const MeowdokuHelperApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final bytes = await loadIntegrationFixture(_seq08Fixture);
    final result = await parseJpegInBackground(bytes);
    final shell = result.parsed;

    expect(result.ranInBackgroundIsolate, isTrue);
    expect(shell.gridSize, _seq08ParsedGridSize);
    expect(shell.state.length, shell.gridSize * shell.gridSize);
    expect(shell.regions.length, shell.gridSize * shell.gridSize);

    final idx = solveParsedGrid(shell);
    expect(idx, _seq08ExpectedMoveIndex);
  });
}
