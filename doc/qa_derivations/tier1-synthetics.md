# Derivation — tier1-synthetics

**QA session:** 2026-06-12 (Phase 7 Q3 remainder)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md) § Level 1 — The Sweepers  
**Forbidden inputs used:** none (spec + cell encoding only before compare)

## Algorithm (from spec)

1. **Halo Enforcer:** For each cat, mark every `EMPTY` in its row, column, and Chebyshev-1 neighborhood as `BLOCKED`.
2. **Naked Singles:** If a row, column, or region has exactly one `EMPTY` and zero cats, place `CAT` there.
3. **Loop:** Halo → Naked Singles; restart on cat placement; stop when a full pass makes no changes.

## Test 1 — `halo_enforcer_blocks_row_col_and_neighbors`

**Board:** 9×9 checkerboard regions; all `BLOCKED` except `CAT` at (4, 4).

**Expected from spec:** Every `EMPTY` in row 4, column 4, and 8-neighbor halo of (4,4) becomes `BLOCKED`. Center stays `CAT`. Function returns `true` (changes made).

**Sample checks:** (3,3), (5,5) blocked (diagonal neighbors); (0,4), (4,0) blocked (row/col).

## Test 2 — `naked_single_places_cat_in_row_choke_point`

**Board:** 9×9 checkerboard; single `EMPTY` at (4, 5); rest `BLOCKED`.

**Expected:** Row 5 has one empty, zero cats → naked single places `CAT` at (4, 5). Returns `true`.

## Test 3 — `tier1_run_places_cat_at_row_choke_point`

**Board:** 9×9; `CAT` at (4, 4); single `EMPTY` at (2, 8); rest `BLOCKED`.

**Expected:** Halo pass may block neighbors of (4,4) but (2,8) survives (not in halo). Row 8: one empty, zero cats → `run_tier1` places `CAT` at (2, 8).

## Compare to locked tests

- [x] Test 1 matches → spec-verified
- [x] Test 2 matches → spec-verified
- [x] Test 3 matches → spec-verified

**Escalation:** none.
