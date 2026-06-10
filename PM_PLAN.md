# PM_PLAN — MeowdokuHelper

Star Battle 9x9 solver bootstrapped from the Flutter-Rust-Julia FFI template.

## Phase 0 — Bootstrap (done)

- [x] Copy updated Rust FFI template with SDD layer
- [x] Rename `wrdlHelper` → `meowdoku_helper`
- [x] Wire agentic skills, rules, governance files
- [x] Add product SDD under `doc/requirements/`

## Phase 1 — Rust core skeleton (no UI)

**Goal:** `Board` struct + Tier 1 algorithms (Halo Enforcer, Naked Singles).

- [ ] Implement `Board` with `[u8; 81]` state and region arrays
- [ ] Halo Enforcer: block empty cells in row/col/8-neighbor halo of each cat
- [ ] Naked Singles: place cat when a group has exactly one empty and zero cats
- [ ] Rust `#[test]` with hardcoded state proving a simple choke point

**Acceptance:** `cargo test` green for Tier 1 logic module.

## Phase 2 — Flutter image pipeline

**Goal:** Clipboard → isolate → flattened `Int8List` arrays.

- [ ] Clipboard trigger on app focus (`pasteboard` or platform equivalent)
- [ ] Dart `compute` isolate: grid boundary detection, 9×9 cell sampling
- [ ] Return `state_array` and `region_array` to main thread

**Acceptance:** Unit test with fixture image bytes → expected 81-element arrays.

## Phase 3 — FFI bridge + UI highlight

**Goal:** Wire isolate output to Rust `calculate_next_move`, show result on grid.

- [ ] Rust FFI: `calculate_next_move(state_ptr, region_ptr, len) -> i32`
- [ ] Flutter calls FFI from parsed board state
- [ ] UI highlights returned cell index (0–80); `-1` = stuck

**Acceptance:** Integration test: known board in → expected index out.

## Phase 4 — Advanced logic + fallback

**Goal:** Tier 2 (intersection), Tier 3 (locked sets), Tier 4 (DFS bifurcation).

- [ ] Region-to-line and line-to-region claims
- [ ] 2×2 trap avoidance, locked multiples
- [ ] DFS failsafe when deterministic tiers stall

**Acceptance:** `cargo test` covers complex boards; no panic on stall.

---

Keep this file in sync with AGENT_HANDOFF "Current state" and `doc/requirements/`.
