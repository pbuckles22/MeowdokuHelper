# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-10 (post US-2.4 merge — see `main` tip)

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver (N=9 first): clipboard screenshot → Dart isolate → Rust CSP engine → next forced move.

**Canonical spec:** [requirements/product.md](requirements/product.md) — not `geminidata.txt`.

---

## Active branch

| Branch | Role |
|--------|------|
| **`main`** | Integration — US-2.1 merged; EPIC-2 in progress (**local ahead of `origin`**) |

**New contributors:** checkout **`main`**. Next story: `feature/us-2.5-golden` off `main`.

---

## Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0 — Bootstrap | Done | Template, rename, SDD, agentic layer |
| Phase 1 — Rust core | Done | `rust/src/solver/` — size-aware `Board`, Tier 1, N=9 tests |
| Phase 1b.1 — Wordle UI/assets | Done | Placeholder app; Wordle UI/tests/assets removed |
| Phase 1b.2 — Wordle FRB gut | Done | Wordle `api/` deleted; `calculate_next_move` wired |
| FRB 2.12 | Done | Pins + regenerated bindings |
| Lint modernization | Done | `flutter_lints` 6; analyze clean |
| **US-2.1** — fixture decode | Done | seq-01 decode tests |
| **US-2.2** — isolate entry | Done | `compute()` + `decode_isolate.dart` |
| **US-2.3** — N detect | Done | `n_detect.dart`; seq-01 → N=4, N² shells |
| **US-2.4** — cell sample | Done | `parseGridFromImage()`; isolate parse path |
| Fixture catalog | Done | seq `01`–`32`; [solver_algorithms.md](requirements/solver_algorithms.md) |

**FFI (2026-06-11):** Tier 1 + Tier 2 green; `calculateNextMove` roundtrip on iOS 26.5 sim. See [QC_STATUS.md](QC_STATUS.md), [docs/MAC_IOS_TEST.md](../docs/MAC_IOS_TEST.md).

---

## Next up

1. **US-2.5** — branch `feature/us-2.5-golden`; lock seq 01+02 expected arrays ([EPICS_AND_STORIES.md](plan/EPICS_AND_STORIES.md))
2. **US-2.6** — clipboard trigger on app focus
3. **Fixtures** — [FIXTURES.md](plan/FIXTURES.md) (seq order; goldens at US-2.5)
4. **Push** `main` to `origin` when ready

---

## Deferred (do not extend)

- Upstream [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template) Wordle cleanup — [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](../docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md)

---

## Tech debt (headlines)

See [TECH_DEBT.md](../TECH_DEBT.md). Top items:

- Lock golden `state`/`regions` per fixture (US-2.5)
- Legacy Wordle mentions in archived `docs/`
- Push `main` (~14 commits ahead of `origin`)

---

## QC record

Latest full gate (tests, review, debt): [QC_STATUS.md](QC_STATUS.md).

---

## Reading order for new contributors

See [CONTRIBUTING.md](../CONTRIBUTING.md).
