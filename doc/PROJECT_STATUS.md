# Project status

**Human-readable current state.** Keep this file in sync with [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) → *Current state* whenever a phase ships or the active branch changes.

**Last updated:** 2026-06-10

---

## Summary

MeowdokuHelper is a Star Battle N×N puzzle solver (N=9 first): clipboard screenshot → Dart isolate → Rust CSP engine → next forced move.

**Canonical spec:** [requirements/product.md](requirements/product.md) — not `geminidata.txt`.

---

## Active branch

| Branch | Role |
|--------|------|
| **`bump/flutter-rust-bridge-2.12`** | Active — FRB 2.11.1 → 2.12.0 upgrade (feature branch from `main`) |
| `main` | Integration line — Phase 1, Phase 1b.1, lint 6, FFI roundtrip tests |

**New contributors:** checkout **`main`** or the active bump branch named here.

---

## Completed

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 0 — Bootstrap | Done | Template, rename, SDD, agentic layer |
| Phase 1 — Rust core | Done | `rust/src/solver/` — size-aware `Board`, Tier 1, N=9 tests |
| Phase 1b.1 — Wordle removal | Done | UI/tests/assets removed; placeholder app; smoke tests |
| Lint modernization | Done | `flutter_lints` 6, `flutter analyze` clean on hand-written Dart |

**FFI build verified (2026-06-10):** `cargo test --lib`, `flutter test`, `flutter analyze`; Android debug APK; `cargo build --target aarch64-apple-ios-sim`.

**iOS Tier 2 (2026-06-10):** `integration_test/app_smoke_test.dart` green on **iOS 26.5** simulator (iPhone 17 Pro) — placeholder UI + FFI init + `Icons.pets`. See [docs/MAC_IOS_TEST.md](../docs/MAC_IOS_TEST.md).

---

## Next up

1. **FRB 2.12 bump** on `bump/flutter-rust-bridge-2.12` — pins + codegen + Tier 1/2 validation
2. **iOS Tier 2** when Xcode iOS 26.5 platform available (or physical device)
3. **Phase 2** — Flutter image pipeline (clipboard → isolate → `state`/`regions` arrays). Fixtures: `assets/test_fixtures/`

---

## Deferred (do not extend)

- Wordle Rust exports in `rust/src/api/` — remove at **Phase 3** when `calculate_next_move` replaces FRB surface
- Upstream [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template) Wordle cleanup — [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](../docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md)

---

## Tech debt (headlines)

See [TECH_DEBT.md](../TECH_DEBT.md). Top items:

- Legacy Wordle API in `api/` until Phase 3 FRB swap
- Template repo still Wordle-heavy for new bolt-ons

---

## QC record

Latest full gate (tests, review, debt): [QC_STATUS.md](QC_STATUS.md).

---

## Reading order for new contributors

See [CONTRIBUTING.md](../CONTRIBUTING.md).
