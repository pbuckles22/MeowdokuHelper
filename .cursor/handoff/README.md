# Handoff notes

**Committed in this repo:** `_template.md` and this README — no secrets.

## Norm (contributors + agents)

**Product state on GitHub** lives in tracked files only:

| File | Audience |
|------|----------|
| [doc/PROJECT_STATUS.md](../../doc/PROJECT_STATUS.md) | Humans — current branch, done, next |
| [AGENT_HANDOFF.md](../../AGENT_HANDOFF.md) → Current state | Maintainers + agents |
| [PM_PLAN.md](../../PM_PLAN.md) | Phase checklists |
| [CONTRIBUTING.md](../../CONTRIBUTING.md) | Onboarding reading order |

**Session narratives (gitignored — not on GitHub):**

- `.cursor/handoff/NNNN-handoff-YYYY-MM-DD_HHmm.md`
- `doc/handoff/NNNN-HANDOFF-YYYY-MM-DD_HHmm.md` (default gitignore pattern)

Before ending a session: **promote** any decision that affects future work into `doc/PROJECT_STATUS.md` and `AGENT_HANDOFF.md`. Handoff files are optional compression, not the source of truth.

See [CONTRIBUTING.md](../../CONTRIBUTING.md) and root [.gitignore](../../.gitignore).

**Process checklist:** [.cursor/rules/handoff-checklist.mdc](../rules/handoff-checklist.mdc)
