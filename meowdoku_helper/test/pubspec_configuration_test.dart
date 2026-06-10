import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Pubspec configuration', () {
    late Map<dynamic, dynamic> pubspecYaml;

    setUpAll(() {
      final pubspecFile = File('pubspec.yaml');
      expect(pubspecFile.existsSync(), isTrue);
      pubspecYaml =
          loadYaml(pubspecFile.readAsStringSync()) as Map<dynamic, dynamic>;
    });

    test('project metadata', () {
      expect(pubspecYaml['name'], equals('meowdoku_helper'));
      expect(pubspecYaml['description'], contains('Star Battle'));
      expect(pubspecYaml['publish_to'], equals('none'));
    });

    test('FFI dependencies present', () {
      final dependencies = pubspecYaml['dependencies'] as Map<dynamic, dynamic>;
      expect(dependencies['flutter_rust_bridge'], equals('2.12.0'));
      expect(dependencies['rust_lib_meowdoku_helper'], isNotNull);
    });

    test('Wordle word-list assets removed', () {
      final flutter = pubspecYaml['flutter'] as Map<dynamic, dynamic>?;
      final assets = flutter?['assets'] as List<dynamic>?;
      if (assets != null) {
        expect(assets, isNot(contains('assets/word_lists/')));
      }
    });
  });
}
