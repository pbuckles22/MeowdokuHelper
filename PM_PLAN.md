# PM_PLAN — MeowdokuHelper

Star Battle N×N solver (N=9 first) bootstrapped from the Flutter-Rust-Julia FFI template.

**SDD:** [doc/requirements/product.md](doc/requirements/product.md)

## Phase 0 — Bootstrap (done)

- [x] Copy updated Rust FFI template with SDD layer
- [x] Rename `wrdlHelper` → `meowdoku_helper`
- [x] Wire agentic skills, rules, governance files
- [x] Add product SDD under `doc/requirements/`
- [x] Reconcile geminidata into product SDD (dynamic N, FRB contract)

## Phase 1 — Rust core skeleton (no UI)

**Goal:** Size-aware `Board` + Tier 1 algorithms (Halo Enforcer, Naked Singles).

- [ ] `Board { state: Vec<u8>, regions: Vec<u8>, size: u32 }` with `idx()` / `coord()` helpers
- [ ] All tier logic parameterized by `self.size` (no hardcoded `9`)
- [ ] Halo Enforcer: block empty cells in row/col/8-neighbor halo of each cat
- [ ] Naked Singles: place cat when a group has exactly one empty and zero cats
- [ ] Rust `#[test]` with hardcoded N=9 state/regions proving a simple choke point

**Acceptance:** `cargo test` green for Tier 1 module at N=9.

## Phase 2 — Flutter image pipeline

**Goal:** Clipboard → isolate → flattened `Uint8List` arrays.

- [ ] Clipboard trigger on app focus (`pasteboard` package)
- [ ] Dart `compute` isolate: grid boundary detection, cell sampling
- [ ] Unique-color pass → detect **N** (color region rule); compute N² array length
- [ ] Return `state` and `regions` arrays to main thread

**Acceptance:** Unit test with N=9 fixture image → expected 81-element arrays. Optional follow-up: N=10 fixture.

## Phase 3 — FFI bridge + UI highlight

**Goal:** Wire isolate output to Rust solver; show result on grid.

- [ ] Expose `calculate_next_move(state, regions, grid_size) -> i32` via **flutter_rust_bridge** in `rust/src/api/` (not raw `extern "C"`)
- [ ] Regenerate FRB bindings; Flutter calls from parsed board state
- [ ] UI highlights returned cell index; `-1` = stuck

**Acceptance:** Integration test at N=9: known board in → expected index out.

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
