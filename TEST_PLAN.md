# Test plan — MeowdokuHelper

Three-tier testing for Flutter-Rust FFI. Solver acceptance per [doc/requirements/product.md](doc/requirements/product.md).

---

## Tier 1a: Rust unit tests (fastest)

Pure Rust logic (algorithms, data processing, word filtering).

```bash
cd meowdoku_helper/rust
cargo test --lib
```

---

## Tier 1b: Flutter unit tests (fast)

Dart logic, widget smoke tests, and FFI init where the native library is available (see [docs/MAC_IOS_TEST.md](docs/MAC_IOS_TEST.md) — FFI smoke may skip on Windows).

```bash
cd meowdoku_helper
flutter test
```

---

## Tier 2: Integration tests (requires device/simulator)

End-to-end flows, UI interactions, and real FFI performance.

```bash
cd meowdoku_helper
flutter test integration_test/
```

---

## Merge-ready gate

Run before every push to `main`:

```bash
cd meowdoku_helper
flutter test && cd rust && cargo test --lib && cd ..
```

Same checks should run in CI if you use GitHub Actions.

**Handoff:** Document the exact commands you use for coverage in AGENT_HANDOFF.md so agents can run them consistently.
