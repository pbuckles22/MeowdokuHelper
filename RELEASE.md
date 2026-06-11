## Release / merge discipline (lightweight)

Keep releases/merges boring and reversible.

### Merge-ready (minimum — every story)

Document your real gate in `AGENT_HANDOFF.md` and `TEST_PLAN.md`, then treat it as mandatory:

- Tier 1 is green (fast feedback)
- Tier 2 is run when behavior demands integration/E2E validation
- Tracked docs updated when workflow/expectations change
- Rollback path is clear (a revert commit is usually sufficient)

Per-story workflow: [.cursor/rules/handoff-checklist.mdc](.cursor/rules/handoff-checklist.mdc)

---

## SDLC cadence (epic & phase gates)

Three layers — **do not skip epic closure** when starting the next epic.

| Layer | When | Skill / rule | Enforced by |
|-------|------|--------------|-------------|
| **Story handoff** | Every commit / merge to `main` on a story | [handoff-checklist.mdc](.cursor/rules/handoff-checklist.mdc) | Agent rule; merge habit |
| **Epic closure** | Last story of an epic on `main`; before next epic | [epic-closure-gate](.cursor/skills/epic-closure-gate/SKILL.md) · [epic-closure.mdc](.cursor/rules/epic-closure.mdc) | Skill + `scripts/epic_closure_check.sh` |
| **Project health audit** | PM_PLAN **phase** complete; before major phase (e.g. Phase 6); on demand | [project-health-audit](.cursor/skills/project-health-audit/SKILL.md) | TECH_DEBT waves; audit artifacts |

**Human-readable overview:** [doc/SDLC.md](doc/SDLC.md)

### Epic closure (after each epic)

1. Merge-ready gate green
2. Delete merged feature branches (local + remote)
3. **tech-debt-evaluator** → promote to `TECH_DEBT.md`
4. Sync `AGENT_HANDOFF`, `doc/PROJECT_STATUS`, `doc/QC_STATUS`, `EPICS_AND_STORIES`
5. Handoff note
6. `./scripts/epic_closure_check.sh` → PASS

### Project health audit (phase boundaries)

Everything in epic closure, plus structured review (structure, flow, comments, efficiency, coverage matrix) and remediation waves in `TECH_DEBT.md`. Example: audit before EPIC-6 / Phase 6.

### How to enforce

| Mechanism | What it catches |
|-----------|-----------------|
| **Cursor rule** `epic-closure.mdc` | Agent must run gate when epic/phase docs change |
| **Skills** | Repeatable checklist for agents |
| **`scripts/epic_closure_check.sh`** | Stale branches, doc SHA drift, gate red |
| **PR template** | Human checkbox on epic-ending PRs |
| **EPICS_AND_STORIES** | Epic marked **Done** only after closure PASS |
| **CI (future)** | Run `epic_closure_check.sh` on `main` weekly or on release tags |

CI is optional — local script + agent rule is the minimum bar today.

---

### Rollback

- Prefer a single revert commit per change
- If a change affects your “stable” line, revert immediately and re-run the required validation tier(s)
