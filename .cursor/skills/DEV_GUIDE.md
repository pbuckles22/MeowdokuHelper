# DEV_GUIDE — MeowdokuHelper

## Tech stack

- **Frontend:** Flutter 3.9.2+ (iOS, macOS, Android)
- **Backend:** Rust 1.70+ with flutter_rust_bridge 2.11.1
- **Julia:** Template build only — **not invoked at runtime** (see product SDD)
- **FFI bridge:** flutter_rust_bridge for seamless Dart ↔ Rust calls
- **Build system:** Cargokit (rust_builder/) for cross-platform Rust compilation

## Architecture

```
MeowdokuHelper/
├── meowdoku_helper/                  # Main Flutter project
│   ├── lib/                     # Dart source code
│   │   ├── main.dart            # App entry point
│   │   ├── services/            # FFI service layer
│   │   ├── controllers/         # State management
│   │   ├── screens/             # UI screens
│   │   ├── widgets/             # Reusable widgets
│   │   └── src/rust/            # Generated FFI bindings (DO NOT EDIT)
│   ├── rust/                    # Rust backend
│   │   ├── src/
│   │   │   ├── lib.rs           # Library entry point
│   │   │   └── api/             # FFI-exposed functions
│   │   └── Cargo.toml           # Rust dependencies
│   ├── rust_builder/            # Cargokit FFI plugin
│   ├── ios/                     # iOS project (Xcode, Podfile)
│   ├── android/                 # Android project
│   ├── test/                    # Flutter tests
│   ├── integration_test/        # Integration tests
│   ├── assets/word_lists/       # Game data
│   └── flutter_rust_bridge.yaml # FFI config
├── doc/requirements/product.md  # Canonical Star Battle SDD
├── docs/                        # Template setup/architecture
```

**Solver module (Phase 1+):** `meowdoku_helper/rust/src/` — size-aware `Board` (`Vec<u8>`, `size: u32`); algorithms use `self.size`, not hardcoded 9. See [doc/requirements/product.md](../../doc/requirements/product.md).

## Solver FFI (Phase 3+)

Expose the solver via **flutter_rust_bridge**, not raw `extern "C"`:

```rust
#[flutter_rust_bridge::frb(sync)]
pub fn calculate_next_move(
    state: Vec<u8>,
    regions: Vec<u8>,
    grid_size: u32,
) -> i32
```

Add in `meowdoku_helper/rust/src/api/` (new module, e.g. `solver.rs`), then regenerate bindings.

## FFI workflow (template pattern)

### Adding a new Rust function

1. **Define in Rust** (`meowdoku_helper/rust/src/api/simple.rs` or new module):
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
   import 'package:meowdoku_helper/src/rust/api/simple.dart';
   final result = myNewFunction(input: "test");
   ```

4. **Test both sides:**
   - Rust: Add test in `rust/src/api/simple.rs` `#[cfg(test)]` module
   - Flutter: Add test in `test/`

### Attribute reference

| Attribute | Use case |
|-----------|----------|
| `#[flutter_rust_bridge::frb(sync)]` | Synchronous call, returns immediately |
| `#[flutter_rust_bridge::frb(init)]` | Initialization function |
| `pub async fn` | Async function (runs on Rust thread pool) |

## High-risk areas

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
- **Testing:** Test Rust logic with `cargo test`, Flutter integration with `flutter test`.
- **Documentation:** Update docs/ when architecture changes.

## Commands reference

```bash
# Flutter
flutter pub get           # Install dependencies
flutter run               # Run app
flutter test              # Unit tests
flutter build ios         # iOS release build

# Rust
cd meowdoku_helper/rust
cargo build               # Debug build
cargo build --release     # Release build
cargo test                # Run tests
cargo clippy              # Linting

# FFI regeneration
cd meowdoku_helper
flutter_rust_bridge_codegen generate
```
