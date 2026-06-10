# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-10

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver (N=9 first): clipboard screenshot → Dart isolate → Rust CSP engine → next forced move.

**Canonical spec:** [requirements/product.md](requirements/product.md) — not `geminidata.txt`.

---

## Active branch

| Branch | Role |
|--------|------|
| **`cleanup/wordle-remnants`** | Current integration work — Phase 1 + Phase 1b.1; **not yet merged to `main`** |
| `main` | Stable line at last bootstrap / SDD reconcile (`35ac56e` area) — behind feature work |

**New contributors:** clone and checkout **`cleanup/wordle-remnants`** until this file says otherwise.

---

## Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0 — Bootstrap | Done | Template, rename, SDD, agentic layer |
| Phase 1 — Rust core | Done | `rust/src/solver/` — size-aware `Board`, Tier 1, N=9 tests |
| Phase 1b.1 — Wordle removal | Done | UI/tests/assets removed; placeholder app; smoke tests |

**Verified on Windows:** `cargo test --lib`, `flutter test` (FFI smoke skipped on Windows).

**Pending:** Mac/iPhone validation — [docs/MAC_IOS_TEST.md](../docs/MAC_IOS_TEST.md).

---

## Next up

1. **Mac/iPhone smoke** — `flutter test`, `integration_test/app_smoke_test.dart`, `flutter run` on device/simulator
2. **Merge** `cleanup/wordle-remnants` → `main` after smoke passes
3. **Phase 2** — Flutter image pipeline (clipboard → isolate → `state`/`regions` arrays). Fixtures: `assets/test_fixtures/`

---

## Deferred (do not extend)

- Wordle Rust exports in `rust/src/api/` — remove at **Phase 3** when `calculate_next_move` replaces FRB surface
- Upstream [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template) Wordle cleanup — [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](../docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md)

---

## Tech debt (headlines)

See [TECH_DEBT.md](../TECH_DEBT.md). Top items:

- Legacy Wordle API in `api/` until Phase 3 FRB swap
- Template repo still Wordle-heavy for new bolt-ons

---

## Reading order for new contributors

See [CONTRIBUTING.md](../CONTRIBUTING.md).
