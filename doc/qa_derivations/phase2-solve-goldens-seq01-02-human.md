# Derivation — phase2-solve-goldens (seq 01–02)

**QA session:** 2026-06-12 (Phase 7 Q6)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md) Level 1 (T1)  
**Forbidden inputs used:** none — spec-only T1 re-implementation in `test/support/qa_t1_from_spec.dart`

## Method

1. **Parse-lock:** Already locked in `grid_goldens.dart` (Phase 2); re-verified via `parseGridFromImage` in `qa_p2_oracle_audit_test.dart`.
2. **Solve oracle:** Independent T1 trace (Halo Enforcer → Naked Singles loop) per spec § Level 1.
3. **Compare:** Spec T1 first new cat index vs locked `expectedMove` in `grid_goldens.dart`.
4. **Solver regression:** `solveParsedGrid` returns same index (FFI smoke in audit test).

## Locked oracles

| Seq | Fixture | Parser N | Move | (x,y) | T1 spec match | Solver match |
|-----|---------|----------|------|-------|---------------|--------------|
| 01 | `01_L-early_N4_T1.jpg` | 4 | 4 | (0,1) | yes | yes |
| 02 | `02_L03_N6_T1.jpg` | 6 | 8 | (2,1) | yes | yes |

## T1 trace (seq 01)

Existing cat at (2,0). After halo propagation, row 1 has a naked single at (0,1) — index **4**. Spec loop places first new cat there.

## T1 trace (seq 02)

Existing cat at (5,0). T1 naked-single scan (rows → cols → regions) yields first new cat at (2,1) — index **8**.

## Compare to locked test

- [x] matches → **human-verified** (spec T1 independent of solver code)
- [ ] mismatch → escalate

## Gate artifacts

- `meowdoku_helper/test/qa_p2_oracle_audit_test.dart` — groups `Q6 phase2 *`
- `meowdoku_helper/test/support/qa_t1_from_spec.dart` — spec-only T1 helper
