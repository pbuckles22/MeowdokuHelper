# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-11 (`main` — US-6.2 Crowding tier merged)

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver: clipboard screenshot → Dart isolate → Rust CSP engine (Tiers 1–3 + **T4 Phantom** + **T5 Crowding** + DFS) → next forced move. Validated through N=12 parsed boards. **EPIC-6 in progress** — US-6.2 done; US-6.3 DFS rename next.

**Canonical spec:** [requirements/product.md](requirements/product.md)

---

## Active branch

| Branch | Role |
|--------|------|
| **`main`** | US-6.2 merged; start US-6.3 from latest `main` |

**New contributors:** `git checkout main && git pull origin main`

---

## Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0 — Bootstrap | Done | Template, rename, SDD, agentic layer |
| Phase 1 — Rust core | Done | `Board`, Tier 1 |
| Phase 1b — Wordle removal | Done | Star Battle FFI only |
| Phase 2 — Image pipeline | Done | EPIC-2; clipboard → isolate → `GridParseShell` |
| Phase 3 — Solve + highlight | Done | EPIC-3; `clipboard_flow.dart`, grid preview |
| Phase 4 — Solver tiers | Done | EPIC-4; T2/T3 + DFS (`tier4`); seq 22–30 gate |
| Phase 5 — Progressive sizing | Done | EPIC-5; seq 14, 29–30 Tier 2 |
| Health audit + remediation | Done | Waves 1–4 complete; 5–6 partial — [TECH_DEBT.md](../TECH_DEBT.md) |
| **US-6.1 Phantom (T4)** | Done | `tier4_phantom.rs`; 3 synthetic tests |
| **US-6.2 Crowding (T5)** | Done | `tier5.rs`; 3 synthetic tests |
| Fixture catalog | Done | seq `01`–`42`; UX reference `assets/reference/` |

**Tests (2026-06-11):** Tier 1b — 50 passed, 15 skipped (FFI without native lib on host); Tier 1a — **28 Rust**; `flutter analyze` clean. Tier 2 — 6 integration (re-run after EPIC-6 completes). See [QC_STATUS.md](QC_STATUS.md).

---

## Next up — EPIC-6 (in progress)

**Goal:** DFS → T6 rename + fixture suffix re-audit. T4 Phantom ✅ · T5 Crowding ✅.

| Story | Focus |
|-------|--------|
| **US-6.3** | `run_tiers_1_through_6`; seq 22–30 gates still green; re-audit `_T{n}_` suffixes |

**Suggested branch:** `feature/us-6.3-dfs-rename-tier`

---

## Deferred (do not extend)

- Julia runtime in app bundle
- Multi-move solver API / hint explanations (FRB change — post EPIC-6)
