# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-12 (`main` @ `89357e4` — Phase 7 Q5 complete)

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver: clipboard screenshot → Dart isolate → Rust CSP engine (full **T1–T6 ladder**) → next move. **EPIC-6 complete.** Phase 7 product blockers shipped: **`-2` branch-required API** (hint UI truth) and **MRV** for T6 DFS cell selection.

**Canonical spec:** [requirements/product.md](requirements/product.md)

---

## Active branch

| Branch | Role |
|--------|------|
| **`main`** | Integration branch; Phase 7 partial |

**New contributors:** `git checkout main && git pull origin main`

---

## Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0–6 | Done | Bootstrap through EPIC-6 T1–T6 ladder |
| US-7.1 | Done | t6 uniqueness block-test (`t6_qa_force.rs`); 0/9 forced |
| US-7.2 | Done | `calculate_next_move` `-2` + Flutter branch banner |
| US-7.3 | Done | MRV heuristic replaces row-major `first_empty` in T6 DFS |
| Health audit + remediation | Done | [TECH_DEBT.md](../TECH_DEBT.md) |

**Tests:** Tier 1b — **74** passed, 24 skipped (FFI on Linux); Tier 1a — **32 Rust**; `flutter analyze` clean. CI Tier 1+2 green (2026-06-12). Tier 2 — **6/6** GitHub `macos-14`.

---

## Next up

**Phase 7 remainder** ([PM_PLAN.md](../PM_PLAN.md)):

- [x] Q3 all tier synthetics — `spec-verified` (tier1–3, tier4-phantom, tier5, tier4-dfs; 2026-06-12)
- [x] Q4 parse goldens seq 03–08 — locked in `grid_goldens.dart`
- [x] Q5 T2/T3 fixture gate seq 09–17 — `t2_t3_fixtures.rs`, `t2_t3_fixture_gate_test.dart` (2026-06-12)
- [ ] Q6 P2 audit integration + seq 01–02 solve goldens

**Product hardening (optional):** Return T1–T5 index only when uniqueness block-test confirms forced; else `-2` for seq 22–30 class boards.

---

## Deferred (do not extend)

- Julia runtime in app bundle
- Multi-move solver API / hint explanations without FRB story
