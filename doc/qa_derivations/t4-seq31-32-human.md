# Derivation — t4-fixture-gate (seq 31–32)

**QA session:** 2026-06-13 (P10 — L21–L33 batch closure)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md), [FIXTURES.md](../plan/FIXTURES.md)  
**Forbidden inputs used:** none for parse-lock; hint API locked after QA trace + tier attribution

## Method

1. **Parse-lock:** `parseGridFromImage` on each JPEG (2026-06-13); lock `gridSize`, `state`, `regions` in `t4_fixtures.rs`.
2. **Solve oracle:** Record hint API (`calculate_next_move`) and propagation index (`propagate_next_move_index`).
3. **Tier attribution:** First cat placement tier via isolated tier runners.
4. **Uniqueness:** Block candidate (`is_first_move_forced` on propagation index when prop ≥ 0).
5. **Human review:** Board ASCII trace in `qa_t4_oracle_audit_test.dart` (seq 32 only — seq 31 has no propagation index).

## Locked oracles

| Seq | Fixture | Gate | Parser N | Hint API | Prop | (x,y) | First-cat tier | Block-test forced |
|-----|---------|------|----------|----------|------|-------|----------------|-------------------|
| 31 | `31_L28_N10_T4.jpeg` | T4 | 10 | -2 | -2 | — | none | n/a |
| 32 | `32_L33_N10_T4.jpeg` | T4 | 10 | -2 | 1 | (1,0) | T2 | no |

**Uniqueness summary:** `forced=0` · `branch_variant=1` (seq 32) · `t1_t5_stall=1` (seq 31)

**Interpretation:**

- **Seq 31:** Empty 10×10 board; smallest region has 2 cells (no T1 region singleton). Tiers 1–5 place no cat → propagation returns `-2`; hint API `-2`. Gate is **parse-lock + T1–T5 stall regression** (not a forced-hint board).
- **Seq 32:** T2 line-to-region claim places first cat at propagation index 1 `(1,0)`; block-test shows alternates → hint API `-2` (US-7.2). Gate is **parse + hint-API regression**, not unique-forced oracle.

**Filename note:** `_T4_` suffix is historical minimum-tier label; seq 31 first progress may require T6; seq 32 first cat is **T2**.

## Gate artifacts

| Path | Role |
|------|------|
| `rust/src/solver/t4_fixtures.rs` | Rust oracle arrays + `cargo test` gate |
| `lib/image/t4_solver_goldens.dart` | Dart mirror (codegen) |
| `test/t4_fixture_gate_test.dart` | Tier 1b parse + solve gate |
| `test/qa_t4_oracle_audit_test.dart` | QA audit traces |

## Compare to locked tests

- [x] Parse arrays match live parser (2/2)
- [x] Locked hint API is `-2` (2/2)
- [x] Seq 32 propagation index points at `EMPTY` (1/1)
- [x] Seq 31 propagation stall documented (prop `-2`)
- [ ] Block-test forced — 0/1 applicable (seq 32 only; documented)
