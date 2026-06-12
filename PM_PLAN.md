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

- [x] Clipboard trigger on app focus (`pasteboard` package; `AppLifecycleState.resumed`)
- [x] Dart `compute` isolate: grid boundary detection, cell sampling (`parseJpegInBackground`)
- [x] Unique-color pass → detect **N** (color region rule); compute N² array length
- [x] Return `state` and `regions` arrays to main thread (`parseGridFromImage`)

**Acceptance:** Golden unit tests on **easy fixtures first** — seq `01` (N=4) and `02` (N=6) minimum **[done]**; then expand up seq order. Optional: seq `08` (N=9 product target), seq `14` (N=10).

## Phase 3 — UI highlight + end-to-end wire — done

**Goal:** Wire Phase 2 isolate output through existing FRB API; show result on grid.

**Note:** `calculate_next_move` shipped in Phase 1b.2 (FRB + Tier 1 roundtrip tests).

- [x] Flutter calls `calculateNextMove` from parsed board state (not test fixtures only)
- [x] UI highlights returned cell index; `-1` = stuck

**Acceptance:** Integration test: seq-08 fixture → isolate arrays → FFI → expected index (index 41; parser N=8). Tier 2 green on iOS 26.5 sim.

## Phase 4 — Advanced logic + fallback

**Goal:** Remaining solver tiers (product SDD lists all three; deliver in order).

### Phase 4a — Tier 2 (intersection)

- [x] Region-to-line claims
- [x] Line-to-region claims
- [x] Drop to Tier 1 after blocks

**Acceptance:** `cargo test` for intersection-only boards.

### Phase 4b — Tier 3 (locked ecosystems)

- [x] 2×2 trap avoidance
- [x] Locked multiples (N-locked column/region sets)

**Acceptance:** `cargo test` for locked-set boards.

### Phase 4c — DFS bifurcation (shipped as `tier4`; target ladder **T6**)

Historical name “Tier 4” = DFS. EPIC-6 will insert Phantom (T4) + Crowding (T5) above it — see Phase 6.

- [x] Safe backtracking when Tiers 1–3 stall
- [x] Illegal-state detection; no panic on stall

**Acceptance:** `cargo test` covers complex boards; returns `-1` when truly stuck.

### Phase 4d — T4 fixture gate (seq 22–30)

- [x] Lock parse arrays from real screenshots (seq 22–30)
- [x] Rust regression: `calculate_next_move` expected index per fixture
- [x] Dart regression: parse goldens + FFI solve goldens

**Acceptance:** `cargo test` + `flutter test` T4 gate green; EPIC-4 closed.

## Phase 5 — Progressive sizing (optional) · **Done**

**Goal:** End-to-end N>9 (10×10, 11×11) with fixture screenshots.

- [x] Isolate N detection validated on multi-size fixtures (seq 14 → parsed N=12; seq 29–30 → N=10)
- [x] Solver + FFI + UI work at N>9 without code changes (only data)

**Acceptance:** At least one N>9 fixture passes isolate → FFI → highlight path. **Met:** seq 14 (N=12 parsed), seq 29–30 (N=10); Tier 2 green (6 integration tests, iOS 26.5 sim).

## Phase 6 — Advanced deterministic tiers (optional · EPIC-6)

**Goal:** Phantom Cat Projection (T4) + Region Crowding (T5) before DFS; DFS becomes T6. Reduces clone/recursion cost on 10×10+; no FRB signature change.

**Canonical spec:** [doc/requirements/solver_algorithms.md](doc/requirements/solver_algorithms.md) Levels 4–6 — implement from exact algorithm steps only.

- [x] **T4 Phantom** — overlap halo intersection for regions with 2–3 empties (`tier4_phantom.rs`; US-6.1)
- [x] **T5 Crowding** — simulate cat in region A; block if adjacent region loses all empties (`tier5.rs`; US-6.2)
- [x] **T6 rename** — `run_tiers_1_through_6`; DFS propagation uses T1–T5; seq 22–30 `_T6_` gate (`US-6.3`)
- [x] Synthetic tests per tier before fixture re-gate
- [x] Re-audit fixture `_T{n}_` suffixes for seq 22–30 (`_T4_` → `_T6_`)

**Acceptance:** All existing solver gates still green; at least one synthetic board proves T4 and T5 without entering T6.

**Priority:** After Phase 5 (EPIC-5).

**Starting EPIC-6:** Branch from `main` @ latest; read [solver_algorithms.md](doc/requirements/solver_algorithms.md) Levels 4–6 and [EPICS_AND_STORIES.md](doc/plan/EPICS_AND_STORIES.md) US-6.1–6.3. Synthetic tests before fixture re-gate.

## Phase 7 — QA hardening & oracle proof · **done** (2026-06-12)

**Goal:** TDD process settled (QA/Coder separation); prove oracles and close fixture gaps without new solver features.

**Eval:** [doc/TEST_COVERAGE_EVAL.md](doc/TEST_COVERAGE_EVAL.md) (2026-06-11 TL + QA)

- [x] **Q1** — P1 t6 seq 22–30 uniqueness block-test (0/9 forced); derivation doc — **not** `human-verified`
- [x] **US-7.2** — `-2` branch-required API + Flutter hint UI truth
- [x] **US-7.3** — MRV heuristic for T6 DFS (`tier4.rs`)
- [x] **Q2** — Tier 2 iOS re-run post–EPIC-6 (iPhone 13 sim, 6/6, 2026-06-11)
- [x] **Q3** — All tier synthetics `spec-verified` (tier1–3, tier4-phantom, tier5, tier4-dfs; 2026-06-12)
- [x] **Q4** — Lock parse goldens seq 03–08 (`grid_goldens.dart`)
- [x] **Q5** — T2/T3 fixture gate seq 09–17 (QA oracles + gate artifacts; 2026-06-12). Seq 18–19 T4 deferred.
- [x] **Q6** — P2 audit integration + seq 01–02 solve goldens (2026-06-12)

**Acceptance:** `./scripts/qa_oracle_audit.sh --strict` passes P1/P2; Tier 2 green on iOS sim; tracked docs synced.

**Not in scope:** Full 42-fixture gate (incremental); line-coverage tooling (optional M8).

---

## Phase 8 — Fixture completion & hint truth (recommended next)

**Goal:** Close remaining fixture gaps; align hint API with uniqueness semantics; reduce golden duplication. No new solver tiers.

**Depends on:** Phase 7 strict oracle audit PASS.

- [x] **H1 / US-8.1** — T1–T5 uniqueness filter: `calculate_next_move` returns index only when block-test confirms forced; else `-2` (seq 22–30 class boards)
- [x] **H2 / US-8.2** — T4 fixture gate seq 18–19 (QA oracles + Rust/Dart gate; deferred from Q5)
- [x] **H3 / US-8.3** — 42-fixture inventory script; sync [FIXTURES.md](doc/plan/FIXTURES.md) gate columns
- [ ] **H4 / US-8.4** — Golden codegen Rust↔Dart (dedupe `t6_*` / `t2_t3_*` mirrored arrays)

**Acceptance:** H1 green with updated Flutter banner paths; H2 `./scripts/qa_oracle_audit.sh --strict` still PASS; Tier 1+2 green.

**Deferred (Phase 9+):** Hint UX (rule name + explanation + highlights — FRB contract change per [product.md](doc/requirements/product.md)); seq 31–42 full gates; line-coverage tooling.

---

Keep this file in sync with AGENT_HANDOFF "Current state" and `doc/requirements/product.md`.
