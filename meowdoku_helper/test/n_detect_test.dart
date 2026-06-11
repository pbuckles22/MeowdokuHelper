import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';
import 'package:meowdoku_helper/image/jpeg_decode.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

/// US-2.3 — detect grid size N from unique region fill colors.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('US-2.3 N detect', () {
    test('seq-01 unique region colors yield N=4 and N² array length', () async {
      final bytes = Uint8List.fromList(
        await BoardFixture.readBytes('01_L-early_N4_T1.jpg'),
      );
      final image = decodeJpegImage(bytes);

      final n = detectGridSize(image);
      expect(n, equals(4));

      final parsed = gridParseShell(n);
      expect(parsed.gridSize, equals(4));
      expect(parsed.state.length, equals(16));
      expect(parsed.regions.length, equals(16));
    });

    test('seq-02 unique region colors yield N=6 and N² array length', () async {
      final bytes = Uint8List.fromList(
        await BoardFixture.readBytes('02_L03_N6_T1.jpg'),
      );
      final image = decodeJpegImage(bytes);

      final n = detectGridSize(image);
      expect(n, equals(6));

      final parsed = gridParseShell(n);
      expect(parsed.gridSize, equals(6));
      expect(parsed.state.length, equals(36));
      expect(parsed.regions.length, equals(36));
    });
  });
}
