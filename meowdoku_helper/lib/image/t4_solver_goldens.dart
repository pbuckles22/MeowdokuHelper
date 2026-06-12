/// Locked parse output + expected move for T4 fixture gate (seq 18–19).
/// QA-owned oracle — mirrors `rust/src/solver/t4_fixtures.rs`.
/// Coder must not edit to force green. See doc/plan/FIXTURES.md.
class T4SolverGolden {
  const T4SolverGolden({
    required this.fixture,
    required this.seq,
    required this.minTier,
    required this.gridSize,
    required this.state,
    required this.regions,
    required this.expectedMove,
  });

  final String fixture;
  final int seq;
  final int minTier;
  final int gridSize;
  final List<int> state;
  final List<int> regions;
  final int expectedMove;
}

const _seq18State = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0,
  2, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0,
];

const _seq18Regions = [
  4, 4, 4, 5, 3, 5, 3, 6, 6, 6, 4, 9, 5, 5, 10, 3, 3, 3, 3, 6, 4, 5, 5, 3, 10,
  10, 2, 2, 7, 6, 4, 3, 3, 3, 10, 10, 2, 7, 7, 7, 10, 10, 10, 10, 3, 2, 10, 10,
  10, 10, 4, 3, 10, 10, 2, 2, 2, 2, 2, 2, 4, 3, 3, 1, 10, 2, 2, 1, 2, 1, 4, 3,
  1, 1, 10, 1, 1, 1, 2, 1, 4, 3, 8, 8, 10, 1, 2, 2, 2, 1, 4, 4, 4, 1, 10, 1, 1,
  1, 1, 1,
];

const _seq19State = [
  0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2,
  0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0,
  0, 2, 0, 0, 0, 0,
];

const _seq19Regions = [
  4, 7, 2, 2, 2, 2, 2, 1, 1, 4, 7, 5, 5, 5, 5, 2, 1, 1, 4, 7, 7, 5, 9, 5, 2,
  1, 1, 4, 4, 2, 2, 5, 2, 2, 1, 1, 4, 4, 9, 2, 2, 2, 2, 1, 1, 4, 3, 2, 1, 1,
  1, 1, 1, 1, 3, 3, 2, 1, 1, 1, 1, 1, 1, 3, 3, 2, 2, 2, 2, 2, 6, 6, 3, 3, 8,
  8, 8, 8, 8, 6, 6,
];

const List<T4SolverGolden> t4FixtureGate = [
  T4SolverGolden(
    fixture: '18_L19_T4.jpeg',
    seq: 18,
    minTier: 4,
    gridSize: 10,
    state: _seq18State,
    regions: _seq18Regions,
    expectedMove: -2,
  ),
  T4SolverGolden(
    fixture: '19_L20_T4.jpeg',
    seq: 19,
    minTier: 4,
    gridSize: 9,
    state: _seq19State,
    regions: _seq19Regions,
    expectedMove: -2,
  ),
];
