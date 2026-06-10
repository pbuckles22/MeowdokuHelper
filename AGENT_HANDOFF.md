# Agent handoff — MeowdokuHelper

## Purpose

**MeowdokuHelper** is an FFI-accelerated Star Battle puzzle solver (N×N grids; N=9 first). It ingests a board screenshot from the device clipboard, parses the grid in a Dart isolate, and uses a Rust CSP state machine to compute the next logical move.

**Product SDD (canonical):** [doc/requirements/product.md](doc/requirements/product.md) — do not use `geminidata.txt` (superseded).

Bootstrapped from the updated [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template) with full SDD/agentic layer (June 2026).

**CRITICAL:** FFI bindings between Flutter, Rust, and iOS/macOS are **fragile**. Changes to build configs, Podfile, `Cargo.toml`, `flutter_rust_bridge.yaml`, or Xcode project files can break the stack. Read [docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md) before touching these.

**Julia:** Build scripts retain Julia FFI hooks from the template; **do not invoke Julia at runtime** (bundle size / latency). See [doc/requirements/product.md](doc/requirements/product.md).

**Sync:** Manual copy from AgenticTemplate for `.cursor/` and governance files — never git-merge upstream into this repo (protects FFI). See [Syncing the agentic layer](#syncing-the-agentic-layer).

---

## Source of truth

- **Scope / sprints:** [PM_PLAN.md](PM_PLAN.md)
- **Product SDD:** [doc/requirements/product.md](doc/requirements/product.md)
- **Architecture:** [docs/COMPREHENSIVE_ARCHITECTURE.md](docs/COMPREHENSIVE_ARCHITECTURE.md)
- **Setup:** [docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md)
- **Testing:** [TEST_PLAN.md](TEST_PLAN.md), [docs/TESTING_STRATEGY.md](docs/TESTING_STRATEGY.md)
- **Skills:** [.cursor/skills/](.cursor/skills/)

## Green and clean operating model

- **Green:** verifiable acceptance criteria; appropriate test tier green before commit
- **Clean:** durable state in tracked docs; compressed handoffs

Skills: [green-and-clean](.cursor/skills/green-and-clean/SKILL.md), [context-bootstrapper](.cursor/skills/context-bootstrapper/SKILL.md), [session-summarizer](.cursor/skills/session-summarizer/SKILL.md), [eval-engineer](.cursor/skills/eval-engineer/SKILL.md)

## Context hierarchy

- **Level 1:** `.cursor/rules/always.mdc`, this file
- **Level 2:** `PM_PLAN.md`, `TEST_PLAN.md`, `doc/requirements/product.md`
- **Level 3:** current task plan + acceptance criteria
- **Level 4:** latest `.cursor/handoff/NNNN-handoff-*.md` or `doc/handoff/NNNN-HANDOFF-*.md`

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

## Current state

- **Bootstrap:** Template copied; app renamed to `meowdoku_helper`
- **SDD:** Reconciled in [doc/requirements/product.md](doc/requirements/product.md) (dynamic N, FRB contract, solver tiers)
- **Architecture:** Size-aware `Board` (Vec + `grid_size`); Phase 1 tests at N=9
- **Next:** Phase 1 — Rust `Board` + Tier 1 solver ([PM_PLAN.md](PM_PLAN.md))
- **Legacy:** Wordle reference UI/tests still present; replace incrementally
- **FFI:** Use flutter_rust_bridge; regenerate after `rust/src/api/*.rs` changes

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

**Merge-ready gate:** `flutter test && cd rust && cargo test && cd ..` (from `meowdoku_helper/`)

## Conventions

- **Solver logic:** Rust only; size-aware `Board`; tiers per [doc/requirements/product.md](doc/requirements/product.md)
- **Image parsing:** Dart isolate + `pasteboard`; N from unique region colors (Phase 2+)
- **FFI:** flutter_rust_bridge — `calculate_next_move(state, regions, grid_size) -> i32`; regenerate after API changes
- **TDD:** Failing test first per [TEST_TDD.md](.cursor/skills/TEST_TDD.md)

---

## Git workflow

1. **Integration branch:** `main`
2. **Feature branches:** `feature/<topic>`, `fix/<topic>` — [github-feature-workflow](.cursor/skills/github-feature-workflow/SKILL.md)
3. **Before push:** merge-ready gate green; FFI tests must pass
4. **After push:** verify CI with `gh run watch` when Actions exist
5. **After merge:** delete feature branch

---

## Handoff protocol

1. Handoff checklist: code review, tech debt, tests
2. Update PM_PLAN when scope ships
3. Session note: `.cursor/handoff/NNNN-handoff-YYYY-MM-DD_HHmm.md` ([template](.cursor/handoff/_template.md))
4. Update "Current state" only when it helps the next session

---

## Syncing the agentic layer

Manual copy from `~/Dev/AgenticTemplate` — copy `.cursor/`, `INCIDENTS.md`, `RISKS.md`, `TECH_DEBT.md`, `RELEASE.md`; merge SDD sections into this file; **keep** stack-specific `DEV_GUIDE.md`, `TEST_TDD.md`, `always.mdc`.

Do **not** git-merge AgenticTemplate into this repo (FFI risk).
