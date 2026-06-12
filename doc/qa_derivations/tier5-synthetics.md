# Derivation — tier5-synthetics

**QA session:** 2026-06-12 (Phase 7 Q3 remainder)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md) § Level 5 — Region-to-Region Crowding  
**Forbidden inputs used:** none

## Algorithm (from spec)

For each `EMPTY` in region A:

1. Simulate `CAT` + Halo Enforcer.
2. Find adjacent regions B (cells in halo footprint, excluding A).
3. If any B has 0 remaining empties → mutual destruction → permanently `BLOCKED` the trial cell in A.

## Fixture layout — `crowding_trap_board`

**Board:** 6×6; region 2 = single cell (3,1); region 1 = everything else.

**Empties:** row y=2 at x=2,3,4,5 (region 1); (3,1) (region 2 — sole empty in region 2).

## Test 1 — `crowding_blocks_empty_that_would_destroy_adjacent_region`

**Per-candidate simulation (region 1, row y=2):**

| Cell | Halo reaches (3,1)? | Region 2 empties after sim | Result |
|------|---------------------|----------------------------|--------|
| (3,2) | yes (8-neighbor) | 0 | BLOCK |
| (4,2) | yes | 0 | BLOCK |
| (2,2) | yes | 0 | BLOCK |
| (5,2) | no (Chebyshev distance > 1) | 1 | keep EMPTY |

**Expected:** (5,2) and (3,1) stay `EMPTY`; (2,2),(3,2),(4,2) → `BLOCKED`.

## Test 2 — `crowding_skips_when_no_adjacent_region_in_halo`

**Board:** 3×3 uniform region 1; single empty (1,1).

**Expected:** No adjacent region in halo → no destruction → `false`; (1,1) unchanged.

## Test 3 — `crowding_deduces_when_phantom_stalls`

**Board:** `crowding_trap_board`; phantom projection first.

**Expected:** Phantom ineligible (wrong empty counts per region) → `false`. Crowding then blocks (3,2) as in Test 1.

## Compare to locked tests

- [x] Test 1 matches → spec-verified
- [x] Test 2 matches → spec-verified
- [x] Test 3 matches → spec-verified

**Escalation:** none.
