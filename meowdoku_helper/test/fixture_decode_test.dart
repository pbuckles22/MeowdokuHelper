import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';

/// US-2.1 — load and decode repo-root board screenshot fixtures.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('US-2.1 fixture decode', () {
    test('reads seq-01 fixture bytes from repo-root fixtures', () async {
      final bytes = await BoardFixture.readBytes('01_L-early_N4_T1.jpg');
      expect(bytes, isNotEmpty);
      expect(bytes[0], equals(0xFF));
      expect(bytes[1], equals(0xD8)); // JPEG SOI marker
    });

    test('decodes seq-01 fixture to a raster image', () async {
      final bytes = await BoardFixture.readBytes('01_L-early_N4_T1.jpg');
      final decoded = await decodeJpeg(Uint8List.fromList(bytes));

      expect(decoded.width, equals(1000));
      expect(decoded.height, equals(893));
    });
  });
}
