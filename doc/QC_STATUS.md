# QC status — MeowdokuHelper

**Last QC run:** 2026-06-12 (Phase 8 H4 golden codegen — feature branch)  
**Branch:** `feature/h4-golden-codegen` — Phase 8 complete (merge pending)  
**Full eval:** [TEST_COVERAGE_EVAL.md](TEST_COVERAGE_EVAL.md)

---

## Ship status

| Item | Status |
|------|--------|
| Tier 1b `flutter test` | **PASS** — 125 passed, 52 skipped (FFI when native lib absent) |
| Tier 1a `cargo test --lib` | **PASS** — 37 tests |
| `flutter analyze` | **PASS** |
| Tier 2 integration | **PASS** — 6/6 GitHub `macos-14` (post-H1 hint API) |
| H1 uniqueness filter | **DONE** — block-test on hint API; fixture oracles re-locked |
| H2 T4 gate seq 18–19 | **DONE** — `t4_fixtures.rs` + Dart gate |
| H3 fixture inventory | **DONE** — `./scripts/fixture_inventory.sh` |
| H4 golden codegen | **DONE** — `gen_solver_goldens` + `./scripts/generate_solver_goldens.sh` |
| Oracle strict audit | **PASS** — `./scripts/qa_oracle_audit.sh --strict` |
| Phase 8 | **DONE** — H1–H4 on feature branch |

---

## TL + QA verdict (summary)

| | Assessment |
|---|------------|
| **Tested right** | T1–T6 synthetics `spec-verified`; parse 01–08; gates t2/t3 09–17, t4 18–19, t6 22–30; hint API uniqueness filter; inventory script |
| **Tested weak/wrong** | seq 20–21, 31–42 ungated |
| **Missing** | Line-coverage tooling; CI wire for `generate_solver_goldens.sh --check` |
| **Line coverage %** | Not instrumented — behavior/fixture matrix is SSOT |

---

## TDD / red-green policy

[TEST_PLAN.md](../TEST_PLAN.md) · [QA_ORACLE_AUDIT.md](QA_ORACLE_AUDIT.md) · [.cursor/rules/qa-coder-separation.mdc](../.cursor/rules/qa-coder-separation.mdc)

- New behavior: **QA session** writes red → **Coder session** implements green
- Coder **must not** edit tests/oracles when they don't fit
- Backward audit: `./scripts/qa_oracle_audit.sh --strict`
- Fixture inventory: `./scripts/fixture_inventory.sh`

---

## FFI surface (unchanged)

| Rust | Dart |
|------|------|
| `init_app()` | `RustLib.init()` |
| `calculate_next_move(state, regions, grid_size) -> i32` | `calculateNextMove(...)` |

Returns: `>=0` uniqueness-forced index; `-2` branch/alternate paths; `-1` stuck.

---

## Fixture gate matrix (2026-06-12)

| Range | Gate | Hint oracle |
|-------|------|-------------|
| 01–08 | parse | 01–02 propagation (spec T1); hint `-2` unless block-test forced |
| 09–17 | t2/t3 | hint `-2` (regression-accepted propagation traces) |
| 18–19 | t4 | hint `-2` |
| 22–30 | t6 | hint `-2` |
| 20–21, 31–42 | — | ungated backlog |

Run `./scripts/fixture_inventory.sh` for live report.

---

## Next QC focus

| Priority | Item | Owner |
|----------|------|-------|
| 1 | seq 20–21, 31–42 gates | QA → Coder |
| 2 | Wire `generate_solver_goldens.sh --check` in CI | Coder |
