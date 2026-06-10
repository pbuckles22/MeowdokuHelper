import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/main.dart';

void main() {
  testWidgets('placeholder shell shows MeowdokuHelper title', (tester) async {
    await tester.pumpWidget(const MeowdokuHelperApp());
    expect(find.text('MeowdokuHelper'), findsOneWidget);
  });
}
