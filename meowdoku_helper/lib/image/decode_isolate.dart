import 'package:flutter/foundation.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

/// Result of decoding JPEG bytes on a background isolate.
class IsolateDecodeResult {
  const IsolateDecodeResult({
    required this.decoded,
    required this.ranInBackgroundIsolate,
  });

  final DecodedJpeg decoded;
  final bool ranInBackgroundIsolate;
}

/// Result of full grid parse on a background isolate (US-2.4+).
class IsolateParseResult {
  const IsolateParseResult({
    required this.parsed,
    required this.ranInBackgroundIsolate,
  });

  final GridParseShell parsed;
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

/// Top-level [compute] worker — decode + N-detect + cell sampling.
Future<IsolateParseResult> parseJpegIsolateWorker(Uint8List bytes) async {
  final image = decodeJpegImage(bytes);
  final parsed = parseGridFromImage(image);
  return IsolateParseResult(
    parsed: parsed,
    ranInBackgroundIsolate: true,
  );
}

/// Decodes JPEG [bytes] off the calling isolate via [compute].
Future<IsolateDecodeResult> decodeJpegInBackground(Uint8List bytes) {
  return compute(decodeJpegIsolateWorker, bytes);
}

/// Parses grid from JPEG [bytes] off the calling isolate via [compute].
Future<IsolateParseResult> parseJpegInBackground(Uint8List bytes) {
  return compute(parseJpegIsolateWorker, bytes);
}
