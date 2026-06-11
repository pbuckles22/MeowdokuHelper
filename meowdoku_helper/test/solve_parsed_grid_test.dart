import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/app/solve_parsed_grid.dart';
import 'package:meowdoku_helper/image/grid_goldens.dart';
import 'package:meowdoku_helper/image/n_detect.dart';
import 'package:meowdoku_helper/src/rust/frb_generated.dart';

/// US-3.1 — flat marshalling from [GridParseShell] to FRB.
void main() {
  group('US-3.1 solve parsed grid', () {
    test('passes shell arrays directly to calculateNextMove', () async {
      final shell = GridParseShell(
        gridSize: seq01Golden.gridSize,
        state: Uint8List.fromList(seq01Golden.state),
        regions: Uint8List.fromList(seq01Golden.regions),
      );

      try {
        await RustLib.init();
      } on Object {
        return;
      }

      final idx = solveParsedGrid(shell);
      expect(idx, isA<int>());
      expect(idx, greaterThanOrEqualTo(-1));
      expect(idx, lessThan(shell.gridSize * shell.gridSize));
    }, skip: Platform.isWindows ? 'Native Rust lib — run on Mac/iOS' : false);
  });
}
