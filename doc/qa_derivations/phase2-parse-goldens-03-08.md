# Derivation — phase2-parse-goldens (seq 03–08)

**QA session:** 2026-06-12 (Phase 7 Q4)  
**Spec:** [product.md](../requirements/product.md) cell encoding; parser pipeline  
**Forbidden inputs used:** none (parser output at lock time only)

## Method

1. Run `parseGridFromImage(decodeJpegImage(bytes))` on each fixture (one-off dump test).
2. Lock `gridSize`, `state`, `regions` in `grid_goldens.dart`.
3. `expectedMove: -1` — parse-lock only; solve oracle not claimed (seq 01–02 unchanged).

## Locked N (parser output)

| Seq | Fixture | N | Cats in state |
|-----|---------|---|---------------|
| 03 | `03_L04_T1.jpg` | 6 | 1 |
| 04 | `04_L05_T1.jpg` | 10 | 0 (pre-placed X marks) |
| 05 | `05_L06_T1.jpg` | 6 | 1 |
| 06 | `06_L07_T1.jpg` | 5 | 0 |
| 07 | `07_L08_T1.jpg` | 7 | 0 |
| 08 | `08_L09_N9_T1.jpg` | 8 | 1 |

## Validation

- `grid_golden_test.dart` — 8/8 parse goldens match locked arrays
- `parse_ladder_test.dart` — smoke retained (range checks)
- `solve_parsed_grid_test.dart` — still seq 01–02 only

## Compare to locked test

- [x] matches → regression-accepted (parse-lock)

**Escalation:** none — parser stable on current assets.
