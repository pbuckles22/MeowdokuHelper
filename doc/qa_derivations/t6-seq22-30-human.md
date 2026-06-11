# Derivation — t6-fixture-gate (seq 22–30)

**QA session:** 2026-06-11 (US-7.1 / Phase 7 Q1)  
**Updated:** 2026-06-12 — uniqueness pass (block candidate → alternate path)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md), [FIXTURES.md](../plan/FIXTURES.md)

## Architectural finding (confirmed)

Locked `expected_move` values are **solver convention** (T6 `first_empty()` row-major branch), **not** game-truth forced hints.

When T1–T5 stall, DFS tries the top-leftmost empty cell first (`Index = y × N + x` scan). That clusters **7/9** moves on row 0. A valid hint UI must surface **logically forced** moves only — not DFS branch hypotheses.

## Uniqueness test (QA)

**Rule:** Block the candidate cell (`BLOCKED`). If `calculate_next_move` still returns a valid index, the locked move is a **branch variant**, not forced.

| Implementation | Path |
|----------------|------|
| Rust | `rust/src/solver/t6_qa_force.rs` — `cargo test t6_locked_moves_uniqueness_report -- --nocapture` |
| Dart | `test/qa_t6_oracle_audit_test.dart` — group `Q1 t6 first-move uniqueness` |

## Results (2026-06-12)

| Seq | Fixture | N | Locked | (x,y) | Uniqueness | Alt index if blocked |
|-----|---------|---|--------|-------|------------|----------------------|
| 22 | `22_L31_N8_T6.jpeg` | 8 | 0 | (0,0) | **BRANCH_VARIANT** | solver finds another |
| 23 | `23_L22_N9_T6.jpeg` | 9 | 8 | (8,0) | **BRANCH_VARIANT** | solver finds another |
| 24 | `24_L27_N9_T6.jpeg` | 10 | 9 | (9,0) | **BRANCH_VARIANT** | solver finds another |
| 25 | `25_L32_N9_T6.jpeg` | 10 | 1 | (1,0) | **BRANCH_VARIANT** | solver finds another |
| 26 | `26_L29_N9_T6.jpeg` | 9 | 7 | (7,0) | **BRANCH_VARIANT** | solver finds another |
| 27 | `27_L24_N9_T6.jpeg` | 9 | 4 | (4,0) | **BRANCH_VARIANT** | solver finds another |
| 28 | `28_L30_N9_T6.jpeg` | 10 | 9 | (9,0) | **BRANCH_VARIANT** | solver finds another |
| 29 | `29_L23_N10_T6.jpeg` | 10 | 2 | (2,0) | **BRANCH_VARIANT** | solver finds another |
| 30 | `30_L25_N10_T6.jpeg` | 10 | 6 | (6,0) | **BRANCH_VARIANT** | solver finds another |

**Summary:** `forced=0` · `branch_variant=9`

**Conclusion:** seq 22–30 solve goldens are **regression-lock on DFS convention** — unsuitable as hint-oracle or “forced move” acceptance without rework.

## Automated pre-audit (still green)

- Parse output matches locked arrays (9/9)
- Locked index points at `EMPTY` cell (9/9)

## Human oracle

Optional spot-check screenshots; uniqueness pass supersedes “play through” for **forced** classification. Human still useful to confirm puzzles are valid Star Battle states.

## Next actions (Coder / TL)

1. **Product:** `calculate_next_move` should return forced moves only, or `-1` + “branch required” when T6 guesses — see [product.md](../requirements/product.md).
2. **Solver:** Implement forced-move uniqueness in API (block-test or full bifurcation analysis).
3. **Heuristic:** Replace row-major `first_empty()` with **MRV** (minimum remaining values) — [TECH_DEBT.md](../../TECH_DEBT.md).
4. **Fixtures:** Re-oracle seq 22–30 after solver returns true forced moves, or reclassify gate as **solvability regression** (not hint oracle).

## Escalation

Do **not** mark manifest `human-verified` on current locked indices for hint correctness. Gate may remain green as **solver stability** until re-oracled.
