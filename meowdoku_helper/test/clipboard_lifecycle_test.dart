import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/app/clipboard_lifecycle.dart';

void main() {
  testWidgets('resumed lifecycle triggers clipboard check callback', (tester) async {
    var resumeCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: ClipboardLifecycleListener(
          onResumed: () => resumeCount++,
          child: const Scaffold(body: Text('child')),
        ),
      ),
    );

    expect(resumeCount, equals(0));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    expect(resumeCount, equals(1));
  });

  testWidgets('paused lifecycle does not trigger clipboard check', (tester) async {
    var resumeCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: ClipboardLifecycleListener(
          onResumed: () => resumeCount++,
          child: const SizedBox.shrink(),
        ),
      ),
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();

    expect(resumeCount, equals(0));
  });
}
