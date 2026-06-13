# Derivation — t4-fixture-gate (seq 21)

**QA session:** 2026-06-12 (Phase 9 P9 — seq 21 gate)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md), [FIXTURES.md](../plan/FIXTURES.md)  
**Forbidden inputs used:** none for parse-lock; hint API locked after QA trace + tier attribution

## Method

1. **Parse-lock:** `parseGridFromImage` on `21_L26_N8_T4.jpeg` (2026-06-12); lock `gridSize`, `state`, `regions` in `t4_fixtures.rs`.
2. **Solve oracle:** Record hint API (`calculate_next_move`) and propagation index (`propagate_next_move_index`).
3. **Tier attribution:** First cat placement tier via isolated tier runners.
4. **Uniqueness:** Block candidate (`is_first_move_forced` on propagation index).
5. **Human review:** Board ASCII trace in `qa_t4_oracle_audit_test.dart` (group `P9 t4 board traces`).

## Locked oracles

| Seq | Fixture | Gate | Parser N | Hint API | Prop | (x,y) | First-cat tier | Block-test forced |
|-----|---------|------|----------|----------|------|-------|----------------|-------------------|
| 21 | `21_L26_N8_T4.jpeg` | T4 | 8 | -2 | 3 | (3,0) | T1 | no |

**Uniqueness summary:** `forced=0` · `branch_variant=1`

**Interpretation:** Two single-cell regions (region 7 at (0,2), region 8 at (7,7)) — T1 naked singles. Propagation convention picks index 3; block-test shows alternates → hint API returns `-2`. Gate is **parse + hint-API regression**, not unique-forced oracle.

**Filename note:** `_T4_` suffix is historical minimum-tier label; first cat is **T1 naked single**.

## Gate artifacts

| Path | Role |
|------|------|
| `rust/src/solver/t4_fixtures.rs` | Rust oracle arrays + `cargo test` gate |
| `lib/image/t4_solver_goldens.dart` | Dart mirror (codegen) |
| `test/t4_fixture_gate_test.dart` | Tier 1b parse + solve gate |
| `test/qa_t4_oracle_audit_test.dart` | QA audit traces |

## Compare to locked tests

- [x] Parse arrays match live parser (1/1)
- [x] Locked hint API is `-2` (1/1)
- [x] Propagation index points at `EMPTY` (1/1)
- [ ] Block-test forced — 0/1 (documented; not gate failure)
