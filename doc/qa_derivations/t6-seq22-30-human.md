# Derivation — t6-fixture-gate (seq 22–30)

**QA session:** 2026-06-11 (US-7.1 / Phase 7 Q1)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md), [FIXTURES.md](../plan/FIXTURES.md)  
**Forbidden inputs used:** none (no `tier*.rs`, no `calculate_next_move`)

## Automated pre-audit (green)

`meowdoku_helper/test/qa_t6_oracle_audit_test.dart`:

- Parse output matches locked arrays (9/9)
- Locked `expectedMove` index points at `EMPTY` cell (9/9)

Run: `cd meowdoku_helper && flutter test test/qa_t6_oracle_audit_test.dart`

## Human oracle (pending)

Locked move indices below are **regression-lock** until human play-through confirms each is the correct **next cat** per Star Battle rules.

| Seq | Fixture | N | Locked move | (x,y) | Human verify |
|-----|---------|---|-------------|-------|--------------|
| 22 | `22_L31_N8_T6.jpeg` | 8 | 0 | (0,0) | [ ] |
| 23 | `23_L22_N9_T6.jpeg` | 9 | 8 | (8,0) | [ ] |
| 24 | `24_L27_N9_T6.jpeg` | 10 | 9 | (9,0) | [ ] |
| 25 | `25_L32_N9_T6.jpeg` | 10 | 1 | (1,0) | [ ] |
| 26 | `26_L29_N9_T6.jpeg` | 9 | 7 | (7,0) | [ ] |
| 27 | `27_L24_N9_T6.jpeg` | 9 | 4 | (4,0) | [ ] |
| 28 | `28_L30_N9_T6.jpeg` | 10 | 9 | (9,0) | [ ] |
| 29 | `29_L23_N10_T6.jpeg` | 10 | 2 | (2,0) | [ ] |
| 30 | `30_L25_N10_T6.jpeg` | 10 | 6 | (6,0) | [ ] |

Board traces (`.` empty, `*` cat, `X` blocked, `>` locked move, number = region id) are printed by the QA test stdout.

## Compare to locked test

- [x] Parse arrays match JPEG pipeline
- [x] Move index preconditions (EMPTY target)
- [ ] Human-verify all 9 moves → then set manifest `human-verified`

## Escalation

If human review disagrees with locked index: **QA** updates oracle in FIXTURES.md + goldens in a **QA-only** session; **Coder** fixes solver if spec/human is correct.
