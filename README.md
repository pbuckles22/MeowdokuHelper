# MeowdokuHelper

FFI-accelerated Star Battle puzzle solver (N×N grids; N=9 first): ingest a board screenshot from the clipboard, parse it in a Dart isolate, and compute the next logical move in Rust without blocking the UI.

## New here?

**Start with [CONTRIBUTING.md](CONTRIBUTING.md)** — reading order, setup, branch workflow, and PR expectations.

**Current work:** [doc/PROJECT_STATUS.md](doc/PROJECT_STATUS.md) (what's done, active branch, what's next).

## Stack

- **Flutter/Dart** — UI, clipboard intake, isolate-based image pixel sampling
- **Rust** — CSP solver state machine (Halo Enforcer → Naked Singles → intersection logic → DFS fallback)
- **Julia** — bindings present in template; **not invoked in production** (reserved / bundle-size tradeoff)

## Project layout

```
MeowdokuHelper/
├── meowdoku_helper/       # Flutter + Rust FFI app
├── doc/requirements/      # Product SDD (canonical)
├── doc/PROJECT_STATUS.md  # Current state (tracked — for all contributors)
├── docs/                  # Setup, architecture, Mac/iOS testing
├── CONTRIBUTING.md        # Contributor onboarding
├── AGENT_HANDOFF.md       # Agent + maintainer conventions
└── PM_PLAN.md             # Phased implementation plan
```

## Quick start

```bash
git clone https://github.com/pbuckles22/MeowdokuHelper.git
cd MeowdokuHelper
# See doc/PROJECT_STATUS.md for active branch
cd meowdoku_helper
flutter pub get
flutter test
cd rust && cargo test --lib && cd ..
```

Full gate and FFI notes: [CONTRIBUTING.md](CONTRIBUTING.md), [AGENT_HANDOFF.md](AGENT_HANDOFF.md).

## SDD

Product requirements and solver tiers: [doc/requirements/product.md](doc/requirements/product.md)
