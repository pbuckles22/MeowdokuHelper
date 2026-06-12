# Derivation — t4-fixture-gate (seq 18–19)

**QA session:** 2026-06-12 (Phase 8 H2 — optional backlog)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md), [FIXTURES.md](../plan/FIXTURES.md)  
**Forbidden inputs used:** none for parse-lock; `expected_move` locked after QA trace + tier attribution

## Method

1. **Parse-lock:** `parseGridFromImage` on each JPEG (2026-06-12); lock `gridSize`, `state`, `regions` in `t4_fixtures.rs` / `t4_solver_goldens.dart`.
2. **Solve oracle:** Record T1–T5 first cat index (`calculate_next_move`); assert none return `BRANCH_REQUIRED` (-2).
3. **Tier attribution:** First cat placement tier via isolated `run_tier1` → `run_tiers_1_and_2` → `run_tiers_1_through_3` → `run_tiers_1_through_5`.
4. **Uniqueness:** Block candidate (`t6_qa_force::is_first_move_forced`) — classify forced vs alternate-path variant.
5. **Human review:** Board ASCII traces in `qa_t4_oracle_audit_test.dart` (group `H2 t4 board traces`).

## Locked oracles

| Seq | Fixture | Gate | Parser N | Move | (x,y) | First-cat tier | Block-test forced |
|-----|---------|------|----------|------|-------|----------------|-------------------|
| 18 | `18_L19_T4.jpeg` | T4 | 10 | 5 | (5,0) | T1 | no |
| 19 | `19_L20_T4.jpeg` | T4 | 9 | 0 | (0,0) | T1 | no |

**Uniqueness summary:** `forced=0` · `branch_variant=2`

**Interpretation:** Both return a **T1–T5 deterministic** first step (not `-2`). Locked indices are **solver propagation convention** — same class of debt as seq 09–17 and 22–30 until product enforces unique forced hints (Phase 8 H1). Gate is **solvability + parse regression**, not hint-truth oracle.

**Filename note:** `_T4_` suffix is historical minimum-tier label; first cat on both boards is **T1 naked single**.

## Gate artifacts

| Path | Role |
|------|------|
| `rust/src/solver/t4_fixtures.rs` | Rust oracle arrays + `cargo test` gate |
| `lib/image/t4_solver_goldens.dart` | Dart mirror |
| `test/t4_fixture_gate_test.dart` | Tier 1b parse + solve gate |
| `test/qa_t4_oracle_audit_test.dart` | QA audit traces |

## Compare to locked tests

- [x] Parse arrays match live parser (2/2)
- [x] Locked index is `EMPTY` (2/2)
- [x] No `BRANCH_REQUIRED` on initial board (2/2)
- [ ] Block-test forced — 0/2 (documented; not gate failure)
