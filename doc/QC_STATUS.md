# QC status — MeowdokuHelper

**Last QC run:** 2026-06-11 (US-6.2 Crowding tier)  
**Branch:** `main` — US-6.2 merged  
**Audit:** [.cursor/handoff/PROJECT_HEALTH_AUDIT.md](../.cursor/handoff/PROJECT_HEALTH_AUDIT.md)

---

## Ship status

| Item | Status |
|------|--------|
| Tier 1b `flutter test` | **PASS** — 50 passed, 15 skipped (FFI when native lib absent) |
| Tier 1a `cargo test --lib` | **PASS** — 28 tests (+3 crowding) |
| `flutter analyze` | **PASS** |
| Tier 2 integration | **PASS** (last run) — 6 tests on iOS sim; **re-run after EPIC-6** |
| Wordle API removed | **YES** |
| Project health audit | **DONE** — remediation on `main` |
| FFI test hygiene | **FIXED** — explicit skip via `test/support/native_ffi.dart` |

---

## TDD / red-green policy

[TEST_PLAN.md](../TEST_PLAN.md) · [.cursor/skills/TEST_TDD.md](../.cursor/skills/TEST_TDD.md)

- New behavior: red → green at applicable tier before merge
- Merge gate: Tier 1a + 1b + `flutter analyze`
- Solver / FRB changes: + Tier 2 on iOS simulator

---

## FFI surface (unchanged for EPIC-6)

| Rust | Dart |
|------|------|
| `init_app()` | `RustLib.init()` |
| `calculate_next_move(state, regions, grid_size) -> i32` | `calculateNextMove(...)` |

**Today:** Tiers 1–3 + T4 Phantom + T5 Crowding + DFS inside `calculate_next_move` (DFS = historical `tier4`).  
**EPIC-6:** Phantom + Crowding shipped; DFS→T6 rename in US-6.3 — still one move index out, no FRB API change.

---

## Coverage snapshot (pre–Phase 6)

| Area | Covered | Gap |
|------|---------|-----|
| Solver T1–5 + seq 22–30 | Strong | EPIC-6 T6 rename + suffix re-audit |
| Parse goldens | seq 01–02 (+ solve), 22–30 | Lock seq 03–08 (smoke only today) |
| Tier 2 E2E | seq 08, 14, 29, 30 | seq 15–19, 31–42 |

---

## Before EPIC-6 merge

1. Tier 1a + 1b + analyze green on feature branch
2. Tier 2 on iOS sim (solver changed)
3. Existing seq 22–30 + seq 01–02 gates still green
4. Update PM_PLAN Phase 6 checkboxes + this file

See [TECH_DEBT.md](../TECH_DEBT.md) for backlog.
