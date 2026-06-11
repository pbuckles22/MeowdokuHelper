import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/clipboard_parse.dart';
import 'package:meowdoku_helper/image/decode_isolate.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final jpegHeader = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10]);

  group('US-2.6 clipboard parse', () {
    test('returns null when clipboard is empty', () async {
      final result = await parseClipboardImageIfJpeg(
        readClipboardBytes: () async => null,
      );
      expect(result, isNull);
    });

    test('returns null when clipboard bytes are not JPEG', () async {
      final result = await parseClipboardImageIfJpeg(
        readClipboardBytes: () async => Uint8List.fromList([1, 2, 3, 4]),
      );
      expect(result, isNull);
    });

    test('parses via isolate when clipboard holds JPEG magic bytes', () async {
      var parseCalled = false;

      final stubParsed = GridParseShell(
        gridSize: 4,
        state: Uint8List(16),
        regions: Uint8List(16),
      );

      final result = await parseClipboardImageIfJpeg(
        readClipboardBytes: () async => jpegHeader,
        parseInBackground: (bytes) async {
          parseCalled = true;
          expect(bytes, jpegHeader);
          return IsolateParseResult(
            parsed: stubParsed,
            ranInBackgroundIsolate: true,
          );
        },
      );

      expect(parseCalled, isTrue);
      expect(result?.parsed.gridSize, equals(4));
      expect(result?.ranInBackgroundIsolate, isTrue);
    });
  });
}
