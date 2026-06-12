import 'dart:typed_data';

import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/app/solver_result.dart';
import 'package:meowdoku_helper/image/clipboard_parse.dart';
import 'package:meowdoku_helper/image/decode_isolate.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

/// Result of a clipboard JPEG parse + solve attempt.
class ClipboardFlowResult {
  const ClipboardFlowResult({
    required this.status,
    this.parsedShell,
    this.solverIndex,
    this.highlightIndex,
  });

  final String status;
  final GridParseShell? parsedShell;

  /// Raw FFI result: `>= 0` forced, `-2` branch, `-1` stalled.
  final int? solverIndex;

  /// Cell highlight only for forced moves (`>= 0`).
  final int? highlightIndex;
}

/// Status line when the solver returns a forced move index.
String clipboardMoveStatus(GridParseShell shell, int index) =>
    'Next move: cell $index (N=${shell.gridSize})';

/// Status when T6 branching is required (`index == -2`).
String clipboardBranchRequiredStatus(GridParseShell shell) =>
    'Parsed N=${shell.gridSize} — multiple valid paths exist. Make a choice to continue.';

/// Status line when fully stuck (`index == -1`).
String clipboardStalledStatus(GridParseShell shell) =>
    'Parsed N=${shell.gridSize} — no solver move (Tiers 1–6 stalled)';

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
  final String status;
  final int? highlight;
  if (SolverResult.isForcedMove(idx)) {
    status = clipboardMoveStatus(shell, idx);
    highlight = idx;
  } else if (idx == SolverResult.branchRequired) {
    status = clipboardBranchRequiredStatus(shell);
    highlight = null;
  } else {
    status = clipboardStalledStatus(shell);
    highlight = null;
  }

  return ClipboardFlowResult(
    parsedShell: shell,
    solverIndex: idx,
    highlightIndex: highlight,
    status: status,
  );
}
