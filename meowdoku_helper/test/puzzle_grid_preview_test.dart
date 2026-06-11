import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/app/puzzle_grid_preview.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(width: 200, child: child),
        ),
      ),
    );
  }

  group('US-3.2 puzzle grid preview', () {
    testWidgets('renders N squared cells', (tester) async {
      await tester.pumpWidget(
        wrap(
          const PuzzleGridPreview(
            gridSize: 4,
            state: [
              0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            ],
            highlightIndex: 3,
          ),
        ),
      );

      expect(find.byKey(const ValueKey('puzzle-cell-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('puzzle-cell-15')), findsOneWidget);
      expect(find.byKey(const ValueKey('puzzle-cell-16')), findsNothing);
    });

    testWidgets('shows highlight ring on target index', (tester) async {
      const target = 5;
      await tester.pumpWidget(
        wrap(
          const PuzzleGridPreview(
            gridSize: 3,
            state: [0, 0, 0, 0, 0, 0, 0, 0, 0],
            highlightIndex: target,
          ),
        ),
      );

      expect(find.byKey(const Key(PuzzleGridPreview.highlightRingKey)), findsOneWidget);
      final ring = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byKey(const ValueKey('puzzle-cell-$target')),
          matching: find.byKey(const Key(PuzzleGridPreview.highlightRingKey)),
        ),
      );
      expect(ring, isNotNull);
    });

    testWidgets('renders cat and blocked cell icons', (tester) async {
      await tester.pumpWidget(
        wrap(
          const PuzzleGridPreview(
            gridSize: 2,
            state: [cellCat, cellBlocked, 0, 0],
            highlightIndex: -1,
          ),
        ),
      );

      expect(find.byIcon(Icons.pets), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('renders 12x12 grid for N>9 boards', (tester) async {
      await tester.pumpWidget(
        wrap(
          PuzzleGridPreview(
            gridSize: 12,
            state: List<int>.filled(144, 0),
            highlightIndex: 47,
          ),
        ),
      );

      expect(find.byKey(const ValueKey('puzzle-cell-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('puzzle-cell-143')), findsOneWidget);
      expect(find.byKey(const ValueKey('puzzle-cell-144')), findsNothing);
      expect(find.byKey(const Key(PuzzleGridPreview.highlightRingKey)), findsOneWidget);
    });

    testWidgets('shows stalled banner when highlight index is -1', (tester) async {
      await tester.pumpWidget(
        wrap(
          const PuzzleGridPreview(
            gridSize: 2,
            state: [0, 0, 0, 0],
            highlightIndex: -1,
          ),
        ),
      );

      expect(
        find.byKey(const Key(PuzzleGridPreview.stalledBannerKey)),
        findsOneWidget,
      );
      expect(find.textContaining('Board stalled'), findsOneWidget);
      expect(find.byKey(const Key(PuzzleGridPreview.highlightRingKey)), findsNothing);
    });
  });
}
