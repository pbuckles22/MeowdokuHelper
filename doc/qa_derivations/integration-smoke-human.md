# Derivation — integration-smoke (Tier 2 E2E)

**QA session:** 2026-06-12 (Phase 7 Q6)  
**Spec:** [FIXTURES.md](../plan/FIXTURES.md), [solver_algorithms.md](../requirements/solver_algorithms.md)  
**Forbidden inputs used:** none for parse-lock; solve indices compared to locked E2E constants only

## Method

1. **Parse-lock:** Re-parse each JPEG; assert `gridSize` and (where gate arrays exist) `state`/`regions` match locked goldens.
2. **Solve regression:** `solveParsedGrid` on locked parse output returns E2E `expectedMoveIndex` from `integration_test/app_smoke_test.dart`.
3. **Board traces:** ASCII traces in `qa_p2_oracle_audit_test.dart` for human review.
4. **Spec independence:** seq 08 move **11** does not match spec-only T1 first placement (index 41) — multiple T1 candidates / ladder convention; treat as **regression-lock**, not unique hint oracle.

## Fixtures

| Seq | Fixture | Parser N | E2E move | (x,y) | Parse-lock source | Solve oracle |
|-----|---------|----------|----------|-------|-------------------|--------------|
| 08 | `08_L09_N9_T1.jpg` | 8 | 11 | (3,1) | `grid_goldens.dart` | regression-lock |
| 14 | `14_L15_N10_T3.jpeg` | 12 | 13 | (1,1) | `t2_t3_solver_goldens.dart` | regression-lock (Q5) |
| 29 | `29_L23_N10_T6.jpeg` | 10 | 2 | (2,0) | `t6_solver_goldens.dart` | regression-lock (Q1) |
| 30 | `30_L25_N10_T6.jpeg` | 10 | 6 | (6,0) | `t6_solver_goldens.dart` | regression-lock (Q1) |

**Interpretation:** Tier 2 smoke proves **parse → isolate → FFI solve pipeline** on device/sim. Locked move indices are **solver convention** (same class as Q1/Q5 fixture gates) — solvability + pipeline regression, not independent hint-truth.

## Compare to locked test

- [x] parse-lock matches → accepted
- [x] solve regression matches E2E constants → **regression-accepted**
- [ ] unique forced hint → not claimed (see Q1/Q5 uniqueness debt)

## Gate artifacts

- `meowdoku_helper/integration_test/app_smoke_test.dart` — E2E constants (unchanged)
- `meowdoku_helper/test/qa_p2_oracle_audit_test.dart` — groups `Q6 integration *`
