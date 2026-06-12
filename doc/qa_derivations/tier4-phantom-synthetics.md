# Derivation — tier4-phantom-synthetics

**QA session:** 2026-06-12 (Phase 7 Q3)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md) § Level 4 — Phantom Cat Projection  
**Forbidden inputs used:** none (spec + product cell encoding only before compare)

## Algorithm (from spec)

1. Regions with **exactly 2 or 3** `EMPTY` cells and **zero** `CAT` in that region.
2. Per candidate empty: halo = row + column + Chebyshev-1 neighbors (exclude self).
3. Intersect halos across all candidates in the region.
4. Every `EMPTY` in the intersection → `BLOCKED` (`2`).
5. Return whether any cell changed.

**Skip:** region has a cat, or empty count ∉ {2, 3}.

## Test 1 — `phantom_blocks_halo_intersection_for_two_candidate_empties`

**Board:** 5×5; default `BLOCKED`; region 1 empties at (1,1), (2,1); region 2 empty at (1,2).

| Region | Empties | Cats | Eligible? |
|--------|---------|------|-----------|
| 1 | (1,1), (2,1) | 0 | yes (2) |
| 2 | (1,2) | 0 | no (count 1) |

**Halo intersection (region 1):** Among board empties, only (1,2) lies in both halos (8-neighbor below-left / shared column-row overlap). (1,1) and (2,1) are candidates — not in their own halos.

**Expected:** `apply_phantom_projection` → `true`; (1,2) → `BLOCKED`; (1,1), (2,1) remain `EMPTY`.

**Spec sentence:** “Cells in that overlap are dead no matter which candidate gets the cat.”

## Test 2 — `phantom_blocks_intersection_for_three_candidate_empties_in_row`

**Board:** 5×5; region 1 empties at (1,1), (2,1), (3,1); region 2 empty at (2,2).

| Region | Empties | Eligible? |
|--------|---------|-----------|
| 1 | row y=1, x=1..3 | yes (3) |
| 2 | (2,2) | no (count 1) |

**Halo intersection (region 1):** (2,2) is Chebyshev-1 from all three candidates (below center; diagonal from ends).

**Expected:** `true`; (2,2) → `BLOCKED` only.

## Test 3 — `phantom_skips_region_with_cat_or_wrong_empty_count`

**Board:** 4×4; region 1: `CAT` at (0,0), one `EMPTY` at (1,0).

**Expected:** `false` — `cat_count > 0` → region skipped per spec step 1.

## Compare to locked tests

- [x] Test 1 matches → spec-verified
- [x] Test 2 matches → spec-verified
- [x] Test 3 matches → spec-verified

**Escalation:** none — implementation aligns with spec on all three synthetics.
