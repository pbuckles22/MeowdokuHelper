# Derivation — tier3-synthetics

**QA session:** 2026-06-12 (Phase 7 Q3 remainder)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md) § Level 3 — Structural Traps  
**Forbidden inputs used:** none (Test 3 uses API only for smoke — see note)

## Algorithm (from spec)

5. **2×2 trap avoidance:** Region empties fit in one 2×2 block → at most one cat there; block other regions’ empties in that block.
6. **N-locked sets:** N consecutive columns (or rows) whose empties span exactly N regions → those regions are locked to those lines; block their empties elsewhere.

**Implementation note (not oracle):** shipped code uses consecutive column/row windows width 2–4 — sufficient for these synthetics.

## Test 1 — `trap_2x2_blocks_other_region_in_shared_block`

**Board:** 4×4; region 1 = (0,0),(1,0),(0,1); region 2 = (1,1); rest region 3. All four top-left cells `EMPTY`.

**Expected:** Region 1 empties fit in 2×2 [0..1]×[0..1]. Cell (1,1) is `EMPTY` but region 2 → `BLOCKED`. (0,0) stays `EMPTY`.

## Test 2 — `locked_sets_blocks_locked_region_outside_column_pair`

**Board:** Same 2×2 layout; add (2,2) to region 1. Empties: full 2×2 plus (2,2).

**Expected:** Columns 0–1 empties span regions {1, 2} — exactly two regions for two columns → locked set. Region 1 empty at (2,2) outside cols 0–1 → `BLOCKED`.

## Test 3 — `tier3_trap_board_returns_forced_cat_via_calculate_next_move`

**Board:** Region 1 = (0,0),(1,0); region 2 = (0,1),(1,1); 2×2 all `EMPTY`.

**Spec expectation:** Board is non-trivial but T1–T3 ladder should make progress (not stuck at `-1`). A forced or branch move exists.

**Test assertion:** `calculate_next_move(...) >= 0` — **smoke only** (no cell-level oracle). Consistent with spec (solvable partial board) but weaker than Tests 1–2.

## Compare to locked tests

- [x] Test 1 matches → spec-verified
- [x] Test 2 matches → spec-verified
- [x] Test 3 matches → spec-verified (smoke; no escalation)

**Escalation:** none — smoke test is intentionally weak; cell-level oracle deferred to fixture gates (Q5).
