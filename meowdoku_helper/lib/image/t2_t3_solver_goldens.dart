// GENERATED CODE — DO NOT EDIT BY HAND.
// Source of truth: rust/src/solver/*_fixtures.rs (QA-owned oracle).
// Regenerate: ./scripts/generate_solver_goldens.sh
/// Locked parse output + expected move for T2/T3 fixture gate (seq 09–17).
/// Generated from `rust/src/solver/t2_t3_fixtures.rs`. See doc/plan/FIXTURES.md.
class T2T3SolverGolden {
  const T2T3SolverGolden({
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


const _seq09State = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0,
];

const _seq09Regions = [
  6, 3, 2, 2, 7, 4, 4, 6, 5, 5, 2, 7, 7, 4, 6, 5,
  5, 2, 4, 4, 4, 5, 5, 3, 2, 1, 1, 1, 3, 3, 3, 2,
  1, 1, 1, 3, 3, 3, 2, 1, 1, 1, 3, 3, 2, 2, 2, 1,
  1,
];

const _seq10State = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0,
];

const _seq10Regions = [
  1, 1, 1, 1, 1, 1, 1, 1, 5, 1, 2, 1, 1, 1, 1, 2,
  2, 4, 1, 3, 1, 6, 2, 2, 3, 3, 3, 3, 3, 2, 3, 3,
  3, 2, 2, 2,
];

const _seq11State = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0,
];

const _seq11Regions = [
  3, 3, 3, 3, 3, 2, 1, 3, 6, 3, 4, 2, 1, 3, 4, 4,
  4, 2, 1, 1, 1, 2, 4, 2, 1, 2, 2, 2, 2, 2, 1, 1,
  1, 1, 1, 5,
];

const _seq12State = [
  0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0,
  0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 0, 0, 0,
  0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0,
  0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
  0,
];

const _seq12Regions = [
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 5, 7,
  2, 2, 2, 4, 4, 5, 9, 5, 5, 2, 2, 4, 4, 1, 1, 5,
  5, 3, 3, 2, 4, 4, 9, 1, 1, 5, 3, 3, 2, 1, 1, 1,
  1, 1, 5, 3, 3, 2, 1, 6, 1, 1, 1, 1, 3, 3, 3, 6,
  6, 6, 1, 1, 8, 3, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1,
  3,
];

const _seq13State = [
  0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0,
  0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 0, 0, 0,
  0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0,
  0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
  0,
];

const _seq13Regions = [
  2, 3, 3, 3, 3, 3, 1, 1, 1, 2, 3, 3, 6, 6, 3, 3,
  1, 1, 2, 2, 3, 6, 9, 3, 1, 1, 7, 2, 2, 6, 6, 6,
  1, 1, 1, 1, 2, 2, 9, 6, 6, 1, 1, 1, 1, 2, 2, 6,
  6, 6, 6, 8, 1, 1, 4, 2, 2, 5, 5, 5, 5, 1, 1, 4,
  2, 2, 5, 5, 4, 5, 5, 1, 4, 4, 4, 4, 4, 4, 4, 5,
  5,
];

const _seq14State = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];

const _seq14Regions = [
  2, 1, 1, 11, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,
  2, 1, 1, 6, 7, 7, 7, 1, 2, 1, 1, 2, 2, 1, 1, 6,
  6, 7, 1, 1, 11, 11, 1, 1, 11, 11, 11, 12, 6, 7, 11, 11,
  2, 2, 1, 11, 1, 1, 1, 6, 6, 6, 1, 4, 10, 2, 2, 2,
  2, 2, 1, 6, 4, 4, 4, 4, 2, 2, 3, 11, 9, 2, 6, 6,
  4, 4, 3, 4, 2, 8, 3, 11, 6, 6, 6, 3, 3, 3, 3, 4,
  2, 8, 8, 3, 3, 3, 3, 3, 3, 3, 4, 4, 2, 8, 3, 3,
  3, 3, 3, 3, 3, 3, 4, 4, 5, 3, 3, 11, 5, 3, 5, 5,
  3, 3, 3, 4, 5, 5, 5, 12, 5, 5, 5, 4, 4, 4, 4, 4,
];

const _seq15State = [
  0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0,
  0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 0, 0, 0,
  0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0,
  0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
  0,
];

const _seq15Regions = [
  3, 3, 3, 3, 3, 4, 4, 4, 4, 3, 3, 3, 3, 3, 2, 4,
  4, 4, 3, 8, 2, 3, 9, 2, 2, 1, 4, 3, 2, 2, 2, 3,
  2, 1, 1, 1, 3, 2, 9, 2, 2, 2, 1, 1, 1, 3, 3, 3,
  2, 2, 2, 1, 1, 6, 5, 5, 5, 2, 2, 1, 1, 1, 1, 5,
  2, 2, 2, 2, 1, 1, 1, 1, 5, 5, 5, 5, 5, 1, 7, 1,
  1,
];

const _seq16State = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0,
  0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0,
];

const _seq16Regions = [
  2, 2, 2, 2, 10, 10, 2, 2, 2, 2, 2, 4, 2, 4, 10, 10,
  4, 4, 2, 3, 2, 4, 4, 4, 10, 10, 4, 3, 3, 3, 4, 4,
  1, 1, 10, 10, 4, 4, 5, 3, 10, 10, 10, 10, 1, 5, 10, 10,
  10, 10, 10, 9, 10, 10, 1, 5, 5, 10, 10, 10, 6, 6, 6, 1,
  1, 10, 5, 3, 5, 3, 6, 7, 8, 1, 10, 1, 3, 3, 3, 3,
  6, 7, 7, 7, 10, 1, 1, 3, 3, 1, 6, 6, 7, 7, 10, 1,
  1, 1, 1, 1,
];

const _seq17State = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0,
];

const _seq17Regions = [
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 7, 7, 7, 1,
  1, 1, 6, 6, 1, 1, 1, 7, 1, 1, 1, 1, 4, 6, 1, 5,
  5, 1, 1, 4, 4, 4, 4, 6, 2, 5, 1, 1, 1, 1, 4, 4,
  6, 6, 2, 5, 5, 5, 5, 1, 4, 8, 8, 6, 2, 2, 10, 1,
  1, 1, 4, 4, 4, 9, 2, 2, 3, 3, 3, 3, 3, 3, 4, 9,
  2, 2, 3, 2, 2, 3, 2, 3, 4, 3, 2, 2, 2, 2, 2, 2,
  2, 3, 3, 3,
];

const t2T3FixtureGate = <T2T3SolverGolden>[
  T2T3SolverGolden(
    fixture: '09_L10_N7_T2.jpg',
    seq: 9,
    minTier: 2,
    gridSize: 7,
    state: _seq09State,
    regions: _seq09Regions,
    expectedMove: -2,
  ),
  T2T3SolverGolden(
    fixture: '10_L11_T2.jpeg',
    seq: 10,
    minTier: 2,
    gridSize: 6,
    state: _seq10State,
    regions: _seq10Regions,
    expectedMove: -2,
  ),
  T2T3SolverGolden(
    fixture: '11_L12_T2.jpeg',
    seq: 11,
    minTier: 2,
    gridSize: 6,
    state: _seq11State,
    regions: _seq11Regions,
    expectedMove: -2,
  ),
  T2T3SolverGolden(
    fixture: '12_L13_T2.jpeg',
    seq: 12,
    minTier: 2,
    gridSize: 9,
    state: _seq12State,
    regions: _seq12Regions,
    expectedMove: -2,
  ),
  T2T3SolverGolden(
    fixture: '13_L14_T2.jpeg',
    seq: 13,
    minTier: 2,
    gridSize: 9,
    state: _seq13State,
    regions: _seq13Regions,
    expectedMove: -2,
  ),
  T2T3SolverGolden(
    fixture: '14_L15_N10_T3.jpeg',
    seq: 14,
    minTier: 3,
    gridSize: 12,
    state: _seq14State,
    regions: _seq14Regions,
    expectedMove: -2,
  ),
  T2T3SolverGolden(
    fixture: '15_L16_T3.jpeg',
    seq: 15,
    minTier: 3,
    gridSize: 9,
    state: _seq15State,
    regions: _seq15Regions,
    expectedMove: -2,
  ),
  T2T3SolverGolden(
    fixture: '16_L17_T3.jpeg',
    seq: 16,
    minTier: 3,
    gridSize: 10,
    state: _seq16State,
    regions: _seq16Regions,
    expectedMove: -2,
  ),
  T2T3SolverGolden(
    fixture: '17_L18_T3.jpeg',
    seq: 17,
    minTier: 3,
    gridSize: 10,
    state: _seq17State,
    regions: _seq17Regions,
    expectedMove: -2,
  ),
];
