import 'dart:typed_data';
import 'dart:ui' as ui;

/// Decoded JPEG dimensions (pixel raster available during decode, then disposed).
class DecodedJpeg {
  const DecodedJpeg({required this.width, required this.height});

  final int width;
  final int height;
}

/// Decodes JPEG [bytes] using the Flutter image codec (isolate-safe in Phase 2).
Future<DecodedJpeg> decodeJpeg(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  try {
    final frame = await codec.getNextFrame();
    final image = frame.image;
    try {
      return DecodedJpeg(width: image.width, height: image.height);
    } finally {
      image.dispose();
    }
  } finally {
    codec.dispose();
  }
}
