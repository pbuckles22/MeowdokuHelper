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
const _seq08ExpectedMoveIndex = -2;

/// Phase 5 E2E fixture (doc/plan/FIXTURES.md seq 14). Catalog N=10; parser N=12.
const _seq14Fixture = '14_L15_N10_T3.jpeg';
const _seq14ParsedGridSize = 12;
const _seq14ExpectedMoveIndex = -2;

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

  testWidgets('US-5.1 seq-14 fixture parse solve FFI pipeline', (tester) async {
    await _expectFixturePipeline(
      tester,
      fixture: _seq14Fixture,
      parsedGridSize: _seq14ParsedGridSize,
      expectedMoveIndex: _seq14ExpectedMoveIndex,
    );
  });

  testWidgets('US-5.2 seq-29 fixture parse solve FFI pipeline', (tester) async {
    await _expectFixturePipeline(
      tester,
      fixture: '29_L23_N10_T6.jpeg',
      parsedGridSize: 10,
      expectedMoveIndex: -2,
    );
  });

  testWidgets('US-5.2 seq-30 fixture parse solve FFI pipeline', (tester) async {
    await _expectFixturePipeline(
      tester,
      fixture: '30_L25_N10_T6.jpeg',
      parsedGridSize: 10,
      expectedMoveIndex: -2,
    );
  });
}

Future<void> _expectFixturePipeline(
  WidgetTester tester, {
  required String fixture,
  required int parsedGridSize,
  required int expectedMoveIndex,
}) async {
  await tester.pumpWidget(const MeowdokuHelperApp());
  await tester.pumpAndSettle(const Duration(seconds: 5));

  final bytes = await loadIntegrationFixture(fixture);
  final result = await parseJpegInBackground(bytes);
  final shell = result.parsed;

  expect(result.ranInBackgroundIsolate, isTrue);
  expect(shell.gridSize, parsedGridSize);
  expect(shell.state.length, shell.gridSize * shell.gridSize);
  expect(shell.regions.length, shell.gridSize * shell.gridSize);

  final idx = solveParsedGrid(shell);
  expect(idx, expectedMoveIndex);
}
