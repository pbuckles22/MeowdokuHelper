/// Spec-only T1 (Halo + Naked Singles) for QA oracle audit.
/// Implements [solver_algorithms.md] Level 1 — do not import production solver.
library;

const int qaSpecEmpty = 0;
const int qaSpecCat = 1;
const int qaSpecBlocked = 2;

int _get(List<int> state, int n, int x, int y) => state[y * n + x];

void _set(List<int> state, int n, int x, int y, int value) {
  state[y * n + x] = value;
}

bool _applyHaloEnforcer(List<int> state, int n) {
  var changed = false;
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      if (_get(state, n, x, y) != qaSpecCat) {
        continue;
      }
      for (var cx = 0; cx < n; cx++) {
        if (_get(state, n, cx, y) == qaSpecEmpty) {
          _set(state, n, cx, y, qaSpecBlocked);
          changed = true;
        }
      }
      for (var cy = 0; cy < n; cy++) {
        if (_get(state, n, x, cy) == qaSpecEmpty) {
          _set(state, n, x, cy, qaSpecBlocked);
          changed = true;
        }
      }
      for (var dy = -1; dy <= 1; dy++) {
        for (var dx = -1; dx <= 1; dx++) {
          if (dx == 0 && dy == 0) {
            continue;
          }
          final nx = x + dx;
          final ny = y + dy;
          if (nx < 0 || ny < 0 || nx >= n || ny >= n) {
            continue;
          }
          if (_get(state, n, nx, ny) == qaSpecEmpty) {
            _set(state, n, nx, ny, qaSpecBlocked);
            changed = true;
          }
        }
      }
    }
  }
  return changed;
}

bool _applyNakedSingles(List<int> state, int n, List<int> regions) {
  var changed = false;

  for (var y = 0; y < n; y++) {
    var emptyCount = 0;
    var emptyX = 0;
    var catCount = 0;
    for (var x = 0; x < n; x++) {
      switch (_get(state, n, x, y)) {
        case qaSpecEmpty:
          emptyCount++;
          emptyX = x;
        case qaSpecCat:
          catCount++;
        default:
          break;
      }
    }
    if (emptyCount == 1 && catCount == 0) {
      _set(state, n, emptyX, y, qaSpecCat);
      changed = true;
    }
  }

  for (var x = 0; x < n; x++) {
    var emptyCount = 0;
    var emptyY = 0;
    var catCount = 0;
    for (var y = 0; y < n; y++) {
      switch (_get(state, n, x, y)) {
        case qaSpecEmpty:
          emptyCount++;
          emptyY = y;
        case qaSpecCat:
          catCount++;
        default:
          break;
      }
    }
    if (emptyCount == 1 && catCount == 0) {
      _set(state, n, x, emptyY, qaSpecCat);
      changed = true;
    }
  }

  final regionIds = regions.toSet().toList()..sort();
  for (final rid in regionIds) {
    var emptyCount = 0;
    var emptyIdx = 0;
    var catCount = 0;
    for (var i = 0; i < state.length; i++) {
      if (regions[i] != rid) {
        continue;
      }
      switch (state[i]) {
        case qaSpecEmpty:
          emptyCount++;
          emptyIdx = i;
        case qaSpecCat:
          catCount++;
        default:
          break;
      }
    }
    if (emptyCount == 1 && catCount == 0) {
      state[emptyIdx] = qaSpecCat;
      changed = true;
    }
  }

  return changed;
}

/// Returns row-major index of the **first new cat** T1 places, or `null` if T1 stalls.
int? qaSpecT1FirstMove(List<int> initialState, List<int> regions, int n) {
  final state = List<int>.from(initialState);
  final initialCats = state.where((c) => c == qaSpecCat).length;

  while (true) {
    var progress = false;
    while (_applyHaloEnforcer(state, n)) {
      progress = true;
    }
    while (_applyNakedSingles(state, n, regions)) {
      progress = true;
      final cats = state.where((c) => c == qaSpecCat).length;
      if (cats > initialCats) {
        for (var i = 0; i < state.length; i++) {
          if (initialState[i] != qaSpecCat && state[i] == qaSpecCat) {
            return i;
          }
        }
      }
      while (_applyHaloEnforcer(state, n)) {
        progress = true;
      }
    }
    if (!progress) {
      return null;
    }
  }
}
