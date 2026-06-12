/// Locked parse output for Phase 2 golden fixtures (seq 01–08).
class GridGolden {
  const GridGolden({
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

/// seq-01 — `01_L-early_N4_T1.jpg` (N=4 tutorial).
const seq01Golden = GridGolden(
  fixture: '01_L-early_N4_T1.jpg',
  gridSize: 4,
  state: [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  regions: [2, 1, 3, 1, 2, 1, 1, 1, 2, 2, 3, 1, 2, 3, 3, 1],
  expectedMove: 4,
);

/// seq-02 — `02_L03_N6_T1.jpg` (N=6 level 3).
const seq02Golden = GridGolden(
  fixture: '02_L03_N6_T1.jpg',
  gridSize: 6,
  state: [
    0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  ],
  regions: [
    2, 2, 2, 2, 2, 3, 2, 1, 6, 2, 2, 2, 5, 1, 1, 1, 1, 2, 1, 1, 3, 3, 2, 2,
    1, 1, 3, 3, 3, 3, 1, 1, 1, 1, 4, 3,
  ],
  expectedMove: 8,
);

/// seq-03 — `03_L04_T1.jpg` (N=6 level 4). Parse-lock only (`expectedMove: -1`).
const seq03Golden = GridGolden(
  fixture: '03_L04_T1.jpg',
  gridSize: 6,
  state: [
    0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  ],
  regions: [
    1, 3, 3, 3, 3, 3, 1, 2, 2, 2, 2, 3, 1, 1, 1, 2, 2, 4, 1, 1, 1, 1, 2, 2,
    1, 1, 1, 6, 1, 2, 1, 5, 1, 1, 1, 1,
  ],
  expectedMove: -1,
);

/// seq-04 — `04_L05_T1.jpg` (N=10 level 5). Parse-lock only.
const seq04Golden = GridGolden(
  fixture: '04_L05_T1.jpg',
  gridSize: 10,
  state: [
    0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2,
    0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 2,
    2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0,
    0, 2, 0, 0,
  ],
  regions: [
    4, 4, 4, 4, 4, 4, 4, 10, 4, 4, 4, 3, 5, 4, 4, 1, 4, 10, 2, 7, 4, 10, 3, 4,
    4, 1, 10, 4, 10, 10, 4, 3, 3, 1, 4, 1, 1, 1, 2, 2, 3, 3, 3, 1, 1, 1, 2, 2,
    2, 2, 3, 3, 3, 3, 1, 2, 2, 2, 2, 2, 8, 3, 10, 1, 1, 1, 2, 10, 1, 2, 8, 10,
    3, 1, 1, 1, 10, 2, 1, 2, 3, 3, 3, 3, 6, 1, 1, 1, 1, 2, 3, 9, 9, 3, 3, 1,
    1, 1, 2, 2,
  ],
  expectedMove: -1,
);

/// seq-05 — `05_L06_T1.jpg` (N=6 level 6). Parse-lock only.
const seq05Golden = GridGolden(
  fixture: '05_L06_T1.jpg',
  gridSize: 6,
  state: [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  ],
  regions: [
    2, 3, 6, 3, 3, 1, 2, 3, 3, 3, 2, 1, 2, 2, 3, 1, 1, 1, 2, 2, 2, 5, 1, 1,
    2, 2, 2, 2, 1, 1, 4, 2, 1, 1, 1, 1,
  ],
  expectedMove: -1,
);

/// seq-06 — `06_L07_T1.jpg` (N=5 level 7). Parse-lock only.
const seq06Golden = GridGolden(
  fixture: '06_L07_T1.jpg',
  gridSize: 5,
  state: [0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 2, 2, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0],
  regions: [1, 1, 1, 2, 2, 1, 1, 1, 2, 5, 1, 1, 1, 1, 2, 3, 1, 3, 2, 2, 3, 3, 3, 3, 3],
  expectedMove: -1,
);

/// seq-07 — `07_L08_T1.jpg` (N=7 level 8). Parse-lock only.
const seq07Golden = GridGolden(
  fixture: '07_L08_T1.jpg',
  gridSize: 7,
  state: [
    0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 2, 2,
    2, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
  ],
  regions: [
    5, 5, 5, 5, 1, 7, 4, 1, 5, 1, 1, 1, 2, 4, 1, 1, 1, 1, 1, 2, 4, 7, 1, 1,
    3, 2, 6, 4, 3, 1, 1, 3, 3, 2, 4, 3, 6, 1, 6, 3, 2, 4, 3, 3, 3, 3, 3, 2, 2,
  ],
  expectedMove: -1,
);

/// seq-08 — `08_L09_N9_T1.jpg` (N=8 level 9). Parse-lock only.
const seq08Golden = GridGolden(
  fixture: '08_L09_N9_T1.jpg',
  gridSize: 8,
  state: [
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  ],
  regions: [
    1, 1, 1, 1, 1, 1, 6, 8, 1, 4, 1, 1, 1, 1, 6, 2, 1, 4, 4, 1, 1, 6, 6, 2,
    1, 5, 4, 1, 1, 1, 2, 2, 5, 5, 4, 3, 3, 3, 2, 2, 5, 7, 4, 3, 3, 2, 2, 2,
    5, 4, 4, 4, 3, 3, 3, 2, 5, 5, 5, 3, 3, 2, 2, 2,
  ],
  expectedMove: -1,
);

/// All Phase 2 parse goldens (locked `state`/`regions`).
const phase2ParseGoldens = [
  seq01Golden,
  seq02Golden,
  seq03Golden,
  seq04Golden,
  seq05Golden,
  seq06Golden,
  seq07Golden,
  seq08Golden,
];

/// Fixtures with locked solve oracle (`expectedMove >= 0`).
const phase2SolveGoldens = [seq01Golden, seq02Golden];

/// Back-compat alias for solve tests.
const phase2Goldens = phase2SolveGoldens;
