import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meowdoku_helper/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app launches placeholder shell', (tester) async {
    await tester.pumpWidget(const MeowdokuHelperApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('MeowdokuHelper'), findsWidgets);
    expect(find.byIcon(Icons.pets), findsOneWidget);
  });
}
