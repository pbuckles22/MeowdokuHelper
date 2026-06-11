import 'package:meowdoku_helper/image/n_detect.dart';
import 'package:meowdoku_helper/src/rust/api/meowdoku.dart';

/// Flat pass-through from [GridParseShell] to FRB `calculateNextMove`.
int solveParsedGrid(GridParseShell shell) {
  return calculateNextMove(
    state: shell.state,
    regions: shell.regions,
    gridSize: shell.gridSize,
  );
}
