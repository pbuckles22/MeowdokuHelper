import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/image/board_fixture.dart';

void main() {
  group('BoardFixture errors', () {
    test('throws when fixture file is missing', () async {
      expect(
        () => BoardFixture.readBytes('no_such_fixture.jpg'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
