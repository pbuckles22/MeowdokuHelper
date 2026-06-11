import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/decode_isolate.dart';

/// US-2.2 — grid pipeline entry runs off the UI thread via [compute].
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('US-2.2 decode isolate', () {
    test('decodeJpegInBackground decodes seq-01 via compute worker', () async {
      final bytes = Uint8List.fromList(
        await BoardFixture.readBytes('01_L-early_N4_T1.jpg'),
      );

      final result = await decodeJpegInBackground(bytes);

      expect(result.ranInBackgroundIsolate, isTrue);
      expect(result.decoded.width, equals(1000));
      expect(result.decoded.height, equals(893));
    });
  });
}
