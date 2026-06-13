# Agent handoff — MeowdokuHelper

## Purpose

**MeowdokuHelper** is an FFI-accelerated Star Battle puzzle solver (N×N grids; N=9 first). It ingests a board screenshot from the device clipboard, parses the grid in a Dart isolate, and uses a Rust CSP state machine to compute the next logical move.

**Product SDD (canonical):** [doc/requirements/product.md](doc/requirements/product.md)

Bootstrapped from the updated [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template) with full SDD/agentic layer (June 2026).

**CRITICAL:** FFI bindings between Flutter, Rust, and iOS/macOS are **fragile**. Changes to build configs, Podfile, `Cargo.toml`, `flutter_rust_bridge.yaml`, or Xcode project files can break the stack. Read [docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md) before touching these.

**Julia:** Build scripts retain Julia FFI hooks from the template; **do not invoke Julia at runtime** (bundle size / latency). See [doc/requirements/product.md](doc/requirements/product.md).

**Sync:** Manual copy from AgenticTemplate for `.cursor/` and governance files — never git-merge upstream into this repo (protects FFI). Template repo cleanup: [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md). See [Syncing the agentic layer](#syncing-the-agentic-layer).

---

## Source of truth

- **Scope / sprints:** [PM_PLAN.md](PM_PLAN.md)
- **Epics & stories:** [doc/plan/EPICS_AND_STORIES.md](doc/plan/EPICS_AND_STORIES.md) · [fixtures](doc/plan/FIXTURES.md) · [solver algorithms](doc/requirements/solver_algorithms.md)
- **Product SDD:** [doc/requirements/product.md](doc/requirements/product.md)
- **Architecture:** [docs/COMPREHENSIVE_ARCHITECTURE.md](docs/COMPREHENSIVE_ARCHITECTURE.md)
- **Setup:** [docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md)
- **Testing:** [TEST_PLAN.md](TEST_PLAN.md), [.cursor/skills/TEST_TDD.md](.cursor/skills/TEST_TDD.md) (primary); [docs/TESTING_STRATEGY.md](docs/TESTING_STRATEGY.md) (deprecated Wordle-era)
- **Skills:** [.cursor/skills/](.cursor/skills/)

## Green and clean operating model

- **Green:** verifiable acceptance criteria; appropriate test tier green before commit
- **Clean:** durable state in tracked docs; compressed handoffs

Skills: [green-and-clean](.cursor/skills/green-and-clean/SKILL.md), [context-bootstrapper](.cursor/skills/context-bootstrapper/SKILL.md), [session-summarizer](.cursor/skills/session-summarizer/SKILL.md), [eval-engineer](.cursor/skills/eval-engineer/SKILL.md)

## Context hierarchy

Contributors and agents use **tracked docs only** for product truth. See [CONTRIBUTING.md](CONTRIBUTING.md).

- **Level 1:** [CONTRIBUTING.md](CONTRIBUTING.md), [doc/PROJECT_STATUS.md](doc/PROJECT_STATUS.md), this file
- **Level 2:** [PM_PLAN.md](PM_PLAN.md), [TEST_PLAN.md](TEST_PLAN.md), [doc/requirements/product.md](doc/requirements/product.md)
- **Level 3:** current task plan + acceptance criteria from PM_PLAN phase
- **Level 4 (optional, local only):** `.cursor/handoff/NNNN-handoff-*.md` — gitignored; never sole source of truth

## Governance

- [RISKS.md](RISKS.md) — top 5 risks
- [RELEASE.md](RELEASE.md) — merge-ready / rollback
- [TECH_DEBT.md](TECH_DEBT.md) — ranked debt backlog
- [INCIDENTS.md](INCIDENTS.md) — incident capture minimum

## High-risk files (DO NOT CHANGE without FFI understanding)

| File/Directory | Risk | Why |
|----------------|------|-----|
| `meowdoku_helper/ios/` | **CRITICAL** | Xcode, Podfile, build phases |
| `meowdoku_helper/rust/Cargo.toml` | **CRITICAL** | Rust deps, FFI bridge |
| `meowdoku_helper/flutter_rust_bridge.yaml` | **CRITICAL** | Codegen config |
| `meowdoku_helper/rust_builder/` | **HIGH** | Cargokit |
| `meowdoku_helper/pubspec.yaml` | **HIGH** | Flutter deps, FFI plugin |
| `meowdoku_helper/lib/src/rust/` | **HIGH** | Generated bindings — never edit |

## Pod (agents always working)

- **Techwriter:** README, AGENT_HANDOFF, docs/
- **Tester:** Run test gate after changes; see TEST_PLAN.md
- **Handoff:** code-reviewer + tech-debt-evaluator + tests → handoff note ([handoff-checklist](.cursor/rules/handoff-checklist.mdc))

## Contributor onboarding (norm)

All contributors (human or agent) bootstrap from tracked files:

1. [CONTRIBUTING.md](CONTRIBUTING.md)
2. [doc/PROJECT_STATUS.md](doc/PROJECT_STATUS.md)
3. [PM_PLAN.md](PM_PLAN.md) → [doc/requirements/product.md](doc/requirements/product.md)

When shipping work: update **PM_PLAN** checkboxes, **doc/PROJECT_STATUS.md**, and **Current state** below in the same PR.

## Current state

- **Active branch:** `main` @ `0e6234e` — Phase 8 / EPIC-8 complete; golden codegen CI check wired (2026-06-12)
- **Branch policy:** One feature branch per user story — `feature/us-{epic}.{story}-<slug>`; merge each to `main` separately. **Settle first:** [handoff checklist](.cursor/rules/handoff-checklist.mdc) Phase A before commit; CI (Phase B); local handoff note last (Phase C). **QA/Coder:** [TEST_PLAN.md](TEST_PLAN.md); backward audit: `./scripts/qa_oracle_audit.sh --strict`.
- **Phases 0–7:** Done (bootstrap through EPIC-7 QA hardening)
- **US-6.1–6.3:** Done — T4 Phantom, T5 Crowding, T6 DFS rename (`run_tiers_1_through_6`)
- **Solver (shipped):** T1–T3 + T4 phantom + T5 crowding + T6 DFS (`tier4.rs`); orchestrator `run_tiers_1_through_6`
- **Health audit (2026-06-11):** Done — remediation on `main`; see [TECH_DEBT.md](TECH_DEBT.md)
- **Image pipeline:** `lib/image/` → `lib/app/clipboard_flow.dart` → `solveParsedGrid()` → FRB
- **UI:** `PuzzleGridPreview` — forced highlight, branch-required banner (`-2`), or stalled (`-1`)
- **Fixtures:** seq `01`–`42` ([FIXTURES.md](doc/plan/FIXTURES.md)); parse goldens 01–08; gates t2/t3 09–17, t4 18–19, t6 22–30; hint API uniqueness filter (H1); solver golden Dart **generated** from Rust SSOT (`./scripts/generate_solver_goldens.sh`)
- **Lint / Tier 1:** `flutter analyze` clean; **125 Flutter passed** / **52 skipped** (Linux); **37 Rust** (`cargo test --lib`)
- **CI:** [run 27451959956](https://github.com/pbuckles22/MeowdokuHelper/actions/runs/27451959956) — Tier 1 + Tier 2 **success** (2026-06-12, merge-ready includes golden codegen `--check`)
- **Tier 2:** 6 integration tests — green on GitHub `macos-14` (run 27451959956, 2026-06-12)
- **FFI:** `init_app`, `calculate_next_move` only; return `>=0` uniqueness-forced, `-2` branch/alternate, `-1` stuck; regenerate after `rust/src/api/*.rs` changes
- **Guardrails:** [docs/POLYGLOT_GUARDRAILS.md](docs/POLYGLOT_GUARDRAILS.md)
- **Phase 7 / EPIC-7:** Closed 2026-06-12 — Q1–Q6 done; **`qa_oracle_audit.sh --strict` PASS**
- **Phase 8 / EPIC-8:** Closed 2026-06-12 — H1–H4 shipped (uniqueness filter, T4 gate, inventory, golden codegen)
- **Health audit:** Refreshed 2026-06-12 — [.cursor/handoff/AUDIT_BASELINE.md](.cursor/handoff/AUDIT_BASELINE.md)
- **Next:** Phase 9+ backlog — seq 20–21, 31–42 gates; Hint UX (FRB contract)

## Run and test

```bash
cd meowdoku_helper
flutter pub get
flutter run

# Tier 1a: Rust
cd rust && cargo test && cd ..

# Tier 1b: Flutter
flutter test

# Tier 2: Integration (device/simulator)
flutter test integration_test/
```

**Merge-ready gate:** `./scripts/merge_ready.sh` (Tier 1). **CI:** `.github/workflows/ci.yml` — Tier 1 on Ubuntu + Tier 2 iOS integration on macOS. **Oracle gate (Phase 7):** `./scripts/qa_oracle_audit.sh --strict` (manual; not in default CI).

## Conventions

- **Solver logic:** Rust only; size-aware `Board`; tiers per [doc/requirements/product.md](doc/requirements/product.md)
- **Image parsing:** Dart isolate + `pasteboard`; N from unique region colors (Phase 2+)
- **FFI:** flutter_rust_bridge — `calculate_next_move(state, regions, grid_size) -> i32`; regenerate after API changes. **Guardrails:** [docs/POLYGLOT_GUARDRAILS.md](docs/POLYGLOT_GUARDRAILS.md)
- **TDD:** Failing test first per [TEST_TDD.md](.cursor/skills/TEST_TDD.md)

---

## Git workflow

1. **Integration branch:** `main`
2. **Feature branches:** `feature/<topic>`, `fix/<topic>` — [github-feature-workflow](.cursor/skills/github-feature-workflow/SKILL.md)
3. **Before commit / push / merge:** run [handoff checklist](.cursor/rules/handoff-checklist.mdc) **Phase A** — code review, tech debt, merge-ready gate (+ Tier 2 when applicable); update **AGENT_HANDOFF**, **doc/PROJECT_STATUS.md**, **PM_PLAN**. **Do not commit until Phase A is complete.**
4. **Phase B:** commit → push → merge to `main` → push `main` → **CI verify** (`gh run watch` when Actions exist). No loose strings.
5. **Phase C (last):** write gitignored `.cursor/handoff/` peer summary (includes CI URL/conclusion). This is for the next agent — not checked in.
6. **After merge:** delete feature branch

---

## Handoff protocol

**Order:** technical settlement → tracked docs → git + CI → **local handoff note last**.

1. **Phase A** — [handoff-checklist](.cursor/rules/handoff-checklist.mdc): code review, tech debt, tests (+ Tier 2 when required)
2. **Epic closure** (when last story of an epic): [epic-closure-gate](.cursor/skills/epic-closure-gate/SKILL.md) + `./scripts/epic_closure_check.sh` — see [doc/SDLC.md](doc/SDLC.md)
3. **Project health audit** (phase boundary): [project-health-audit](.cursor/skills/project-health-audit/SKILL.md)
4. Update [PM_PLAN.md](PM_PLAN.md) when scope ships
5. Update **[doc/PROJECT_STATUS.md](doc/PROJECT_STATUS.md)** and **Current state** above (required — on GitHub)
6. **Phase B** — commit → push → merge → CI verify (`gh run watch` when Actions exist)
7. **Phase C (last)** — local session note: `.cursor/handoff/NNNN-handoff-YYYY-MM-DD_HHmm.md` ([template](.cursor/handoff/_template.md)) — gitignored peer summary with CI conclusion; copy-paste for next agent

**QA / Coder:** Tests and oracles are QA-owned; implementation is Coder-owned. See [TEST_PLAN.md](TEST_PLAN.md) → QA / Coder separation. **Backward audit:** `./scripts/qa_oracle_audit.sh` + [doc/QA_ORACLE_AUDIT.md](doc/QA_ORACLE_AUDIT.md) + [doc/qa_oracle_manifest.yaml](doc/qa_oracle_manifest.yaml).

---

## Syncing the agentic layer

Manual copy from `~/Dev/AgenticTemplate` — copy `.cursor/`, `INCIDENTS.md`, `RISKS.md`, `TECH_DEBT.md`, `RELEASE.md`; merge SDD sections into this file; **keep** stack-specific `DEV_GUIDE.md`, `TEST_TDD.md`, `always.mdc`. **Upstream:** copy `github-feature-workflow/SKILL.md` from this repo into AgenticTemplate when updating the multi-project template (per-commit gate + \*optional\* Tier 2/FFI asterisks).

Do **not** git-merge AgenticTemplate into this repo (FFI risk).
