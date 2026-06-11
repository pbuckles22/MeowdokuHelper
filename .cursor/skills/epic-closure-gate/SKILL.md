---
name: epic-closure-gate
description: >-
  Mandatory gate when an epic ships to main: branch cleanup, doc sync, tech debt
  promotion, and coverage snapshot. Lighter than project-health-audit. Use when
  the last story of an epic merges, PM_PLAN epic completes, or before starting
  the next epic.
---

# Epic closure gate — MeowdokuHelper

Run this skill **when an epic is done** (last story merged to `main`). It is the routine SDLC checkpoint — not the deep audit.

**Full deep audit:** Use **project-health-audit** at **phase boundaries** (see [RELEASE.md](../../RELEASE.md) § SDLC cadence).

---

## When to run (triggers)

| Trigger | Gate |
|---------|------|
| Last user story of an epic merged to `main` | **Epic closure** (this skill) |
| Starting the **next** epic without closure on the prior one | **Epic closure** first |
| PM_PLAN phase complete (e.g. Phase 5 → Phase 6) | **Epic closure** + **project-health-audit** |
| User asks "health audit", "codebase review", "test coverage gaps" | **project-health-audit** |

---

## Roles (which skills)

| Step | Skill |
|------|--------|
| Orchestration | **tech-lead** |
| Review delta since epic start | **code-reviewer** |
| Debt promotion | **tech-debt-evaluator** |
| Tests + coverage snapshot | **tester** |
| Handoff note | **session-summarizer** |

Do **not** duplicate the full file-by-file audit here — that is **project-health-audit**.

---

## Checklist (execute in order)

### 1. Merge-ready gate

```bash
cd meowdoku_helper
flutter analyze && flutter test && cd rust && cargo test --lib && cd ..
```

Record: pass counts, skip counts (FFI), analyze status → handoff **Tests**.

### 2. Branch hygiene

```bash
git fetch origin
git branch --merged main    # locals safe to delete
git branch -r --merged main # remotes safe to delete
```

Delete merged feature branches (local `-d`, remote `git push origin --delete <name>`). **Only `main` should remain** when clean.

### 3. Tech debt

Run **tech-debt-evaluator** on the epic’s touchpoints. Promote persistent items to [TECH_DEBT.md](../../TECH_DEBT.md). Record "Do first" in handoff.

### 4. Coverage snapshot (tester)

One paragraph in handoff — no full matrix unless gaps block the next epic:

- Which fixture seqs gained goldens this epic?
- Any new modules without Tier 1 tests?
- Tier 2 run this epic? (required if solver/FFI changed)

### 5. Sync tracked docs (required before push)

Update on `main` (same commit or immediately after epic merge):

| File | Update |
|------|--------|
| [doc/plan/EPICS_AND_STORIES.md](../../doc/plan/EPICS_AND_STORIES.md) | Epic → **Done**; closure date |
| [PM_PLAN.md](../../PM_PLAN.md) | Phase checkboxes if milestone |
| [doc/PROJECT_STATUS.md](../../doc/PROJECT_STATUS.md) | Active SHA, next epic |
| [AGENT_HANDOFF.md](../../AGENT_HANDOFF.md) | *Current state* |
| [doc/QC_STATUS.md](../../doc/QC_STATUS.md) | Test counts, last QC run |

Optional: [TECH_DEBT.md](../../TECH_DEBT.md) if debt promoted.

### 6. Handoff note

Write `.cursor/handoff/NNNN-handoff-YYYY-MM-DD_HHmm.md` (gitignored) with: review, debt, tests, branches deleted, docs synced.

### 7. Mechanical verify (optional script)

```bash
./scripts/epic_closure_check.sh
```

Fix any FAIL before declaring epic closed.

---

## Definition of done (epic)

- [ ] All epic stories **Done** in EPICS_AND_STORIES
- [ ] Merge-ready gate green
- [ ] Merged branches deleted
- [ ] Tracked docs synced to current `main` SHA
- [ ] TECH_DEBT updated if needed
- [ ] Handoff note written
- [ ] `epic_closure_check.sh` PASS (or waivers documented in handoff)

---

## Output format

**EPIC CLOSURE — PASS | WARN | FAIL**

- **PASS** — Ready to start next epic
- **WARN** — Next epic can start; debt/doc drift noted
- **FAIL** — Do not start next epic until branch/doc/test blockers fixed
