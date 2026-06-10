# MeowdokuHelper

FFI-accelerated Star Battle puzzle solver: ingest a 9x9 board screenshot from the clipboard, parse it in a Dart isolate, and compute the next logical move in Rust without blocking the UI.

## Stack

- **Flutter/Dart** — UI, clipboard intake, isolate-based image pixel sampling
- **Rust** — CSP solver state machine (Halo Enforcer → Naked Singles → intersection logic → DFS fallback)
- **Julia** — bindings present in template; **not invoked in production** (reserved / bundle-size tradeoff)

## Project layout

```
MeowdokuHelper/
├── meowdoku_helper/     # Flutter + Rust FFI app
├── docs/                # Architecture and setup (from FFI template)
├── doc/requirements/    # Product SDD and requirements
├── .cursor/             # Agentic skills, rules, handoff
├── AGENT_HANDOFF.md     # Agent source of truth
└── PM_PLAN.md           # Phased implementation plan
```

## Quick start

```bash
cd meowdoku_helper
flutter pub get
flutter test
cd rust && cargo test && cd ..
```

See [AGENT_HANDOFF.md](AGENT_HANDOFF.md) for merge-ready gate, high-risk FFI files, and handoff protocol.

## SDD

Product requirements and solver tiers: [doc/requirements/product.md](doc/requirements/product.md)
