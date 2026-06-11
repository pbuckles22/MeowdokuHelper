import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/decode_isolate.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

/// US-2.4 — center + offset cell sampling fills state and regions.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('US-2.4 cell sample', () {
    test('seq-01 parse fills N² arrays with valid region IDs and state', () async {
      final bytes = Uint8List.fromList(
        await BoardFixture.readBytes('01_L-early_N4_T1.jpg'),
      );
      final image = decodeJpegImage(bytes);
      final parsed = parseGridFromImage(image);

      expect(parsed.gridSize, equals(4));
      expect(parsed.state.length, equals(16));
      expect(parsed.regions.length, equals(16));

      for (final region in parsed.regions) {
        expect(region, inInclusiveRange(1, 4));
      }
      for (final cell in parsed.state) {
        expect(cell, inInclusiveRange(0, 2));
      }

      expect(parsed.state.where((s) => s == cellCat).length, equals(1));
    });

    test('parseJpegInBackground returns filled grid via compute worker', () async {
      final bytes = Uint8List.fromList(
        await BoardFixture.readBytes('01_L-early_N4_T1.jpg'),
      );

      final result = await parseJpegInBackground(bytes);

      expect(result.ranInBackgroundIsolate, isTrue);
      expect(result.parsed.gridSize, equals(4));
      expect(result.parsed.state.length, equals(16));
      expect(result.parsed.regions.length, equals(16));
      expect(result.parsed.state.where((s) => s == cellCat).length, equals(1));
    });
  });
}
