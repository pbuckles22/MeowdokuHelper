import 'dart:io';

/// Board screenshot fixtures at repo-root `assets/test_fixtures/` (doc/plan/FIXTURES.md).
class BoardFixture {
  BoardFixture._();

  static Directory? _fixturesDir;

  /// Resolves `assets/test_fixtures/` from repo root (parent of `meowdoku_helper/`).
  static Directory fixturesDirectory() {
    final cached = _fixturesDir;
    if (cached != null) {
      return cached;
    }

    var dir = Directory.current;
    while (true) {
      final candidate = Directory('${dir.path}/assets/test_fixtures');
      if (candidate.existsSync()) {
        _fixturesDir = candidate;
        return candidate;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) {
        break;
      }
      dir = parent;
    }

    throw StateError(
      'Could not find assets/test_fixtures — see doc/plan/FIXTURES.md',
    );
  }

  /// Reads raw bytes for [filename] (e.g. `EarlyGame.jpg`).
  static Future<List<int>> readBytes(String filename) async {
    final file = File('${fixturesDirectory().path}/$filename');
    if (!file.existsSync()) {
      throw StateError('Fixture not found: $filename');
    }
    return file.readAsBytes();
  }
}
