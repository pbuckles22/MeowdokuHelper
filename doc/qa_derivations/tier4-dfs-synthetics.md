# Derivation — tier4-dfs-synthetics

**QA session:** 2026-06-12 (Phase 7 Q3 remainder)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md) § Level 6 — DFS / Bifurcation  
**Module:** `tier4.rs` (DFS helpers: `is_illegal`, `is_solved`, `dfs_bifurcation`)  
**Forbidden inputs used:** none (Test 4 compares to API after manual trace)

## Helpers (from spec + product rules)

- **Illegal:** row/col/region with >1 cat, or 0 cats and 0 empties.
- **Solved:** every row, col, region has exactly 1 cat.
- **DFS bifurcation:** MRV empty; try cat + T1–T5 propagation; on illegal revert and block; on solve commit cat.

## Test 1 — `illegal_when_row_has_no_cats_and_no_empties`

**Board:** 4×4 all `BLOCKED`.

**Expected:** Each row has 0 cats, 0 empties → `is_illegal` = `true`.

## Test 2 — `solved_when_each_line_and_region_has_one_cat`

**Board:** 4×4 quadrant; cats at (0,0), (2,1), (1,2), (3,3) — one per row/col/region.

**Expected:** `is_solved` = `true`.

## Test 3 — `dfs_finds_cat_when_tiers_stall`

**Board:** Cats (0,0), (2,1), (1,2); empties (2,3) region 3, (3,3) region 4.

**Manual trace:**

1. T1–T5 stall (two empties, no deterministic deduction).
2. Try (2,3): col 2 already has cat at (2,1) → second cat in column → **illegal** → block (2,3).
3. Remaining empty (3,3) → place `CAT` (completes grid).

**Expected:** First `dfs_bifurcation` → (2,3) `BLOCKED`; second → (3,3) `CAT`.

## Test 4 — `tier6_board_returns_forced_cat_via_calculate_next_move`

**Board:** Same as Test 3 (initial state).

**Expected from trace:** Winning next move is cat at (3,3) = linear index `idx(3,3,4)` = 15.

**Compare:** Test asserts `calculate_next_move == 15` — matches manual trace (not captured from solver in this QA session).

## Compare to locked tests

- [x] Test 1 matches → spec-verified
- [x] Test 2 matches → spec-verified
- [x] Test 3 matches → spec-verified
- [x] Test 4 matches → spec-verified

**Escalation:** none.
