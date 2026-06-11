# DEV_GUIDE — MeowdokuHelper

## Tech stack

- **Frontend:** Flutter 3.9.2+ (iOS, Android app runners; macOS via rust_builder for FFI builds)
- **Backend:** Rust 1.70+ with flutter_rust_bridge 2.12.0
- **Julia:** Template build only — **not invoked at runtime** (see product SDD)
- **FFI bridge:** flutter_rust_bridge for seamless Dart ↔ Rust calls
- **Build system:** Cargokit (rust_builder/) for cross-platform Rust compilation

## Architecture

```
MeowdokuHelper/
├── assets/test_fixtures/        # Canonical board JPEGs (Tier 1 source)
├── meowdoku_helper/             # Main Flutter project
│   ├── lib/
│   │   ├── main.dart            # App entry + clipboard orchestration
│   │   ├── app/                 # UI layer (preview, lifecycle, solve bridge)
│   │   ├── image/               # JPEG parse pipeline (isolate)
│   │   ├── services/            # FFI service layer
│   │   ├── exceptions/          # FfiInitializationException
│   │   └── src/rust/            # Generated FFI bindings (DO NOT EDIT)
│   ├── rust/
│   │   ├── src/
│   │   │   ├── lib.rs           # api + solver modules
│   │   │   ├── api/             # FRB-exposed functions
│   │   │   └── solver/          # Board + tier1..tier4
│   │   └── Cargo.toml
│   ├── rust_builder/            # Cargokit FFI plugin
│   ├── ios/, android/
│   ├── test/                    # Tier 1b Flutter tests
│   ├── integration_test/        # Tier 2 E2E (+ bundled fixtures)
│   └── flutter_rust_bridge.yaml
├── doc/requirements/product.md  # Canonical Star Battle SDD (authoritative)
├── doc/plan/FIXTURES.md         # Fixture catalog
└── docs/                        # Setup, archive (template-era docs)
```

**Solver module:** `meowdoku_helper/rust/src/solver/` — size-aware `Board` (`Vec<u8>`, `size: u32`); algorithms use `self.size`, not hardcoded 9. See [doc/requirements/product.md](../../doc/requirements/product.md).

## Solver FFI

Expose the solver via **flutter_rust_bridge**, not raw `extern "C"`:

```rust
// rust/src/api/meowdoku.rs
#[flutter_rust_bridge::frb(sync)]
pub fn calculate_next_move(
    state: Vec<u8>,
    regions: Vec<u8>,
    grid_size: u32,
) -> i32
```

Init lives in `rust/src/api/simple.rs` (`init_app`). Dart bindings: `lib/src/rust/frb_generated.dart` + `lib/src/rust/api/meowdoku.dart`.

## FFI workflow

### Adding a new Rust function

1. **Define in Rust** (`meowdoku_helper/rust/src/api/`):
   ```rust
   #[flutter_rust_bridge::frb(sync)]
   pub fn my_new_function(input: String) -> String {
       format!("Processed: {}", input)
   }
   ```

2. **Regenerate bindings:**
   ```bash
   cd meowdoku_helper
   flutter_rust_bridge_codegen generate
   ```

3. **Use in Dart** (bindings appear in `lib/src/rust/api/`):
   ```dart
   import 'package:meowdoku_helper/src/rust/api/meowdoku.dart';
   ```

4. **Test both sides:**
   - Rust: `#[cfg(test)]` in the API or solver module
   - Flutter: `test/` for Dart-side; `integration_test/` for full native FFI

### Attribute reference

| Attribute | Use case |
|-----------|----------|
| `#[flutter_rust_bridge::frb(sync)]` | Synchronous call, returns immediately |
| `#[flutter_rust_bridge::frb(init)]` | Initialization function |
| `pub async fn` | Async function (runs on Rust thread pool) |

## High-risk areas

See [docs/POLYGLOT_GUARDRAILS.md](../../docs/POLYGLOT_GUARDRAILS.md) for cross-language FFI, threading, error-handling, and build-toolchain rules.

| Area | Risk | Mitigation |
|------|------|------------|
| `ios/Podfile` | Breaks iOS build | Don't modify unless fixing CocoaPods issues |
| `ios/Runner.xcodeproj` | Breaks iOS build | Use Xcode for project changes |
| `rust/Cargo.toml` | Breaks FFI | Test `cargo build` after changes |
| `flutter_rust_bridge.yaml` | Regenerates all bindings | Backup `lib/src/rust/` first |
| `lib/src/rust/` | Generated code | Never edit manually |

## Conventions

- **Pure functions:** Prefer pure functions in Rust for testability.
- **Error handling:** Use `Result<T, E>` in Rust; catch in Dart.
- **Memory:** Rust owns data; pass copies across FFI boundary.
- **Testing:** Tier 1a `cargo test`, Tier 1b `flutter test`, Tier 2 `integration_test/`. See TEST_TDD.md.
- **Documentation:** Update `doc/` for product changes; `docs/` for setup/architecture.

## Commands reference

```bash
# Flutter
flutter pub get
flutter analyze
flutter run
flutter test
flutter test integration_test/

# Rust
cd meowdoku_helper/rust
cargo test --lib
cargo clippy

# FFI regeneration
cd meowdoku_helper
flutter_rust_bridge_codegen generate
```
