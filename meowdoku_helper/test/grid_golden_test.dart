import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/grid_goldens.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

/// US-2.5 — golden parse arrays for Phase 2 fixtures seq 01–08.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('US-2.5 grid goldens', () {
    for (final golden in phase2ParseGoldens) {
      test('${golden.fixture} matches locked state and regions', () async {
        final bytes = Uint8List.fromList(
          await BoardFixture.readBytes(golden.fixture),
        );
        final parsed = parseGridFromImage(decodeJpegImage(bytes));

        expect(parsed.gridSize, equals(golden.gridSize));
        expect(parsed.state, equals(Uint8List.fromList(golden.state)));
        expect(parsed.regions, equals(Uint8List.fromList(golden.regions)));
      });
    }
  });
}
