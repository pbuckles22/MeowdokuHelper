import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meowdoku_helper/main.dart';
import 'package:meowdoku_helper/src/rust/api/meowdoku.dart';

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
}
