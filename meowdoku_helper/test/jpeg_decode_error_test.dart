import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';

void main() {
  group('decodeJpeg error paths', () {
    test('throws when bytes are not a valid JPEG', () {
      expect(
        () => decodeJpeg(Uint8List.fromList([0, 1, 2])),
        throwsA(isA<Object>()),
      );
    });

    test('decodeJpegImage throws when raster decode fails', () {
      expect(
        () => decodeJpegImage(Uint8List.fromList([0xFF, 0xD8, 0xFF])),
        throwsA(isA<Object>()),
      );
    });
  });
}
