import 'dart:typed_data';

/// Fast header check before spawning a decode isolate (JPEG SOI: FF D8 FF).
bool isJpegMagicBytes(Uint8List bytes) {
  return bytes.length >= 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF;
}
