import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';

/// Result of decoding JPEG bytes on a background isolate.
class IsolateDecodeResult {
  const IsolateDecodeResult({
    required this.decoded,
    required this.ranInBackgroundIsolate,
  });

  final DecodedJpeg decoded;
  final bool ranInBackgroundIsolate;
}

/// Top-level [compute] worker — must remain top-level (not a closure).
Future<IsolateDecodeResult> decodeJpegIsolateWorker(Uint8List bytes) async {
  final decoded = decodeJpeg(bytes);
  return IsolateDecodeResult(
    decoded: decoded,
    ranInBackgroundIsolate: true,
  );
}

/// Decodes JPEG [bytes] off the calling isolate via [compute].
Future<IsolateDecodeResult> decodeJpegInBackground(Uint8List bytes) {
  return compute(decodeJpegIsolateWorker, bytes);
}
