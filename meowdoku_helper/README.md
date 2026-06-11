# meowdoku_helper

Flutter + Rust Star Battle solver. Clipboard JPEG → Dart isolate parse → Rust CSP engine → highlighted next move.

**Repo docs:** [../README.md](../README.md) · [../doc/PROJECT_STATUS.md](../doc/PROJECT_STATUS.md) · [../CONTRIBUTING.md](../CONTRIBUTING.md)

## Stack

- **Flutter 3.9+** — iOS and Android (placeholder shell UI)
- **Rust** — Tiers 1–4 solver via flutter_rust_bridge 2.12.0
- **Cargokit** — `rust_builder/` cross-platform native build

## Layout

```
meowdoku_helper/
├── lib/
│   ├── main.dart              # App entry + clipboard orchestration
│   ├── app/                   # UI helpers (grid preview, lifecycle)
│   ├── image/                 # JPEG parse pipeline (isolate)
│   ├── services/              # FfiService wrapper
│   └── src/rust/              # Generated FRB bindings (DO NOT EDIT)
├── rust/src/
│   ├── api/                   # FRB: init_app, calculate_next_move
│   └── solver/                # Board + tier1..tier4
├── test/                      # Tier 1b unit/widget tests
├── integration_test/          # Tier 2 device E2E
└── rust_builder/              # FFI plugin (high-risk — see SETUP_GUIDE)
```

Fixtures live at repo root: `../assets/test_fixtures/` (42 boards). Four are duplicated under `integration_test/fixtures/` for device `rootBundle`.

## Commands

```bash
flutter pub get
flutter analyze
flutter test
cd rust && cargo test --lib
```

Merge-ready gate: `flutter test && cd rust && cargo test --lib`

Tier 2 (device/simulator): `flutter test integration_test/`

## FFI surface

| Rust | Dart |
|------|------|
| `init_app()` | `RustLib.init()` |
| `calculate_next_move(state, regions, grid_size) -> i32` | `calculateNextMove(...)` |

Regenerate bindings after Rust API changes:

```bash
flutter_rust_bridge_codegen generate
```

Never edit `lib/src/rust/` manually. See [../docs/SETUP_GUIDE.md](../docs/SETUP_GUIDE.md).
