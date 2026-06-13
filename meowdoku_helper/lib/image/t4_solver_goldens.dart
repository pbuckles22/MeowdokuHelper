// GENERATED CODE — DO NOT EDIT BY HAND.
// Source of truth: rust/src/solver/*_fixtures.rs (QA-owned oracle).
// Regenerate: ./scripts/generate_solver_goldens.sh
/// Locked parse output + expected move for T4 fixture gate (seq 18–19).
/// Generated from `rust/src/solver/t4_fixtures.rs`. See doc/plan/FIXTURES.md.
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
  10, 2, 2, 7, 6, 4, 3, 3, 3, 10, 10, 2, 7, 7, 7, 10, 10, 10, 10, 3, 2, 10, 10, 10, 10,
  4, 3, 10, 10, 2, 2, 2, 2, 2, 2, 4, 3, 3, 1, 10, 2, 2, 1, 2, 1, 4, 3, 1, 1, 10,
  1, 1, 1, 2, 1, 4, 3, 8, 8, 10, 1, 2, 2, 2, 1, 4, 4, 4, 1, 10, 1, 1, 1, 1, 1,
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

const _seq21State = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];

const _seq21Regions = [
  5, 5, 5, 5, 5, 5, 2, 2, 5, 4, 5, 2, 2, 2, 2, 2, 7, 4, 4, 4, 4, 2, 3, 2, 4,
  4, 4, 3, 2, 2, 3, 2, 4, 6, 6, 3, 3, 3, 3, 2, 6, 6, 3, 3, 1, 3, 3, 3, 1, 6,
  6, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 1,
];

const _seq31State = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];

const _seq31Regions = [
  1, 5, 5, 6, 6, 6, 6, 6, 7, 7, 1, 1, 5, 6, 5, 6, 5, 6, 6, 7, 1, 3, 5, 5, 5,
  5, 5, 8, 8, 7, 1, 3, 5, 3, 3, 3, 5, 3, 8, 7, 1, 3, 3, 3, 3, 3, 3, 3, 8, 2,
  1, 1, 1, 1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 4, 4, 4, 2, 2, 9, 2, 1, 1, 4, 4, 2,
  4, 9, 9, 9, 2, 1, 4, 4, 2, 2, 2, 2, 10, 10, 2, 1, 1, 4, 4, 4, 2, 2, 2, 2, 2,
];

const _seq32State = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];

const _seq32Regions = [
  2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 3, 3,
  4, 1, 1, 1, 8, 2, 3, 2, 2, 3, 4, 4, 1, 8, 8, 2, 2, 2, 2, 3, 4, 1, 1, 8, 1,
  2, 2, 7, 2, 4, 4, 4, 1, 1, 1, 2, 7, 7, 2, 4, 1, 1, 1, 5, 1, 2, 2, 7, 4, 4,
  1, 6, 5, 5, 1, 10, 2, 2, 6, 6, 6, 6, 6, 5, 5, 10, 2, 9, 9, 9, 6, 5, 5, 5, 5,
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
  T4SolverGolden(
    fixture: '21_L26_N8_T4.jpeg',
    seq: 21,
    minTier: 4,
    gridSize: 8,
    state: _seq21State,
    regions: _seq21Regions,
    expectedMove: -2,
  ),
  T4SolverGolden(
    fixture: '31_L28_N10_T4.jpeg',
    seq: 31,
    minTier: 4,
    gridSize: 10,
    state: _seq31State,
    regions: _seq31Regions,
    expectedMove: -2,
  ),
  T4SolverGolden(
    fixture: '32_L33_N10_T4.jpeg',
    seq: 32,
    minTier: 4,
    gridSize: 10,
    state: _seq32State,
    regions: _seq32Regions,
    expectedMove: -2,
  ),
];
