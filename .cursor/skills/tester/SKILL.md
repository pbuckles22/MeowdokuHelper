---
name: tester
description: Black-box tests, test-first for core logic, and continuous test runs. Use when adding or changing tests or app logic. Run your project’s test command after changes; keep suite green.
---

# Tester — Project (QA role)

Use this skill when **writing or assigning tests** — the **QA mind**. For production implementation, the Coder uses the same TDD loop but must **not** own oracles or edit QA artifacts.

**First action when adding new behavior:** Read [TEST_PLAN.md](../../../TEST_PLAN.md) → **QA / Coder separation**, then [TEST_TDD.md](../TEST_TDD.md). Write a **failing** test at the appropriate tier(s) **before** Coder touches production code.

**Session rule:** If you implemented solver/parser code in this session, you are **Coder** — do not write or change test expectations, fixture goldens, or FIXTURES.md oracle rows. Start a fresh session for QA work.

---

## Role (QA)

- **Black-box tests:** Assert on **behavior** (public API: inputs and outputs). Do not depend on implementation details.
- **Independent oracle:** Expected outcomes come from spec (`solver_algorithms.md`), human solve, or trusted reference — **never** from `calculate_next_move` in the same slice that changes the solver.
- **Test-first (tiers):** Red → green at Tier 1 and/or Tier 2 per TEST_PLAN.md. QA writes red; Coder chases green.
- **Fixture assignment:** Map uploaded JPEGs to seq + minimum tier from specs and assets only — not from reading `tier*.rs`.
- **Continuous (Coder):** After handoff from QA, Coder runs the merge-ready gate after each implementation step.

## QA / Coder handoff

| Step | QA | Coder |
|------|-----|-------|
| 1 | Write failing test + record oracle in FIXTURES.md | — |
| 2 | Hand off test paths + oracle source | Implement until green |
| 3 | Re-audit if failure persists (spec/oracle) | **Must not edit tests** — escalate |

## Coder — tests are read-only

Hard rule ([qa-coder-separation.mdc](../../rules/qa-coder-separation.mdc)): Coder **cannot** change tests, goldens, or oracles because they "don't fit." That includes one-line `expected` tweaks. Escalate to QA or user; only QA may change the test.

## Source of truth

- **Separation protocol:** TEST_PLAN.md → QA / Coder separation.
- **What to test:** TEST_TDD.md.
- **Fixture oracles:** [doc/plan/FIXTURES.md](../../../doc/plan/FIXTURES.md).
