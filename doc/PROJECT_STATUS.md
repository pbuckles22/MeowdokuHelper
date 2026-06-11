# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-11 (`main` — EPIC-6 complete, US-6.3 merged)

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver: clipboard screenshot → Dart isolate → Rust CSP engine (full **T1–T6 ladder**) → next forced move. Validated through N=12 parsed boards. **EPIC-6 complete** — Phantom (T4), Crowding (T5), DFS rename (T6).

**Canonical spec:** [requirements/product.md](requirements/product.md)

---

## Active branch

| Branch | Role |
|--------|------|
| **`main`** | EPIC-6 complete; integration branch |

**New contributors:** `git checkout main && git pull origin main`

---

## Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0–5 | Done | Bootstrap through progressive sizing |
| Phase 6 — EPIC-6 | Done | T4 Phantom, T5 Crowding, T6 DFS rename; seq 22–30 `_T6_` gate |
| Health audit + remediation | Done | [TECH_DEBT.md](../TECH_DEBT.md) |
| Fixture catalog | Done | seq `01`–`42`; UX reference `assets/reference/` |

**Tests (2026-06-11):** Tier 1b — 50 passed, 15 skipped (FFI); Tier 1a — **28 Rust**; `flutter analyze` clean. Tier 2 — re-run on iOS sim recommended post EPIC-6. See [QC_STATUS.md](QC_STATUS.md).

---

## Next up

No active epic on `main`. Candidates from [PM_PLAN.md](../PM_PLAN.md):

- Tier 2 re-run on iOS sim (solver ladder changed)
- Optional: re-audit remaining `_T4_` fixtures (seq 18–21, 31–42)
- Hint UI / multi-cell highlights (FRB change — deferred)

---

## Deferred (do not extend)

- Julia runtime in app bundle
- Multi-move solver API / hint explanations without FRB story
