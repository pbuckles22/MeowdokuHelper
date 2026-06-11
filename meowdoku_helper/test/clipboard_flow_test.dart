import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/app/clipboard_flow.dart';
import 'package:meowdoku_helper/image/decode_isolate.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

Future<void> main() async {
  group('runClipboardParseFlow', () {
    test('returns no-JPEG status when clipboard is empty', () async {
      final outcome = await runClipboardParseFlow(
        readClipboardBytes: () async => null,
      );

      expect(outcome.status, 'Clipboard: no JPEG image');
      expect(outcome.parsedShell, isNull);
      expect(outcome.highlightIndex, isNull);
    });

    test('returns no-JPEG status for non-JPEG bytes', () async {
      final outcome = await runClipboardParseFlow(
        readClipboardBytes: () async => Uint8List.fromList([1, 2, 3]),
      );

      expect(outcome.status, 'Clipboard: no JPEG image');
    });

    test('parses stub JPEG and reports move status', () async {
      final shell = gridParseShell(4);
      final outcome = await runClipboardParseFlow(
        readClipboardBytes: () async => Uint8List.fromList([0xFF, 0xD8, 0xFF, 0x00]),
        parseInBackground: (_) async => IsolateParseResult(
          parsed: shell,
          ranInBackgroundIsolate: true,
        ),
        solve: (_) => 7,
      );

      expect(outcome.parsedShell, shell);
      expect(outcome.highlightIndex, 7);
      expect(outcome.status, 'Next move: cell 7 (N=4)');
    });
  });

  group('clipboard status helpers', () {
    test('stalled status mentions Tiers 1–4', () {
      final shell = gridParseShell(9);
      expect(clipboardStalledStatus(shell), contains('Tiers 1–4'));
    });
  });
}
