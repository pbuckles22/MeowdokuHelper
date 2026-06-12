import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

/// Phase 2 ladder — seq 03–08 parse smoke (arrays locked in [grid_goldens.dart]).
const _parseLadderFixtures = [
  '03_L04_T1.jpg',
  '04_L05_T1.jpg',
  '05_L06_T1.jpg',
  '06_L07_T1.jpg',
  '07_L08_T1.jpg',
  '08_L09_N9_T1.jpg',
];

void main() {
  group('Phase 2 parse ladder seq 03–08', () {
    for (final fixture in _parseLadderFixtures) {
      test('$fixture produces valid N² parse', () async {
        final bytes = Uint8List.fromList(await BoardFixture.readBytes(fixture));
        final parsed = parseGridFromImage(decodeJpegImage(bytes));

        expect(parsed.gridSize, inInclusiveRange(4, 12));
        final len = parsed.gridSize * parsed.gridSize;
        expect(parsed.state.length, len);
        expect(parsed.regions.length, len);
        expect(parsed.state.every((v) => v >= 0 && v <= 2), isTrue);
        expect(parsed.regions.every((r) => r >= 1), isTrue);
      });
    }
  });
}
