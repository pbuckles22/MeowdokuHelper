# Contributing to MeowdokuHelper

Thank you for contributing. This project uses **tracked documentation** as the source of truth — not chat history, not local handoff files, and not deprecated scratch exports.

## Start here (reading order)

Read in this order before opening a PR:

1. [README.md](README.md) — what the project is
2. **[doc/PROJECT_STATUS.md](doc/PROJECT_STATUS.md)** — what's done, what's next, active branch
3. [PM_PLAN.md](PM_PLAN.md) — phased checklist and acceptance criteria
4. [doc/requirements/product.md](doc/requirements/product.md) — **canonical product SDD** (do **not** use `geminidata.txt`)
5. [AGENT_HANDOFF.md](AGENT_HANDOFF.md) — merge-ready gate, high-risk FFI paths, conventions
6. [TEST_PLAN.md](TEST_PLAN.md) — Tier 1a / 1b / 2 test commands

For iOS/device work: [docs/MAC_IOS_TEST.md](docs/MAC_IOS_TEST.md).

## Local session notes vs GitHub

| Location | On GitHub? | Purpose |
|----------|------------|---------|
| `doc/PROJECT_STATUS.md` | **Yes** | Human-readable current state — **update when phases ship** |
| `AGENT_HANDOFF.md` → Current state | **Yes** | Agent + maintainer snapshot — keep in sync with PROJECT_STATUS |
| `PM_PLAN.md` | **Yes** | Phase checklists |
| `.cursor/handoff/*-handoff-*.md` | **No** (gitignored) | Optional local session diary only |
| `doc/handoff/*-HANDOFF-*.md` | **No** (gitignored by default) | Same — promote decisions to tracked docs before merge |

**Norm:** If a decision affects what contributors build next, it belongs in `doc/PROJECT_STATUS.md` and `AGENT_HANDOFF.md` — not only in a handoff note.

## Development setup

### Prerequisites

- Flutter SDK 3.9.2+ (see `meowdoku_helper/pubspec.yaml`)
- Rust 1.70+ (`rustup` recommended)
- **macOS + Xcode** for full FFI and iOS (Windows/Linux can run Rust tests; Flutter FFI unit smoke may skip without native lib)

### Clone and branch

```bash
git clone https://github.com/pbuckles22/MeowdokuHelper.git
cd MeowdokuHelper
git fetch origin
# Check doc/PROJECT_STATUS.md for active integration branch
git checkout main   # or the branch named in PROJECT_STATUS
```

### Install and test

```bash
cd meowdoku_helper
flutter pub get

# Tier 1a — Rust
cd rust && cargo test --lib && cd ..

# Tier 1b — Flutter
flutter test

# Tier 2 — device/simulator (Mac)
cd ios && pod install && cd ..
flutter test integration_test/app_smoke_test.dart -d <device-id>
```

**Merge-ready gate** (required before merge to `main`):

```bash
cd meowdoku_helper
flutter test && cd rust && cargo test --lib && cd ..
```

See [TEST_PLAN.md](TEST_PLAN.md) for tier details.

## Branch workflow

1. **`main`** — integration branch (when no other branch is named in PROJECT_STATUS)
2. Create **`feature/<topic>`** or **`fix/<topic>`** from latest `main`
3. Run merge-ready gate locally
4. Open a PR using the template checklist
5. Delete the feature branch after merge

Do not git-merge the upstream [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template) into this repo (FFI fracture risk). See [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md) for template maintenance.

## High-risk areas (read before editing)

| Path | Risk |
|------|------|
| `meowdoku_helper/ios/` | CRITICAL — Xcode, Podfile |
| `meowdoku_helper/rust_builder/` | HIGH — Cargokit |
| `meowdoku_helper/flutter_rust_bridge.yaml` | CRITICAL — codegen config |
| `meowdoku_helper/rust/Cargo.toml` | CRITICAL |
| `meowdoku_helper/lib/src/rust/` | HIGH — **generated; never hand-edit** |

Before changing `rust/src/api/*.rs`: read [docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md), then regenerate:

```bash
flutter_rust_bridge_codegen generate
```

## What to work on

Pick work from [PM_PLAN.md](PM_PLAN.md) that matches [doc/PROJECT_STATUS.md](doc/PROJECT_STATUS.md) **Next up**. Do not extend legacy Wordle APIs in `rust/src/api/` — Star Battle solver lives in `rust/src/solver/` until Phase 3 wires `calculate_next_move` through FRB.

## Pull request expectations

- [ ] Scope matches an open phase or issue in PM_PLAN / PROJECT_STATUS
- [ ] Merge-ready gate green (tiers appropriate to your change)
- [ ] No secrets, credentials, or `.env` files
- [ ] If you changed `rust/src/api/`, FRB bindings regenerated
- [ ] If you completed a phase milestone, update **PM_PLAN** checkboxes and **doc/PROJECT_STATUS.md**

## Questions

Open a GitHub issue using the contribution template, or refer to [TECH_DEBT.md](TECH_DEBT.md) and [RISKS.md](RISKS.md) for known constraints.
