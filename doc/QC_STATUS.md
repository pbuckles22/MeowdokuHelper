# QC status — MeowdokuHelper

**Last QC run:** 2026-06-11 (US-6.3 / EPIC-6 closure)  
**Branch:** `main` — EPIC-6 complete  

---

## Ship status

| Item | Status |
|------|--------|
| Tier 1b `flutter test` | **PASS** — 50 passed, 15 skipped (FFI when native lib absent) |
| Tier 1a `cargo test --lib` | **PASS** — 28 tests (T6 fixture gate) |
| `flutter analyze` | **PASS** |
| Tier 2 integration | **PENDING re-run** — last green iOS 26.5 sim pre-EPIC-6 |
| Wordle API removed | **YES** |
| EPIC-6 T1–T6 ladder | **DONE** |
| FFI test hygiene | **FIXED** — explicit skip via `test/support/native_ffi.dart` |

---

## TDD / red-green policy

[TEST_PLAN.md](../TEST_PLAN.md) · [.cursor/skills/TEST_TDD.md](../.cursor/skills/TEST_TDD.md)

- New behavior: red → green at applicable tier before merge
- Merge gate: Tier 1a + 1b + `flutter analyze`
- Solver / FRB changes: + Tier 2 on iOS simulator

---

## FFI surface (unchanged)

| Rust | Dart |
|------|------|
| `init_app()` | `RustLib.init()` |
| `calculate_next_move(state, regions, grid_size) -> i32` | `calculateNextMove(...)` |

**Today:** Full T1–T6 ladder inside `calculate_next_move`; no FRB API change.

---

## Coverage snapshot (EPIC-6)

| Area | Tier 1a | Tier 1b | Tier 2 | Gap |
|------|---------|---------|--------|-----|
| Solver T1–T6 + seq 22–30 | Strong | Strong | Partial (29–30 bundled) | Tier 2 re-run |
| T4/T5 synthetics | Strong | N/A | N/A | — |

---

## Before next epic

- [ ] Tier 2 on iOS sim after EPIC-6
- [ ] Optional: re-audit `_T4_` fixtures seq 18–21, 31–42
