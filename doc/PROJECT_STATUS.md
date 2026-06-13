# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-12 (Phase 8 / EPIC-8 closed — golden codegen shipped)

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver: clipboard screenshot → Dart isolate → Rust CSP engine (full **T1–T6 ladder**) → next move. **Phase 8 complete** — hint uniqueness filter, T4 gate seq 18–19, fixture inventory, golden codegen (Rust SSOT → Dart).

**Canonical spec:** [requirements/product.md](requirements/product.md)

---

## Active branch

| Branch | Role |
|--------|------|
| **`main`** | Integration branch @ `008f846` — Phase 8 / EPIC-8 complete |

**New contributors:** `git checkout main && git pull origin main`

---

## Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0–7 | Done | Bootstrap through EPIC-7 QA hardening |
| Phase 8 | Done | H1 uniqueness filter; H2 T4 gate 18–19; H3 inventory; H4 golden codegen |
| Health audit + remediation | Done | [TECH_DEBT.md](../TECH_DEBT.md) (2026-06-11) |

**Tests:** Tier 1b — **125** passed / **52** skipped (FFI on Linux); Tier 1a — **37** Rust; `flutter analyze` clean. CI Tier 1+2 green (2026-06-12).

---

## Next up

**Phase 9+ / backlog** ([PM_PLAN.md](../PM_PLAN.md)):

- seq 20–21, 31–42 full gates
- Hint UX (rule name + explanation + highlights — FRB contract change)

---

## Deferred (do not extend)

- Julia runtime in app bundle
- Multi-move solver API / hint explanations without FRB story
