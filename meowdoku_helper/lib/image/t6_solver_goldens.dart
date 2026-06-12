/// Locked parse output + expected move for T6 fixture gate (seq 22–30).
/// QA-owned oracle (regression-lock — P1 re-audit). Mirrors `rust/src/solver/t6_fixtures.rs`.
/// Coder must not edit to force green. See doc/plan/FIXTURES.md.
class T6SolverGolden {
  const T6SolverGolden({
    required this.fixture,
    required this.gridSize,
    required this.state,
    required this.regions,
    required this.expectedMove,
  });

  final String fixture;
  final int gridSize;
  final List<int> state;
  final List<int> regions;
  final int expectedMove;
}

const _seq22Regions = [
  8, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 6, 6, 5, 5, 3, 6, 6, 6, 6, 5, 5, 5, 5, 1, 2, 2, 2, 2, 2, 5, 2,
  1, 2, 2, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 4, 1, 7, 1, 1, 4, 4, 1, 4, 4, 4, 4, 4, 4, 4,
];

const _seq23Regions = [
  1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 5, 5, 5, 5, 3, 3, 1, 4, 1, 5, 3, 3, 5, 3, 1, 1, 4, 5, 5, 7, 3,
  5, 3, 1, 1, 4, 4, 5, 7, 3, 3, 3, 3, 1, 4, 4, 2, 7, 6, 3, 8, 8, 1, 4, 2, 2, 7, 6, 1, 1, 1, 1, 4,
  4, 2, 6, 6, 6, 9, 2, 1, 4, 2, 2, 2, 2, 2, 2, 2, 2,
];

const _seq24State = [
  0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0,
  0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
  0, 0, 0, 0,
];
const _seq24Regions = [
  5, 5, 5, 5, 2, 5, 5, 5, 8, 8, 5, 4, 4, 4, 6, 4, 2, 5, 5, 5, 4, 4, 1, 4, 6, 3, 2, 2, 2, 2, 4, 4,
  1, 4, 3, 3, 2, 3, 2, 2, 6, 3, 3, 3, 4, 1, 2, 3, 6, 6, 6, 3, 3, 3, 1, 1, 2, 3, 6, 2, 1, 1, 1, 3,
  3, 3, 3, 3, 6, 2, 7, 7, 1, 1, 2, 1, 3, 6, 6, 2, 7, 7, 1, 1, 3, 3, 3, 6, 6, 6, 1, 1, 1, 3, 3, 3,
  3, 6, 9, 6,
];

const _seq25State = [
  0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0,
  2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
  0, 0, 0, 0,
];
const _seq25Regions = [
  1, 9, 1, 1, 5, 5, 5, 5, 5, 3, 1, 1, 1, 5, 5, 5, 1, 1, 5, 3, 1, 2, 1, 1, 2, 7, 1, 6, 6, 3, 1, 2,
  1, 1, 2, 5, 6, 6, 2, 3, 2, 2, 7, 2, 1, 1, 6, 5, 2, 2, 1, 2, 2, 5, 1, 2, 6, 8, 2, 3, 1, 4, 2, 2,
  2, 2, 2, 2, 2, 3, 1, 4, 4, 7, 2, 7, 2, 3, 3, 3, 1, 4, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4, 4, 4, 4, 4,
  3, 3, 3, 3,
];

const _seq26Regions = [
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 7, 7, 7, 7, 1, 1, 8, 4, 4, 6, 6, 6, 2, 1, 1, 8, 4, 6, 6, 3, 6,
  2, 1, 8, 8, 4, 4, 4, 3, 2, 2, 1, 1, 2, 5, 5, 4, 3, 2, 1, 1, 2, 2, 5, 3, 3, 3, 2, 2, 1, 1, 2, 5,
  5, 3, 3, 2, 2, 2, 1, 2, 5, 9, 3, 3, 2, 2, 2, 2, 2,
];

const _seq27Regions = [
  2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 4, 4, 2, 2, 2, 3, 2, 3, 4, 4, 2, 2, 3, 3, 3, 2, 3, 4, 4, 1, 1, 1,
  3, 3, 3, 3, 4, 4, 4, 4, 1, 3, 7, 7, 7, 6, 1, 1, 1, 1, 3, 3, 3, 5, 6, 6, 6, 6, 1, 1, 5, 5, 5, 1,
  1, 1, 1, 1, 5, 5, 5, 8, 9, 9, 1, 1, 1, 1, 5, 8, 8,
];

const _seq28State = [
  0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0,
  0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
  0, 0, 0, 0,
];
const _seq28Regions = [
  6, 6, 6, 2, 10, 2, 2, 2, 2, 2, 6, 6, 5, 5, 5, 5, 2, 2, 2, 2, 7, 4, 4, 4, 2, 9, 3, 3, 3, 2, 7, 7,
  7, 4, 6, 10, 3, 8, 3, 2, 7, 4, 4, 4, 4, 5, 7, 8, 3, 2, 7, 4, 4, 10, 4, 5, 3, 8, 3, 2, 1, 1, 9, 4,
  4, 5, 3, 8, 3, 2, 1, 4, 4, 4, 4, 5, 3, 3, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1,
  1, 1, 2,
];

const _seq29Regions = [
  1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 3, 1, 1, 2, 2, 1, 10, 6, 6, 6, 3, 1, 1, 1, 2, 1, 1, 6, 5, 5, 3, 3,
  1, 2, 2, 6, 6, 6, 6, 5, 3, 1, 1, 2, 2, 2, 2, 2, 6, 5, 3, 2, 2, 2, 4, 2, 7, 2, 2, 5, 3, 2, 3, 4,
  4, 4, 7, 2, 5, 5, 3, 2, 3, 4, 7, 4, 7, 8, 9, 5, 3, 3, 3, 4, 7, 7, 7, 8, 5, 5, 3, 4, 4, 4, 4, 4,
  4, 8, 5, 5,
];

const _seq30Regions = [
  2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 2, 2, 3, 3, 3, 3, 3, 3, 1, 3, 2, 1, 1, 1, 3, 1, 1, 1, 1, 3, 2, 2,
  2, 1, 3, 3, 1, 1, 6, 3, 2, 9, 2, 1, 1, 3, 1, 6, 6, 3, 9, 9, 2, 7, 1, 1, 1, 1, 6, 6, 5, 4, 4, 7,
  7, 4, 1, 1, 1, 6, 5, 5, 4, 4, 4, 4, 4, 4, 1, 6, 5, 5, 4, 5, 4, 10, 8, 8, 1, 6, 5, 5, 5, 5, 4, 4,
  4, 8, 6, 6,
];

List<int> _zeros(int n) => List<int>.filled(n, 0);

/// seq 22–30 gate — parse locked; solve indices from T1–T5 (US-7.2: -2 only when T6 alone advances).
final t6FixtureGate = <T6SolverGolden>[
  T6SolverGolden(
    fixture: '22_L31_N8_T6.jpeg',
    gridSize: 8,
    state: _zeros(64),
    regions: _seq22Regions,
    expectedMove: 0,
  ),
  T6SolverGolden(
    fixture: '23_L22_N9_T6.jpeg',
    gridSize: 9,
    state: _zeros(81),
    regions: _seq23Regions,
    expectedMove: 8,
  ),
  T6SolverGolden(
    fixture: '24_L27_N9_T6.jpeg',
    gridSize: 10,
    state: _seq24State,
    regions: _seq24Regions,
    expectedMove: 9,
  ),
  T6SolverGolden(
    fixture: '25_L32_N9_T6.jpeg',
    gridSize: 10,
    state: _seq25State,
    regions: _seq25Regions,
    expectedMove: 1,
  ),
  T6SolverGolden(
    fixture: '26_L29_N9_T6.jpeg',
    gridSize: 9,
    state: _zeros(81),
    regions: _seq26Regions,
    expectedMove: 7,
  ),
  T6SolverGolden(
    fixture: '27_L24_N9_T6.jpeg',
    gridSize: 9,
    state: _zeros(81),
    regions: _seq27Regions,
    expectedMove: 4,
  ),
  T6SolverGolden(
    fixture: '28_L30_N9_T6.jpeg',
    gridSize: 10,
    state: _seq28State,
    regions: _seq28Regions,
    expectedMove: 9,
  ),
  T6SolverGolden(
    fixture: '29_L23_N10_T6.jpeg',
    gridSize: 10,
    state: _zeros(100),
    regions: _seq29Regions,
    expectedMove: 2,
  ),
  T6SolverGolden(
    fixture: '30_L25_N10_T6.jpeg',
    gridSize: 10,
    state: _zeros(100),
    regions: _seq30Regions,
    expectedMove: 6,
  ),
];
