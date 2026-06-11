import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:meowdoku_helper/image/n_detect.dart';

void main() {
  group('n_detect error paths', () {
    test('findRegionBoundingBox throws on blank image', () {
      final blank = img.Image(width: 32, height: 32);
      blank.clear(img.ColorRgb8(255, 255, 255));

      expect(
        () => findRegionBoundingBox(blank),
        throwsA(isA<StateError>()),
      );
    });
  });
}
