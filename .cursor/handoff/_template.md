# Handoff — NNNN — YYYY-MM-DD HHmm

(Filename: `NNNN-handoff-YYYY-MM-DD_HHmm.md` — monotonic serial + date + 24h time required.)

**Recorded:** YYYY-MM-DDTHH:mm (ISO-8601)

**When to write this file:** **Last** — after Phase B (commit → push → merge → CI) is settled. Tracked docs (`AGENT_HANDOFF`, `PROJECT_STATUS`, `PM_PLAN`) were already updated before commit. This note is the peer copy-paste summary.

**Before writing:** Complete [handoff-checklist.mdc](../rules/handoff-checklist.mdc) Phase A + B. Do not write this note until CI (or confirmed local gate on `main`) is green.

## TL;DR (1–2 sentences)

(Current state + the single most important thing the next agent must know.)

## Ship status

(done | WIP | blocked — and `main` @ `<sha>`, push/CI state)

## Decisions made (decision + rationale)

-

## Next steps (prioritized, verifiable)

1.
2.

## Code review

(Required. Summary from code-reviewer: PASS/WARN/FAIL + brief.)

## Tech debt

(Required. Summary from tech-debt-evaluator: "Do first" or short list.)

## Code coverage

(Required. Merge-ready gate — green? pass/skip counts.)

## CI

(Required when Actions exist: run URL, conclusion, or "no CI — local gate green on `main` @ `<sha>`".)

## Tier 2

(Run result, waiver, or N/A.)

## Project readiness

(Optional. Summary from your project's readiness skill, or N/A.)

## Security review

(If relevant. Summary from security-reviewer: PASS/WARN/FAIL + brief; or N/A.)

## Done this session

-
-

## Next up

-

## Open questions / blockers

-
( none )

## Handoff filename (mandatory)

- Save as: `.cursor/handoff/NNNN-handoff-YYYY-MM-DD_HHmm.md`
- **`NNNN` must be new** (see [.cursor/handoff/README.md](README.md)). Never overwrite an existing handoff.

## Key files (optional)

-
-
