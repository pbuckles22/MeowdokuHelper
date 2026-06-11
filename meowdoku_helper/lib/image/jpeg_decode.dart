import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Decoded JPEG dimensions (full raster available via [decodeJpegImage] for sampling).
class DecodedJpeg {
  const DecodedJpeg({required this.width, required this.height});

  final int width;
  final int height;
}

/// Decodes JPEG [bytes] (pure Dart — safe for [compute] isolates).
DecodedJpeg decodeJpeg(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw StateError('JPEG decode failed');
  }
  return DecodedJpeg(width: decoded.width, height: decoded.height);
}

/// Full raster decode for Phase 2 cell sampling (US-2.4+).
img.Image decodeJpegImage(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw StateError('JPEG decode failed');
  }
  return decoded;
}
