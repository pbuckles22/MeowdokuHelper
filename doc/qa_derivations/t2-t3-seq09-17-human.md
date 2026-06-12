# Derivation — t2-t3-fixture-gate (seq 09–17)

**QA session:** 2026-06-12 (Phase 7 Q5)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md), [FIXTURES.md](../plan/FIXTURES.md)  
**Forbidden inputs used:** none for parse-lock; `expected_move` locked after QA trace + tier attribution (see uniqueness note)

## Method

1. **Parse-lock:** `parseGridFromImage` on each JPEG (2026-06-12); lock `gridSize`, `state`, `regions` in `t2_t3_fixtures.rs` / `t2_t3_solver_goldens.dart`.
2. **Solve oracle:** Record T1–T5 first cat index (`calculate_next_move`); assert none return `BRANCH_REQUIRED` (-2).
3. **Tier attribution:** First cat placement tier via isolated `run_tier1` → `run_tiers_1_and_2` → `run_tiers_1_through_3` → `run_tiers_1_through_5`.
4. **Uniqueness:** Block candidate (`t6_qa_force::is_first_move_forced`) — classify forced vs alternate-path variant.
5. **Human review:** Board ASCII traces in `qa_t2_t3_oracle_audit_test.dart` (group `Q5 t2/t3 board traces`).

## Parse-lock corrections

| Seq | Fixture | Filename N | Parser N | Notes |
|-----|---------|------------|----------|-------|
| 14 | `14_L15_N10_T3.jpeg` | 10 | **12** | Parser output wins (parse-lock); catalog N column updated |

## Locked oracles

| Seq | Fixture | Gate | Parser N | Move | (x,y) | First-cat tier | Block-test forced |
|-----|---------|------|----------|------|-------|----------------|-------------------|
| 09 | `09_L10_N7_T2.jpg` | T2 | 7 | 7 | (0,1) | T3 | no |
| 10 | `10_L11_T2.jpeg` | T2 | 6 | 0 | (0,0) | T1 | no |
| 11 | `11_L12_T2.jpeg` | T2 | 6 | 0 | (0,0) | T1 | no |
| 12 | `12_L13_T2.jpeg` | T2 | 9 | 8 | (8,0) | T1 | no |
| 13 | `13_L14_T2.jpeg` | T2 | 9 | 7 | (7,0) | T1 | no |
| 14 | `14_L15_N10_T3.jpeg` | T3 | 12 | 13 | (1,1) | T1 | no |
| 15 | `15_L16_T3.jpeg` | T3 | 9 | 2 | (2,0) | T1 | no |
| 16 | `16_L17_T3.jpeg` | T3 | 10 | 6 | (6,0) | T1 | no |
| 17 | `17_L18_T3.jpeg` | T3 | 10 | 4 | (4,0) | T1 | no |

**Uniqueness summary:** `forced=0` · `branch_variant=9` (alternate first move exists after block-test)

**Interpretation:** All nine return a **T1–T5 deterministic** first step (not `-2`). Locked indices are **solver propagation convention** — same class of debt as seq 22–30 until product enforces unique forced hints. Gate is **solvability + parse regression**, not hint-truth oracle.

## Gate artifacts

| Path | Role |
|------|------|
| `rust/src/solver/t2_t3_fixtures.rs` | Rust oracle arrays + `cargo test` gate |
| `lib/image/t2_t3_solver_goldens.dart` | Dart mirror |
| `test/t2_t3_fixture_gate_test.dart` | Tier 1b parse + solve gate |
| `test/qa_t2_t3_oracle_audit_test.dart` | QA audit traces |

## Escalation

- **Product:** Hint UI should not treat locked indices as unique forced moves until block-test passes (see [t6-seq22-30-human.md](t6-seq22-30-human.md)).
- **Optional Coder:** MRV / forced-move uniqueness in `calculate_next_move` — then re-oracle this gate.

## Compare to locked tests

- [x] Parse arrays match live parser (9/9)
- [x] Locked index is `EMPTY` (9/9)
- [x] No `BRANCH_REQUIRED` on initial board (9/9)
- [ ] Block-test forced — 0/9 (documented; not gate failure)
