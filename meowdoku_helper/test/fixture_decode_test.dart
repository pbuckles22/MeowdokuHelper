import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';

/// US-2.1 — load and decode repo-root board screenshot fixtures.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('US-2.1 fixture decode', () {
    test('reads EarlyGame.jpg bytes from repo-root fixtures', () async {
      final bytes = await BoardFixture.readBytes('EarlyGame.jpg');
      expect(bytes, isNotEmpty);
      expect(bytes[0], equals(0xFF));
      expect(bytes[1], equals(0xD8)); // JPEG SOI marker
    });

    test('decodes EarlyGame.jpg to a raster image', () async {
      final bytes = await BoardFixture.readBytes('EarlyGame.jpg');
      final decoded = await decodeJpeg(Uint8List.fromList(bytes));

      expect(decoded.width, equals(1000));
      expect(decoded.height, equals(893));
    });
  });
}
