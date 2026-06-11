# QC status — MeowdokuHelper

**Last QC run:** 2026-06-11 (Phase 7 Q1/Q2 started)  
**Branch:** `main` — EPIC-6 complete  
**Full eval:** [TEST_COVERAGE_EVAL.md](TEST_COVERAGE_EVAL.md)

---

## Ship status

| Item | Status |
|------|--------|
| Tier 1b `flutter test` | **PASS** — 50 passed, 15 skipped (FFI when native lib absent) |
| Tier 1a `cargo test --lib` | **PASS** — 28 tests |
| `flutter analyze` | **PASS** |
| Tier 2 integration | **PASS** — 6/6 on iPhone 13 sim (iOS 15.2), 2026-06-11 post-EPIC-6 |
| Q1 t6 pre-audit | **PARTIAL** — parse + EMPTY preconditions 9/9; human-verify pending |
| QA/Coder separation | **DONE** — rules + manifest + audit script |
| Oracle independence (P1/P2) | **PENDING** — 9 manifest artifacts unaudited |

---

## TL + QA verdict (summary)

| | Assessment |
|---|------------|
| **Tested right** | T1–T6 solver synthetics; t6 seq 22–30 gate; parse 01–02 goldens; FFI skip hygiene; clipboard flow; 4-fixture Tier 2 |
| **Tested weak/wrong** | Solve oracles are regression-lock (not human/spec); co-located tier tests unaudited; parse ladder 03–08 smoke-only; 13 coupled git commits |
| **Missing** | 30/42 fixtures without gate; seq 09–19 T2/T3 gate; seq 31–42; API-level FRB synthetic; Tier 2 post–EPIC-6 |
| **Line coverage %** | Not instrumented — behavior/fixture matrix is SSOT ([TEST_COVERAGE_EVAL.md](TEST_COVERAGE_EVAL.md)) |

---

## TDD / red-green policy

[TEST_PLAN.md](../TEST_PLAN.md) · [QA_ORACLE_AUDIT.md](QA_ORACLE_AUDIT.md) · [.cursor/rules/qa-coder-separation.mdc](../.cursor/rules/qa-coder-separation.mdc)

- New behavior: **QA session** writes red → **Coder session** implements green
- Coder **must not** edit tests/oracles when they don't fit
- Backward audit: `./scripts/qa_oracle_audit.sh`

---

## FFI surface (unchanged)

| Rust | Dart |
|------|------|
| `init_app()` | `RustLib.init()` |
| `calculate_next_move(state, regions, grid_size) -> i32` | `calculateNextMove(...)` |

---

## Coverage snapshot

| Area | Tier 1a | Tier 1b | Tier 2 | Oracle status |
|------|---------|---------|--------|---------------|
| Solver T1–T6 synthetics | Strong (28) | Roundtrip | Synthetic board | P3 pending |
| seq 22–30 solve gate | Strong | Strong | 29–30 only | **P1 pending** |
| Parse seq 01–02 | — | Strong | — | parse-lock OK |
| Parse seq 03–08 | — | Smoke only | seq 08 E2E | No locked goldens |
| seq 09–42 | — | **None** | **None** | Missing gates |
| Integration smoke | — | — | 6 tests | **P2 pending** |

---

## Next work (QA hardening wave)

| # | Story | Owner |
|---|-------|-------|
| 1 | P1 blind audit t6 seq 22–30 — **human checklist** in [qa_derivations/t6-seq22-30-human.md](qa_derivations/t6-seq22-30-human.md) | QA + you |
| 2 | Tier 2 iOS sim post–EPIC-6 | **DONE** 2026-06-11 |
| 3 | P3 spec-verify tier synthetics (one tier/session) | QA |
| 4 | Lock parse goldens seq 03–08 | QA → Coder |
| 5 | T2/T3 fixture gate seq 09–19 | QA → Coder |

See [TEST_COVERAGE_EVAL.md](TEST_COVERAGE_EVAL.md) for full matrix and sequencing.
