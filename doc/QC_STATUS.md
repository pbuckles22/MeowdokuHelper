# QC status — MeowdokuHelper

**Last QC run:** 2026-06-12 (Phase 7 epic closure)  
**Branch:** `main` — Phase 7 / EPIC-7 complete  
**Full eval:** [TEST_COVERAGE_EVAL.md](TEST_COVERAGE_EVAL.md)

---

## Ship status

| Item | Status |
|------|--------|
| Tier 1b `flutter test` | **PASS** — 119 passed, 48 skipped (FFI when native lib absent) |
| Tier 1a `cargo test --lib` | **PASS** — 34 tests |
| `flutter analyze` | **PASS** |
| Tier 2 integration | **PASS** — 6/6 GitHub `macos-14` (run 27444146040, 2026-06-12) |
| Q1 t6 uniqueness | **DONE** — 0/9 forced; `regression-accepted` |
| QA/Coder separation | **DONE** — rules + manifest + audit script |
| Oracle independence (P1/P2) | **DONE** — `./scripts/qa_oracle_audit.sh --strict` PASS |
| Phase 7 epic closure | **DONE** — 2026-06-12 |
| Health audit refresh | **DONE** — 2026-06-12 ([AUDIT_BASELINE.md](../.cursor/handoff/AUDIT_BASELINE.md)) |
| Phase 8 planned | **H1–H4** in PM_PLAN / EPIC-8 |

---

## TL + QA verdict (summary)

| | Assessment |
|---|------------|
| **Tested right** | T1–T6 synthetics `spec-verified`; parse goldens 01–08; solve gates 01–02 `human-verified`; T2/T3 gate 09–17; t6 seq 22–30; integration smoke `regression-accepted`; `qa_p2_oracle_audit_test.dart` (18 cases) |
| **Tested weak/wrong** | seq 09–30 + integration moves remain regression-lock class (0/9 forced on t6/t2-t3 uniqueness); 16 historical coupled commits on main |
| **Missing** | seq 18–19 T4 gate; seq 31–42 gates; T1–T5 uniqueness filter on hint API; line-coverage tooling |
| **Line coverage %** | Not instrumented — behavior/fixture matrix is SSOT ([TEST_COVERAGE_EVAL.md](TEST_COVERAGE_EVAL.md)) |

---

## TDD / red-green policy

[TEST_PLAN.md](../TEST_PLAN.md) · [QA_ORACLE_AUDIT.md](QA_ORACLE_AUDIT.md) · [.cursor/rules/qa-coder-separation.mdc](../.cursor/rules/qa-coder-separation.mdc)

- New behavior: **QA session** writes red → **Coder session** implements green
- Coder **must not** edit tests/oracles when they don't fit
- Backward audit: `./scripts/qa_oracle_audit.sh --strict`

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
| Solver T1–T6 synthetics | Strong (34) | Roundtrip | Synthetic board | **spec-verified** (P3) |
| seq 22–30 solve gate | Strong | Strong | 29–30 only | **regression-accepted** (P1) |
| Parse seq 01–08 | — | Strong (goldens) | seq 08 E2E | parse-lock / **human-verified** (01–02 solve) |
| seq 09–17 T2/T3 gate | Strong | Strong | — | **regression-accepted** (Q5) |
| seq 18–42 | — | Partial | — | Missing gates (18–19 deferred) |
| Integration smoke | — | — | 6 tests | **regression-accepted** (P2) |
| P2 audit harness | — | Strong (18) | — | `qa_p2_oracle_audit_test.dart` |

---

## Next work (Phase 8)

| # | Story | Owner |
|---|-------|-------|
| 1 | **H1** T1–T5 uniqueness filter on hint API | Coder |
| 2 | **H2** T4 fixture gate seq 18–19 | QA → Coder |
| 3 | **H3** 42-fixture inventory script | Backlog |
| 4 | **H4** Golden codegen Rust↔Dart | Coder |

See [PM_PLAN.md](../PM_PLAN.md) Phase 8 and [TEST_COVERAGE_EVAL.md](TEST_COVERAGE_EVAL.md).
