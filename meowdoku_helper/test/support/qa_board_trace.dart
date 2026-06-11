/// QA-only board trace helpers — spec/oracle audit, not production.
/// See doc/QA_ORACLE_AUDIT.md. Do not import from lib/.
library;

const int qaEmpty = 0;
const int qaCat = 1;
const int qaBlocked = 2;

/// Row-major index → (x, y).
(int x, int y) qaCoord(int index, int gridSize) {
  return (index % gridSize, index ~/ gridSize);
}

/// Spec precondition: next-move index must point at an EMPTY cell.
bool qaExpectedMoveIsEmpty(List<int> state, int expectedMove) {
  return expectedMove >= 0 &&
      expectedMove < state.length &&
      state[expectedMove] == qaEmpty;
}

/// ASCII trace for human oracle review (parse output only).
String qaBoardTrace({
  required String fixture,
  required int gridSize,
  required List<int> state,
  required List<int> regions,
  required int expectedMove,
}) {
  final (ex, ey) = qaCoord(expectedMove, gridSize);
  final buf = StringBuffer()
    ..writeln('fixture: $fixture')
    ..writeln('gridSize: $gridSize')
    ..writeln('expectedMove: $expectedMove (x=$ex, y=$ey)')
    ..writeln('state[expectedMove]==EMPTY: ${qaExpectedMoveIsEmpty(state, expectedMove)}')
    ..writeln();

  for (var y = 0; y < gridSize; y++) {
    for (var x = 0; x < gridSize; x++) {
      final i = y * gridSize + x;
      final cell = switch (state[i]) {
        qaEmpty => '.',
        qaCat => '*',
        qaBlocked => 'X',
        _ => '?',
      };
      final mark = (x == ex && y == ey) ? '>' : ' ';
      buf.write('$mark$cell${regions[i].toString().padLeft(2)}');
    }
    buf.writeln();
  }
  return buf.toString();
}
