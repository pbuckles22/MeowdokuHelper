# TEST_TDD — MeowdokuHelper

## How to test

- **Black-box:** Assert on behavior (public API: inputs and outputs). Do not depend on implementation details.
- **Continuous:** Run tests after adding or changing logic; keep the suite green.
- **Three-tier:** Rust unit tests (fastest), Flutter unit tests (fast), integration tests (slowest).

See [TEST_PLAN.md](../../../TEST_PLAN.md) for tier definitions and merge gate.

---

## TDD for this project

**Default:** Do not merge production changes until the right tier(s) have **red → green** (failing test first, then implementation until green). After every change, re-run the **full merge-ready gate** so the whole suite stays green — not only the new test.

**Merge bar:** Tier 1a + Tier 1b + `flutter analyze` always; **Tier 2** required for any FFI/native change (see [TEST_PLAN.md](../../../TEST_PLAN.md)).

### Tier 1a: Rust unit tests (fastest)

Use for pure Rust logic (solver tiers, board, FRB API).

```bash
cd meowdoku_helper/rust
cargo test --lib
```

1. **Red** — Add a test in the `#[cfg(test)]` module that fails.
2. **Green** — Implement until `cargo test` passes.

### Tier 1b: Flutter unit tests (fast)

Use for Dart parse pipeline, widget tests, and FFI roundtrips (when native lib is linked).

```bash
cd meowdoku_helper
flutter test
```

1. **Red** — Add a test in `test/` that fails.
2. **Green** — Implement until `flutter test` passes.

**FFI on host:** Tests that need `RustLib.init` must use explicit `skip` when the native library is unavailable — never silently pass.

### Tier 2: Integration tests (requires device/simulator)

Use for end-to-end flows: app launch, real FFI, fixture parse → solve pipeline.

```bash
cd meowdoku_helper
flutter test integration_test/
```

1. **Red** — Add a spec in `integration_test/` that fails.
2. **Green** — Implement until the integration test passes.

### Order of tiers

- **Pure Rust logic:** Tier 1a first, then Tier 1b if FFI-exposed.
- **Flutter + FFI:** Tier 1b first, then Tier 2 for full device testing.
- **UI-only:** Tier 1b (widget tests), then Tier 2 if needed.

### Exceptions

- Docs-only, config-only, or comment-only changes.
- Trivial one-line fixes with no behavior change (still run the gate).
- Pure refactors preserving behavior: keep tests green.

Never leave failing tests on `main`.

---

## Merge-ready gate

Run before every push to `main`:

```bash
cd meowdoku_helper
flutter analyze && flutter test && cd rust && cargo test --lib && cd ..
```

---

## Test categories in this project

| Category | Location | Purpose |
|----------|----------|---------|
| FFI smoke / roundtrip | `test/ffi_smoke_test.dart`, `test/rust_ffi_roundtrip_test.dart` | Native lib init + `calculateNextMove` |
| FFI service | `test/ffi_service_test.dart` | FfiService init, double-init, errors |
| Image pipeline | `test/n_detect_test.dart`, `test/grid_golden_test.dart`, `test/decode_isolate_test.dart`, … | Parse, goldens, isolate |
| Solver bridge | `test/solve_parsed_grid_test.dart`, `test/t4_fixture_gate_test.dart` | Parse → FRB solve |
| Clipboard | `test/clipboard_parse_test.dart`, `test/clipboard_lifecycle_test.dart` | Pasteboard path |
| Widget / shell | `test/puzzle_grid_preview_test.dart`, `test/main_shell_test.dart` | UI smoke |
| Integration E2E | `integration_test/app_smoke_test.dart` | Device launch + fixture pipeline |
| Rust unit tests | `rust/src/solver/*.rs`, `rust/src/api/*.rs` | Pure Rust logic |

Fixtures: repo root `assets/test_fixtures/` (Tier 1); `integration_test/fixtures/` (Tier 2 bundled subset).
