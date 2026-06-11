# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-10 (post US-4.3 — EPIC-4 complete)

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver (N=9 first): clipboard screenshot → Dart isolate → Rust CSP engine → next forced move.

**Canonical spec:** [requirements/product.md](requirements/product.md) — not `geminidata.txt`.

---

## Active branch

| Branch | Role |
|--------|------|
| **`main`** | US-4.3 merged @ `3ef2924`; EPIC-4 complete |

**New contributors:** checkout **`main`**.

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
| **US-2.5** — goldens | Done | seq 01+02 locked in `grid_goldens.dart` |
| **US-2.6** — clipboard | Done | `pasteboard` on resume; JPEG magic-byte gate |
| **EPIC-2** — image pipeline | Done | Clipboard → isolate → `GridParseShell` |
| **US-3.1** — solve wire | Done | `solveParsedGrid()` → `calculateNextMove` |
| **US-3.2** — grid preview | Done | `PuzzleGridPreview` highlight / stalled banner |
| **US-3.3** — E2E integration | Done | seq-08 → isolate parse → FFI → index 41 on iOS 26.5 sim |
| **EPIC-3** — solve + highlight | Done | Clipboard/fixture → parse → solve → grid preview |
| **US-4.1** — intersection logic | Done | `tier2.rs` region/line claims |
| **US-4.2** — traps + locked sets | Done | `tier3.rs`; 15 Rust tests |
| **US-4.3** — DFS bifurcation | Done | `tier4.rs`; 19 Rust tests |
| Fixture catalog | Done | seq `01`–`32`; [solver_algorithms.md](requirements/solver_algorithms.md) |

**FFI (2026-06-10):** Tier 1 (27 Flutter + 19 Rust) + Tier 2 (3 integration) green on iOS 26.5 sim. See [QC_STATUS.md](QC_STATUS.md), [docs/MAC_IOS_TEST.md](../docs/MAC_IOS_TEST.md).

---

## Next up

1. **EPIC-5** (optional) — progressive N>9 end-to-end ([EPICS_AND_STORIES.md](plan/EPICS_AND_STORIES.md))
2. **Fixtures** — expand golden/parse coverage up seq order; T4 gate seq 22–30 ([FIXTURES.md](plan/FIXTURES.md))

---

## Deferred (do not extend)

- Upstream [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template) Wordle cleanup — [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](../docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md)

---

## Tech debt (headlines)

See [TECH_DEBT.md](../TECH_DEBT.md). Top items:

- N-detect thresholds JPEG-tuned; may need PNG/new-format tuning
- Expand goldens beyond seq 01+02 as parser evolves
- Legacy Wordle mentions in archived `docs/`

---

## QC record

Latest full gate (tests, review, debt): [QC_STATUS.md](QC_STATUS.md).

---

## Reading order for new contributors

See [CONTRIBUTING.md](../CONTRIBUTING.md).
