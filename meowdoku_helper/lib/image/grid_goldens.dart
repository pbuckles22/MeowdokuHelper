/// Locked parse output for Phase 2 golden fixtures (seq 01 + 02).
class GridGolden {
  const GridGolden({
    required this.fixture,
    required this.gridSize,
    required this.state,
    required this.regions,
  });

  final String fixture;
  final int gridSize;
  final List<int> state;
  final List<int> regions;
}

/// seq-01 — `01_L-early_N4_T1.jpg` (N=4 tutorial).
const seq01Golden = GridGolden(
  fixture: '01_L-early_N4_T1.jpg',
  gridSize: 4,
  state: [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  regions: [2, 1, 3, 1, 2, 1, 1, 1, 2, 2, 3, 1, 2, 3, 3, 1],
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
);

const phase2Goldens = [seq01Golden, seq02Golden];
