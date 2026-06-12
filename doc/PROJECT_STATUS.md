# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-12 (Phase 8 H1–H3 optional backlog shipped)

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver: clipboard screenshot → Dart isolate → Rust CSP engine (full **T1–T6 ladder**) → next move. **Phase 8 optional backlog (H1–H3) shipped** — hint uniqueness filter, T4 gate seq 18–19, fixture inventory script.

**Canonical spec:** [requirements/product.md](requirements/product.md)

---

## Active branch

| Branch | Role |
|--------|------|
| **`main`** | Integration branch; Phase 8 H1–H3 done |

**New contributors:** `git checkout main && git pull origin main`

---

## Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0–7 | Done | Bootstrap through EPIC-7 QA hardening |
| Phase 8 (partial) | H1–H3 done | Uniqueness filter; T4 gate 18–19; `fixture_inventory.sh` |
| Health audit + remediation | Done | [TECH_DEBT.md](../TECH_DEBT.md) (2026-06-11) |

**Tests:** Tier 1b — **125** passed / **52** skipped (FFI on Linux); Tier 1a — **37** Rust; `flutter analyze` clean. CI Tier 1+2 green (2026-06-12).

---

## Next up

**Phase 8 — remaining** ([PM_PLAN.md](../PM_PLAN.md)):

- [ ] **H4 / US-8.4** — Golden codegen Rust↔Dart

**Backlog:** seq 20–21, 31–42 full gates; Hint UX (Phase 9+).

---

## Deferred (do not extend)

- Julia runtime in app bundle
- Multi-move solver API / hint explanations without FRB story
