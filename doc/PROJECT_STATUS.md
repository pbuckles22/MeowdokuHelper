# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-11 (`main` — Phase 7 QA hardening in progress; uncommitted local changes)

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

**Tests (2026-06-11):** Tier 1b — **59** passed, 15 skipped (FFI); Tier 1a — **28 Rust**; `flutter analyze` clean. Tier 2 — **6/6 green** iPhone 13 sim post-EPIC-6. See [QC_STATUS.md](QC_STATUS.md), [TEST_COVERAGE_EVAL.md](TEST_COVERAGE_EVAL.md).

---

## Next up

**Phase 7 — QA hardening** ([PM_PLAN.md](../PM_PLAN.md)):

- [x] Q2 Tier 2 iOS re-run
- [ ] Q1 human-verify t6 seq 22–30 ([qa_derivations/t6-seq22-30-human.md](qa_derivations/t6-seq22-30-human.md))
- [ ] Q3 spec-verify tier synthetics (one tier / QA session)
- [ ] Commit + push governance + Phase 7 test/doc changes on `main`

Then: hint UI epic (FRB) when Phase 7 acceptance met.

---

## Deferred (do not extend)

- Julia runtime in app bundle
- Multi-move solver API / hint explanations without FRB story
