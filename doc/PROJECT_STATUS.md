# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-10 (`ab2212c`)

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver (N=9 first): clipboard screenshot → Dart isolate → Rust CSP engine → next forced move.

**Canonical spec:** [requirements/product.md](requirements/product.md) — not `geminidata.txt`.

---

## Active branch

| Branch | Role |
|--------|------|
| **`main`** | Integration — Phase 0–1b complete; Phase 2 next (**local ahead of `origin`**) |

**New contributors:** checkout **`main`**.

---

## Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0 — Bootstrap | Done | Template, rename, SDD, agentic layer |
| Phase 1 — Rust core | Done | `rust/src/solver/` — size-aware `Board`, Tier 1, N=9 tests |
| Phase 1b.1 — Wordle UI/assets | Done | Placeholder app; Wordle UI/tests/assets removed |
| Phase 1b.2 — Wordle FRB gut | Done | Wordle `api/` deleted; `calculate_next_move` wired |
| FRB 2.12 | Done on `main` | Pins + regenerated bindings |
| Lint modernization | Done | `flutter_lints` 6; analyze clean |

**FFI (2026-06-11):** Tier 1 + Tier 2 green; `calculateNextMove` roundtrip on iOS 26.5 sim. See [QC_STATUS.md](QC_STATUS.md), [docs/MAC_IOS_TEST.md](../docs/MAC_IOS_TEST.md).

---

## Next up

1. **EPIC-2 / Phase 2** — branch `feature/phase2-image-pipeline`; stories [US-2.1](plan/EPICS_AND_STORIES.md)–[US-2.6](plan/EPICS_AND_STORIES.md)
2. **Fixtures** — [doc/plan/FIXTURES.md](plan/FIXTURES.md) (seq `01`–`32`; [solver_algorithms.md](requirements/solver_algorithms.md))
3. **Push** `main` to `origin` when ready

---

## Deferred (do not extend)

- Upstream [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template) Wordle cleanup — [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](../docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md)

---

## Tech debt (headlines)

See [TECH_DEBT.md](../TECH_DEBT.md). Top items:

- Legacy Wordle mentions in archived `docs/`
- Template repo still Wordle-heavy for new bolt-ons

---

## QC record

Latest full gate (tests, review, debt): [QC_STATUS.md](QC_STATUS.md).

---

## Reading order for new contributors

See [CONTRIBUTING.md](../CONTRIBUTING.md).
