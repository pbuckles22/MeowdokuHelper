# Derivation — t2-t3-fixture-gate (seq 20)

**QA session:** 2026-06-12 (Phase 9 P9 — seq 20 gate)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md), [FIXTURES.md](../plan/FIXTURES.md)  
**Forbidden inputs used:** none for parse-lock; hint API locked after QA trace + tier attribution

## Method

1. **Parse-lock:** `parseGridFromImage` on `20_L21_N8_T3.jpeg` (2026-06-12); lock `gridSize`, `state`, `regions` in `t2_t3_fixtures.rs`.
2. **Solve oracle:** Record hint API (`calculate_next_move`) and propagation index (`propagate_next_move_index`).
3. **Tier attribution:** First cat placement tier via isolated `run_tier1` → `run_tiers_1_and_2` → `run_tiers_1_through_3` → `run_tiers_1_through_5`.
4. **Uniqueness:** Block candidate (`is_first_move_forced` on propagation index).
5. **Human review:** Board ASCII trace in `qa_t2_t3_oracle_audit_test.dart` (group `P9 t2/t3 board traces`).

## Locked oracles

| Seq | Fixture | Gate | Parser N | Hint API | Prop | (x,y) | First-cat tier | Block-test forced |
|-----|---------|------|----------|----------|------|-------|----------------|-------------------|
| 20 | `20_L21_N8_T3.jpeg` | T3 | 8 | -2 | 1 | (1,0) | T1 | no |

**Uniqueness summary:** `forced=0` · `branch_variant=1`

**Interpretation:** Two single-cell regions (region 6 at (0,1), region 8 at (3,1)) — T1 naked singles place both cats simultaneously. Propagation convention picks index 1 first; block-test shows alternates → hint API returns `-2` (US-7.2). Gate is **parse + hint-API regression**, not unique-forced oracle.

**Filename note:** `_T3_` suffix is QA minimum-tier estimate; first cat is **T1 naked single**.

## Gate artifacts

| Path | Role |
|------|------|
| `rust/src/solver/t2_t3_fixtures.rs` | Rust oracle arrays + `cargo test` gate |
| `lib/image/t2_t3_solver_goldens.dart` | Dart mirror (codegen) |
| `test/t2_t3_fixture_gate_test.dart` | Tier 1b parse + solve gate |
| `test/qa_t2_t3_oracle_audit_test.dart` | QA audit traces |

## Compare to locked tests

- [x] Parse arrays match live parser (1/1)
- [x] Locked hint API is `-2` (1/1)
- [x] Propagation index points at `EMPTY` (1/1)
- [ ] Block-test forced — 0/1 (documented; not gate failure)
