# Derivation — tier2-synthetics

**QA session:** 2026-06-12 (Phase 7 Q3 remainder)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md) § Level 2 — Intersection Logic  
**Forbidden inputs used:** none

## Algorithm (from spec)

3. **Region-claims-line:** All empties in a color region lie on one row (or column) → block other empties on that line outside the region.
4. **Line-claims-region:** A row/column’s only empties belong to one region → block that region’s empties outside the line.

**Loop:** On any block, drop back to T1.

## Test 1 — `region_claims_line_blocks_outside_empties_on_shared_row`

**Board:** 4×4 quadrant regions; region 1 empties at (0,0), (1,0), (2,0) — all on row 0.

**Expected:** Row 0 is claimed by region 1. (2,0) is `EMPTY` on row 0 but outside region 1 (quadrant 2) → `BLOCKED`. (0,0), (1,0) stay `EMPTY`.

## Test 2 — `line_claims_region_blocks_region_empties_off_line`

**Board:** 4×4 quadrant; empties at (0,0) and (0,1) — both region 1 (top-left quadrant).

**Expected:** Row 0’s only empties are region 1 → block region 1 empties off row 0. (0,1) at y=1 → `BLOCKED`. (0,0) on row 0 stays `EMPTY`.

## Test 3 — `tier1_stalls_then_tier2_enables_naked_single`

**Board:** 4×4 quadrant; region 1 top-left 2×2 all `EMPTY`: (0,0), (1,0), (0,1), (1,1).

**Expected trace:**

1. `run_tier1` → no naked singles (region 1 has four empties) → `false`.
2. Line-claims-region on row 0 → blocks (0,1) and (1,1) (region 1 off row 0).
3. T1 restart → column 0 has single empty (0,0) → `CAT` at (0,0).

**`run_tiers_1_and_2`:** returns `true`; (0,0) = `CAT`.

## Compare to locked tests

- [x] Test 1 matches → spec-verified
- [x] Test 2 matches → spec-verified
- [x] Test 3 matches → spec-verified

**Escalation:** none.
