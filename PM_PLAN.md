# PM_PLAN — MeowdokuHelper

Star Battle N×N solver (N=9 first) bootstrapped from the Flutter-Rust-Julia FFI template.

**SDD:** [doc/requirements/product.md](doc/requirements/product.md)  
**Epics & stories:** [doc/plan/EPICS_AND_STORIES.md](doc/plan/EPICS_AND_STORIES.md) · [fixtures](doc/plan/FIXTURES.md)

## Phase 0 — Bootstrap (done)

- [x] Copy updated Rust FFI template with SDD layer
- [x] Rename `wrdlHelper` → `meowdoku_helper`
- [x] Wire agentic skills, rules, governance files
- [x] Add product SDD under `doc/requirements/`
- [x] Reconcile geminidata into product SDD (dynamic N, FRB contract)

## Phase 1 — Rust core skeleton (no UI) — done

**Goal:** Size-aware `Board` + Tier 1 algorithms (Halo Enforcer, Naked Singles).

- [x] `Board { state: Vec<u8>, regions: Vec<u8>, size: u32 }` with `idx()` / `coord()` helpers
- [x] All tier logic parameterized by `self.size` (no hardcoded `9`)
- [x] Halo Enforcer: block empty cells in row/col/8-neighbor halo of each cat
- [x] Naked Singles: place cat when a group has exactly one empty and zero cats
- [x] Rust `#[test]` with hardcoded N=9 state/regions proving a simple choke point

**Acceptance:** `cargo test --lib` green for Tier 1 module at N=9. *(Branch: `feature/phase1-board-tier1`.)*

## Phase 1b — Wordle remnant removal — done

**Goal:** Seek-and-destroy template Wordle code, tests, and assets so the repo reflects Star Battle only — **without breaking FFI/build**.

**Context:** ~95% of the running app is still Wordle (UI, FFI API, word lists, ~45 tests). Star Battle today is `rust/src/solver/` only (not wired to FRB). Do **not** hand-edit `lib/src/rust/` or `rust/src/frb_generated.rs`.

### 1b.1 — Safe deletes (no `api/` or FRB changes)

- [x] Remove stale integration tests (`integration_test/app_integration_test.dart`, `simple_test.dart`)
- [x] Remove Wordle benchmark tests + device perf scripts (`*_benchmark_*`, etc.)
- [x] Remove Wordle UI: `wordle_game_screen.dart`, widgets (grid/tiles/keyboard), Wordle models/controllers/state
- [x] Replace `main.dart` with minimal MeowdokuHelper placeholder (app still launches)
- [x] Remove Wordle assets: `assets/word_lists/official_wordle_words.json`, `official_guess_words.txt`; update `pubspec.yaml`
- [x] Remove Rust Wordle-only: `benchmarking.rs`, `benchmark_runner.rs`, `bin/benchmark.rs`, orphan `constraint_test.rs`; trim `lib.rs` exports
- [x] Archive or delete Wordle-only docs (`docs/archive/*`, `WORDLE_SOLVER_ARCHITECTURE_ANALYSIS.md`, etc.)
- [x] Remove Wordle scripts: `scripts/benchmark_baseline.py`, `precompute_optimal_guesses.rs`, `run_extended_benchmark.sh`

### 1b.2 — FFI-adjacent Wordle API removal — done

- [x] Remove `rust/src/api/meowdoku_helper.rs`, `meowdoku_helper_reference.rs`
- [x] `rust/src/api/simple.rs` → `init_app()` only
- [x] `rust/src/api/meowdoku.rs` → `calculate_next_move` (Tier 1 solver wired)
- [x] Regenerate FRB bindings; Dart roundtrip tests use Star Battle API
- [x] Trim Wordle-only Rust deps from `Cargo.toml`

**Never casual:** `rust_builder/`, `ios/`, `flutter_rust_bridge.yaml`, `Cargo.toml` pins (see [docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md))

### 1b.3 — Keep / wire later

- [x] Keep `rust/src/solver/*` (Star Battle core)
- [x] Keep root `assets/test_fixtures/` (board screenshots for Phase 2)
- [x] Keep `service_locator.dart` pattern (rewire in Phase 2/3)

**Acceptance (Phase 1b.1):**

- `cd meowdoku_helper/rust && cargo test --lib` green
- `cd meowdoku_helper && flutter test` green (Wordle tests removed or replaced with minimal smoke tests)
- `flutter run` launches placeholder UI (not Wordle screen)
- No Wordle word-list assets in `pubspec.yaml`
- FFI stack still builds: `RustLib.init()` succeeds

**Upstream template:** Wordle should never ship in [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template). See [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md) (Phases T0–T4).

## Phase 2 — Flutter image pipeline

**Goal:** Clipboard → isolate → flattened `Uint8List` arrays.

**Fixtures:** [doc/plan/FIXTURES.md](doc/plan/FIXTURES.md) — seq order (`01` … `32`; L21–L33 batch at seq 20–32).

- [ ] Clipboard trigger on app focus (`pasteboard` package)
- [x] Dart `compute` isolate: grid boundary detection, cell sampling (`parseJpegInBackground`)
- [x] Unique-color pass → detect **N** (color region rule); compute N² array length
- [x] Return `state` and `regions` arrays to main thread (`parseGridFromImage`)

**Acceptance:** Golden unit tests on **easy fixtures first** — seq `01` (N=4) and `02` (N=6) minimum; then expand up seq order. Optional: seq `08` (N=9 product target), seq `14` (N=10).

## Phase 3 — UI highlight + end-to-end wire

**Goal:** Wire Phase 2 isolate output through existing FRB API; show result on grid.

**Note:** `calculate_next_move` shipped in Phase 1b.2 (FRB + Tier 1 roundtrip tests).

- [ ] Flutter calls `calculateNextMove` from parsed board state (not test fixtures only)
- [ ] UI highlights returned cell index; `-1` = stuck

**Acceptance:** Integration test at N=9: fixture image → isolate arrays → FFI → expected index on screen.

## Phase 4 — Advanced logic + fallback

**Goal:** Remaining solver tiers (product SDD lists all three; deliver in order).

### Phase 4a — Tier 2 (intersection)

- [ ] Region-to-line claims
- [ ] Line-to-region claims
- [ ] Drop to Tier 1 after blocks

**Acceptance:** `cargo test` for intersection-only boards.

### Phase 4b — Tier 3 (locked ecosystems)

- [ ] 2×2 trap avoidance
- [ ] Locked multiples (N-locked column/region sets)

**Acceptance:** `cargo test` for locked-set boards.

### Phase 4c — Tier 4 (DFS bifurcation)

- [ ] Safe backtracking when Tiers 1–3 stall
- [ ] Illegal-state detection; no panic on stall

**Acceptance:** `cargo test` covers complex boards; returns `-1` when truly stuck.

## Phase 5 — Progressive sizing (optional)

**Goal:** End-to-end N>9 (10×10, 11×11) with fixture screenshots.

- [ ] Isolate N detection validated on multi-size fixtures
- [ ] Solver + FFI + UI work at N>9 without code changes (only data)

**Acceptance:** At least one N=10 fixture passes isolate → FFI → highlight path.

---

Keep this file in sync with AGENT_HANDOFF "Current state" and `doc/requirements/product.md`.
