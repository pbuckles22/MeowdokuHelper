# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-12 (Phase 7 closure + Phase 8 plan + health audit refresh)

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver: clipboard screenshot → Dart isolate → Rust CSP engine (full **T1–T6 ladder**) → next move. **Phase 7 complete** — QA hardening & oracle proof (Q1–Q6); `./scripts/qa_oracle_audit.sh --strict` passes; EPIC-7 closed.

**Canonical spec:** [requirements/product.md](requirements/product.md)

---

## Active branch

| Branch | Role |
|--------|------|
| **`main`** | Integration branch; Phase 7 closed |

**New contributors:** `git checkout main && git pull origin main`

---

## Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0–6 | Done | Bootstrap through EPIC-6 T1–T6 ladder |
| Phase 7 | Done | EPIC-7 QA hardening (2026-06-12); strict oracle audit PASS |
| Health audit + remediation | Done | [TECH_DEBT.md](../TECH_DEBT.md) (2026-06-11) |

**Tests:** Tier 1b — **119** passed / **48** skipped (FFI on Linux); Tier 1a — **34** Rust; `flutter analyze` clean. CI Tier 1+2 green (2026-06-12). Tier 2 — **6/6** GitHub `macos-14`.

---

## Next up

**Phase 8 — Fixture completion & hint truth** ([PM_PLAN.md](../PM_PLAN.md)):

- [ ] **H1 / US-8.1** — T1–T5 uniqueness filter on hint API
- [ ] **H2 / US-8.2** — T4 fixture gate seq 18–19
- [ ] **H3 / US-8.3** — 42-fixture inventory script
- [ ] **H4 / US-8.4** — Golden codegen Rust↔Dart

**Health audit:** Refreshed 2026-06-12 ([AUDIT_BASELINE.md](../.cursor/handoff/AUDIT_BASELINE.md)).

**Deferred (Phase 9+):** Hint UX (rule name + highlights — FRB change); seq 31–42 full gates.

---

## Deferred (do not extend)

- Julia runtime in app bundle
- Multi-move solver API / hint explanations without FRB story
