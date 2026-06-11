import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/jpeg_magic.dart';

void main() {
  group('JPEG magic bytes', () {
    test('accepts SOI marker 0xFF 0xD8 0xFF', () {
      expect(isJpegMagicBytes(Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0])), isTrue);
    });

    test('rejects too-short buffers', () {
      expect(isJpegMagicBytes(Uint8List.fromList([0xFF, 0xD8])), isFalse);
    });

    test('rejects non-JPEG headers', () {
      expect(isJpegMagicBytes(Uint8List.fromList([0x89, 0x50, 0x4E, 0x47])), isFalse);
    });
  });
}
