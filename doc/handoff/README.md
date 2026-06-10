# Handoff (optional, local)

Session handoff narratives often live in **`NNNN-HANDOFF-YYYY-MM-DD_HHmm.md`** files here or under **`.cursor/handoff/`**. Those patterns are **gitignored** by default (see root `.gitignore`) so local session notes are not pushed.

## Tracked source of truth (norm)

Contributors and agents do **not** need handoff files. They read:

1. [CONTRIBUTING.md](../CONTRIBUTING.md)
2. [PROJECT_STATUS.md](PROJECT_STATUS.md)
3. [PM_PLAN.md](../PM_PLAN.md)

Maintainers update **PROJECT_STATUS.md** and [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) when phases ship — in the same PR as the code.

If you need a **tracked** file in this folder, add a `.gitignore` exception (`!doc/handoff/YourFile.md`) so it is not matched by the `HANDOFF-*` pattern.
