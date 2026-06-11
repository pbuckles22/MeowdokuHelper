# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-11 (EPIC-5 complete; handoff-first policy pending merge)

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver: clipboard screenshot → Dart isolate → Rust CSP engine → next forced move. Validated through N=12 parsed boards.

**Canonical spec:** [requirements/product.md](requirements/product.md) — not `geminidata.txt`.

---

## Active branch

| Branch | Role |
|--------|------|
| **`feature/handoff-first-policy`** | Governance: handoff before commit/push/merge — ready to merge |
| **`feature/us-5.1-n10-e2e`** | EPIC-5: N>9 Tier 2 E2E — ready to merge |

**New contributors:** checkout **`main`** (after merges land).

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
| **US-3.3** — E2E integration | Done | seq-08 → index 11 (N=8 parsed) on iOS 26.5 sim |
| **EPIC-3** — solve + highlight | Done | Clipboard/fixture → parse → solve → grid preview |
| **US-4.1** — intersection logic | Done | `tier2.rs` region/line claims |
| **US-4.2** — traps + locked sets | Done | `tier3.rs`; 15 Rust tests |
| **US-4.3** — DFS bifurcation | Done | `tier4.rs` |
| **US-4.4** — T4 fixture gate | Done | seq 22–30 locked; 20 Rust + 45 Flutter |
| **EPIC-4** — solver tiers | Done | T1–T3 + DFS (`tier4`); seq 22–30 gate |
| **US-5.1** — N>9 E2E | Done | seq 14: N=12 parsed, move 13; 12×12 preview test |
| **US-5.2** — multi-size N>9 | Done | seq 29–30 Tier 2 (N=10) |
| **EPIC-5** — progressive sizing | Done | No FRB/UI code changes |
| Fixture catalog | Done | seq `01`–`42`; UX reference `assets/reference/` |

**FFI (2026-06-11):** Tier 1 (46 Flutter + 20 Rust) + Tier 2 (6 integration) green on iOS 26.5 sim. See [QC_STATUS.md](QC_STATUS.md), [docs/MAC_IOS_TEST.md](../docs/MAC_IOS_TEST.md).

---

## Next up

1. **EPIC-6** (optional) — T4 Phantom + T5 Region Crowding; demote DFS to T6 ([solver_algorithms.md](requirements/solver_algorithms.md))
2. Merge pending branches: `feature/handoff-first-policy`, `feature/us-5.1-n10-e2e`

---

## Deferred (do not extend)

- Upstream [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template) Wordle cleanup — [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](../docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md)

---
