# QC status — MeowdokuHelper

**Last QC run:** 2026-06-11  
**Branch:** `cleanup/wordle-api` (Wordle FRB gut + `calculate_next_move`)  
**Base:** `main` @ `6528a59` (FRB 2.12 + prior integration — **local, ahead of origin**)

---

## Ship status

| Item | Status |
|------|--------|
| Tier 1a `cargo test --lib` | **PASS** — 8 tests |
| Tier 1b `flutter test` | **PASS** — 6 tests |
| `flutter analyze` | **PASS** |
| Tier 2 iOS 26.5 simulator | **PASS** — 2 tests (`calculateNextMove` roundtrip) |
| Wordle `rust/src/api/` removed | **YES** |
| Merged to `main` | **Pending** — on feature branch |

---

## TDD / red-green policy

Documented in [TEST_PLAN.md](../TEST_PLAN.md) and [.cursor/skills/TEST_TDD.md](../.cursor/skills/TEST_TDD.md):

- New behavior: **red → green** at applicable tier before merge.
- After each change: **full merge-ready gate** (Tier 1a + 1b + analyze).
- FFI changes: **+ Tier 2** on iOS simulator.

This gut: Rust tests for `calculate_next_move` added with implementation; Dart/integration tests updated to Star Battle API; full gate green.

---

## FFI surface (post-gut)

| Rust | Dart |
|------|------|
| `init_app()` | `RustLib.init()` |
| `calculate_next_move(state, regions, grid_size) -> i32` | `calculateNextMove(...)` |

No Wordle FRB exports remain in generated bindings.

---

## Next

1. Merge `cleanup/wordle-api` → `main`
2. `git push origin main`
3. Phase 2 image pipeline
