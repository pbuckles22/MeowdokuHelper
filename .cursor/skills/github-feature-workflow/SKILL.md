---
name: github-feature-workflow
description: >-
  Multi-project template skill: short-lived feature branches; run the full
  merge-ready test gate before every code commit (not only at merge); TDD
  red-green; push and merge to main. Sync to AgenticTemplate for all bolt-ons.
  Do not default to asking the user to open a PR.
---

# Git / GitHub feature branch workflow

**Template skill** — canonical copy lives in **AgenticTemplate** (`~/Dev/AgenticTemplate/.cursor/skills/github-feature-workflow/`). Copy this file **verbatim** into every agentic bolt-on (Flutter, browser extension, backend, CLI, etc.). Project-specific **commands** live in **AGENT_HANDOFF.md** and **TEST_PLAN.md**; this skill defines **when** to run them.

**Multi-project rule:** Steps **1–2** apply to **all** bolt-ons. Steps **3–5**, the appendix, and table rows marked *optional* are **\*optional\*** — **keep them in the file** even when a bolt-on has no Tier 2, no FFI/native bridge, or no `code-quality-gate` skill. Agents skip optional steps when `TEST_PLAN.md` / stack docs say N/A; do not delete or fork the skill per app.

**Policy:** [AGENT_HANDOFF.md](../../AGENT_HANDOFF.md) — `main` is the integration branch; the **merge-ready command** is the quality bar. **Pull requests are not the default exit** unless the user explicitly asks for a PR or GitHub review.

## Do not prompt for PRs (agents)

- **Do not** tell the user to "open a PR" or treat a PR as the normal end-of-task step.
- **Do** treat **green merge-ready** plus [tester](../tester/SKILL.md) / [TEST_TDD.md](../TEST_TDD.md) discipline as **commit-ready**.
- **If** the user wants a PR or external review: follow their request.

**Completion mental model:** one branch ≈ one purpose → **technical settlement** ([handoff-checklist](../../.cursor/rules/handoff-checklist.mdc) Phase A: review, tech debt, gate, tracked docs) → **full gate green on every code commit** → **commit** → **push** → merge to `main` → **CI verify** → **local handoff note last** (Phase C, peer summary) → delete the feature branch.

**Commit discipline (all projects):** Every `git commit` that touches application code, tests, native/FFI, or build config must leave the repo **clean**. Run the **full merge-ready gate before each such commit**. Do **not** batch testing only at merge; merge is a **second confirmation**, not the first gate.

---

## Exit criteria before **every** code commit (ship bar)

Run the **full gate before each `git commit`** that touches code, tests, native bridges, or build config.

**Exception:** trivial doc-only edits (typos, comments) with **no behavior change** — gate not required; say so in the commit message.

### 1. TDD (all projects)

[TEST_TDD.md](../TEST_TDD.md) + [tester](../tester/SKILL.md):

- **Red → green** for new/changed behavior at the tier(s) that cover the change.
- After the new test passes, **re-run the full merge-ready gate** — not only the new test.

### 2. Full merge-ready — Tier 1 + lint/analyze (all projects)

Run the **merge-ready command** documented in [AGENT_HANDOFF.md](../../AGENT_HANDOFF.md) and [TEST_PLAN.md](../../TEST_PLAN.md) (repo root).

Typical shape (replace with your project's exact command):

```bash
# Read AGENT_HANDOFF.md / TEST_PLAN.md — example pattern only
<lint-or-analyze-command>
<tier-1-fast-tests>
```

All steps in that command must pass. **Required on every code commit**, not only before merge or push.

### 3. *Optional — Tier 2 / integration / E2E*

\*Run when the project defines **Tier 2** (or equivalent) in [TEST_PLAN.md](../../TEST_PLAN.md).

- Required before commit when the change touches: UI flows, device/simulator behavior, HTTP/API integration, or anything Tier 2 is meant to catch.
- Skip only when the change is **purely** Tier 1–covered logic with no integration surface (document why in the commit message if borderline).

```bash
# Project-specific — see TEST_PLAN.md
<tier-2-command>
```

### 4. *Optional — FFI / native bridge / mobile embed*

\*Run when the project has **FFI, native modules, or mobile embed** (Flutter+Rust, React Native, WASM, etc.) and [TEST_PLAN.md](../../TEST_PLAN.md) or [AGENT_HANDOFF.md](../../AGENT_HANDOFF.md) says Tier 2 (or a device build) is required for bridge changes.

- Required before commit when touching: generated bindings, `Cargo.toml` / native deps, `ios/` / `android/`, bridge codegen, or Rust/C++ API surface.
- *Apps with no native bridge:* ignore this bullet.

### 5. *Optional — quality pass*

\*[code-quality-gate](../code-quality-gate/SKILL.md) for non-trivial edits (readability, complexity) when the project uses it.

---

When steps 1–2 (and any applicable *optional* steps) are green: **commit**. Repeat the full gate before the **next** code commit on the same branch.

## Pre-merge, pre-push, and pre-next-feature

| When | Gate |
|------|------|
| **Before commit / push / merge** | [Handoff checklist](../../.cursor/rules/handoff-checklist.mdc) Phase A — review, gate, **AGENT_HANDOFF** / **PROJECT_STATUS** / **PM_PLAN** (tracked docs before commit) |
| **After push / merge** | Phase B — CI verify when Actions exist |
| **Last (peer handoff)** | Phase C — gitignored `.cursor/handoff/` note with CI conclusion |
| **Each code commit** | Full merge-ready (+ *optional* tiers per above) — **primary discipline** |
| **Before merge to `main`** | Full gate again on feature branch tip |
| **After merge to `main`** | Full gate on `main`; *repeat Tier 2 / FFI tier if that slice touched bridge/native* |
| **Before next feature** | Full gate on updated `main` after `git pull` |
| **After push** | *Optional — CI verify* when GitHub Actions (or equivalent) exist — see step 8 below |

## Standard sequence

1. **Start from `main` (or agreed base):** `git fetch origin`; `git status`.
2. **Create branch:** `git checkout -b feature/<topic>` — **before** production code for the slice.
3. **Implement** with **red → green** per [TEST_TDD.md](../TEST_TDD.md).
4. **Gate → settle → commit → repeat:** full [exit criteria](#exit-criteria-before-every-code-commit-ship-bar); if green, update tracked docs (Phase A), then **commit**. Multiple commits per slice are fine — **each ship commit gets full gate**. **Local handoff note only once per slice**, after CI (Phase C).
5. **Commit message:** imperative subject; short body if it helps.
6. **Push:** `git push -u origin <branch>` (first time) — **after** Phase A tracked-doc updates on that slice.
7. **Integrate to `main`:** local merge or user-directed flow; **do not** nudge toward PR by default.
8. **CI verify** when Actions exist (Phase B — before local handoff note):

   ```bash
   RUN=$(gh run list --repo OWNER/REPO --limit 1 --json databaseId -q '.[0].databaseId')
   gh run watch "$RUN" --exit-status
   ```

9. **Local handoff note (Phase C):** write `.cursor/handoff/NNNN-…md` with CI conclusion — **last**, for peer copy-paste.
10. **After merge:** `git checkout main && git pull`; delete feature branch when done.

**PR:** only when the user explicitly requests it.

Tracked docs (**PM_PLAN**, **PROJECT_STATUS**, **AGENT_HANDOFF**) are updated in **Phase A**, before commit — not in the gitignored handoff note.

## What this skill does _not_ do

- Replace the **handoff checklist** — technical settlement + tracked docs run **before** commit; **local handoff note runs last** after CI; see [AGENT_HANDOFF.md](../../AGENT_HANDOFF.md) and `.cursor/rules/handoff-checklist.mdc`.
- Replace **TEST_PLAN.md** — projects must document exact commands there; this skill defines **cadence** (every commit).

---

## *Appendix — example bolt-on commands*

\*Each bolt-on documents **exact commands** in [TEST_PLAN.md](../../TEST_PLAN.md) and [AGENT_HANDOFF.md](../../AGENT_HANDOFF.md). Example (Flutter + Rust FFI app):\*

```bash
cd <app_package_dir>
flutter analyze && flutter test
cd rust && cargo test --lib && cd ..
```

\*Tier 2 / FFI — when applicable:\*

```bash
flutter test integration_test/ -d <device-or-simulator-id>
```

---

## Syncing to AgenticTemplate and bolt-ons

1. **Canonical source:** this file in `AgenticTemplate/.cursor/skills/github-feature-workflow/SKILL.md`.
2. **Bolt-ons:** manual copy into each project's `.cursor/skills/github-feature-workflow/SKILL.md` (do not git-merge upstream into FFI-sensitive repos if policy forbids it).
3. **Do not trim** *optional* / \*asterisk\* sections for simpler stacks — agents skip when N/A.
4. Each bolt-on keeps **stack-specific** commands in **TEST_PLAN.md** and **AGENT_HANDOFF.md** only; this skill stays **byte-identical** across projects.
