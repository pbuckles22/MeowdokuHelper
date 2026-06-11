import 'dart:typed_data';

import 'package:meowdoku_helper/image/decode_isolate.dart';
import 'package:meowdoku_helper/image/jpeg_magic.dart';
import 'package:pasteboard/pasteboard.dart';

typedef ClipboardBytesReader = Future<Uint8List?> Function();

/// Reads image bytes from the system pasteboard (nullable).
Future<Uint8List?> readPasteboardImageBytes() async {
  final bytes = await Pasteboard.image;
  if (bytes == null || bytes.isEmpty) {
    return null;
  }
  return bytes;
}

/// Validates JPEG header, then runs [parseJpegInBackground] when bytes look valid.
Future<IsolateParseResult?> parseClipboardImageIfJpeg({
  required ClipboardBytesReader readClipboardBytes,
  Future<IsolateParseResult> Function(Uint8List bytes)? parseInBackground,
}) async {
  final bytes = await readClipboardBytes();
  if (bytes == null || !isJpegMagicBytes(bytes)) {
    return null;
  }

  final parse = parseInBackground ?? parseJpegInBackground;
  return parse(bytes);
}
