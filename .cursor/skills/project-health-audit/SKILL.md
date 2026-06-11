---
name: project-health-audit
description: >-
  Deep codebase health audit: structure, code flow, dead code, efficiency,
  comments, AI-smell review, and test coverage matrix. Use at phase boundaries,
  before major refactors, or when the user asks for a full project review.
  Lighter epic-closure-gate runs after every epic.
---

# Project health audit — MeowdokuHelper

**Cadence:** Phase boundaries (PM_PLAN phase complete → next phase start), or on demand. **Not** every user story — use **epic-closure-gate** per epic.

**Plan template:** [.cursor/handoff/PROJECT_HEALTH_AUDIT.md](../../.cursor/handoff/PROJECT_HEALTH_AUDIT.md) (example output from 2026-06-11 audit).

---

## Roles

| Phase | Lead skill | Partner skills |
|-------|------------|----------------|
| 0 Baseline | tech-lead | tester (gate) |
| 1 Structure | tech-lead | code-reviewer |
| 2 Code flow | tech-lead | — |
| 3 Readability / comments | code-reviewer | code-quality-gate |
| 4 Efficiency | code-reviewer | — |
| 5 Test coverage | tester | eval-engineer |
| 6 Synthesis | tech-lead | tech-debt-evaluator |

---

## Phases (read-only first)

1. **Baseline** — merge-ready gate; test counts; code-flow diagram; phase completion vs PM_PLAN → `AUDIT_BASELINE.md`
2. **Structure** — folder layout vs DEV_GUIDE; extraneous files PASS/WARN/FAIL
3. **Code flow** — file responsibilities; coupling; move vs keep
4. **Readability** — comment scorecard; stale copy; AI/template smells
5. **Efficiency** — hot paths; accept vs defer
6. **Coverage** — module × tier × fixture matrix; missing red/green tests
7. **Synthesis** — remediation waves in TECH_DEBT.md; ROI ranking

**Rule:** Record findings first; batch fixes in waves (see TECH_DEBT § Audit remediation waves).

---

## Deliverables

| Artifact | Location | Tracked? |
|----------|----------|----------|
| Baseline | `.cursor/handoff/AUDIT_BASELINE.md` | Yes (optional commit) |
| Full findings | `.cursor/handoff/PROJECT_HEALTH_AUDIT.md` | Yes (optional commit) |
| Backlog | `TECH_DEBT.md` | Yes |
| Handoff | `.cursor/handoff/NNNN-handoff-*-supplement.md` | Gitignored |

---

## When to run full audit vs epic closure

| Event | epic-closure-gate | project-health-audit |
|-------|-------------------|----------------------|
| Story merged | — | — |
| Epic completed | **Yes** | — |
| Phase completed (e.g. EPIC-5) | **Yes** | **Yes** |
| Before Phase 6+ / major refactor | — | **Yes** |
| User: "review the codebase" | — | **Yes** |
