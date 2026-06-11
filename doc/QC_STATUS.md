# QC status — MeowdokuHelper

**Last QC run:** 2026-06-11 (Project Health Audit)  
**Branch:** `main`  
**Audit:** [.cursor/handoff/PROJECT_HEALTH_AUDIT.md](../.cursor/handoff/PROJECT_HEALTH_AUDIT.md)

---

## Ship status

| Item | Status |
|------|--------|
| Tier 1b `flutter test` | **PASS** — 50 passed, 15 skipped (FFI when native lib absent) |
| Tier 1a `cargo test --lib` | **PASS** — 22 tests |
| `flutter analyze` | **WARN** — 1 info (unnecessary import in `decode_isolate.dart`) |
| Tier 2 integration | **PASS** (last run) — 6 tests on iOS sim |
| Wordle API removed | **YES** |
| Project health audit | **DONE** — 2026-06-11 |

---

## TDD / red-green policy

Documented in [TEST_PLAN.md](../TEST_PLAN.md) and [.cursor/skills/TEST_TDD.md](../.cursor/skills/TEST_TDD.md):

- New behavior: **red → green** at applicable tier before merge.
- After each change: **full merge-ready gate** (Tier 1a + 1b + analyze).
- FFI changes: **+ Tier 2** on iOS simulator.

**Audit finding:** Four Tier 1b FFI tests can pass without exercising Rust when native lib is absent — tracked in [TECH_DEBT.md](../TECH_DEBT.md) Fix now.

---

## FFI surface

| Rust | Dart |
|------|------|
| `init_app()` | `RustLib.init()` |
| `calculate_next_move(state, regions, grid_size) -> i32` | `calculateNextMove(...)` |

Solver runs Tiers 1–4 (historical T4 = DFS). Phase 6 will add Phantom (T4) + Crowding (T5) + rename DFS to T6.

---

## Test coverage snapshot (audit)

| Area | Covered | Gap |
|------|---------|-----|
| Solver T1–T4 synthetic | Strong (Rust) | API-level T3/T4 tests |
| T4 fixtures seq 22–30 | Rust + Dart | — |
| Parse goldens | seq 01–02, 22–30 | seq 03–21, 31–42 (30 fixtures) |
| Tier 2 E2E | seq 08, 14, 29, 30 | seq 15–19, 20–21, 31–42 |
| Clipboard / main.dart FSM | Partial mocks | Widget + E2E flow |

---

## Next (from audit remediation waves)

1. Lock parse goldens for seq 03–08 (`grid_goldens.dart`)
2. Expand Tier 2 E2E (seq 15–19, 31–32)
3. Golden codegen Rust↔Dart for T4 fixtures

Waves 1–4 **done**; waves 5–6 **partial** — see [TECH_DEBT.md](../TECH_DEBT.md).
