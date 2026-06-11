import 'dart:typed_data';

import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/image/clipboard_parse.dart';
import 'package:meowdoku_helper/image/decode_isolate.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

/// Result of a clipboard JPEG parse + solve attempt.
class ClipboardFlowResult {
  const ClipboardFlowResult({
    required this.status,
    this.parsedShell,
    this.highlightIndex,
  });

  final String status;
  final GridParseShell? parsedShell;
  final int? highlightIndex;
}

/// Status line when the solver returns a forced move index.
String clipboardMoveStatus(GridParseShell shell, int index) =>
    'Next move: cell $index (N=${shell.gridSize})';

/// Status line when Tiers 1–4 stall (`index == -1`).
String clipboardStalledStatus(GridParseShell shell) =>
    'Parsed N=${shell.gridSize} — no solver move (Tiers 1–4 stalled)';

/// Reads clipboard JPEG (if any), parses in isolate, and runs the solver.
Future<ClipboardFlowResult> runClipboardParseFlow({
  ClipboardBytesReader readClipboardBytes = readPasteboardImageBytes,
  Future<IsolateParseResult> Function(Uint8List bytes)? parseInBackground,
  int Function(GridParseShell shell) solve = solveParsedGrid,
}) async {
  final result = await parseClipboardImageIfJpeg(
    readClipboardBytes: readClipboardBytes,
    parseInBackground: parseInBackground,
  );

  if (result == null) {
    return const ClipboardFlowResult(status: 'Clipboard: no JPEG image');
  }

  final shell = result.parsed;
  final idx = solve(shell);
  return ClipboardFlowResult(
    parsedShell: shell,
    highlightIndex: idx,
    status: idx >= 0
        ? clipboardMoveStatus(shell, idx)
        : clipboardStalledStatus(shell),
  );
}
