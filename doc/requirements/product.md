# MeowdokuHelper — Product SDD

## Executive summary

High-performance, deterministic constraint satisfaction solver for Star Battle–style 9×9 grid puzzles.

**Workflow:** Ingest board screenshot from clipboard → parse grid in Dart isolate → pass flattened state across C-ABI → Rust state machine returns next forced move without blocking UI.

## Architecture

| Layer | Role | Rationale |
|-------|------|-----------|
| Flutter/Dart | UI, clipboard, pixel sampling in isolate | 60/120fps UI; no heavy CV libs |
| Rust | CSP solver, escalating state machine | No GC pauses during DFS; memory-safe backtracking |
| Julia | Reserved / not invoked | Avoid double FFI latency and +50–100MB bundle |

## Image pipeline (Flutter)

1. Check clipboard when app gains focus
2. Pass image bytes to Dart `compute` (isolate)
3. Detect grid boundary; divide bounding box by 9 for `cell_size`
4. Sample center pixel for region ID (1–9); offset pixel for cat / blocked (X)
5. Return two `Int8List` arrays (81 elements each)

## Data payload (FFI)

**`state_array` (`[u8; 81]`):**

- `0` = Empty
- `1` = Cat (placed)
- `2` = Blocked (halo / X)

**`region_array` (`[u8; 81]`):** region IDs 1–9 per cell.

**Rust signature:**

```rust
#[no_mangle]
pub extern "C" fn calculate_next_move(
    state_ptr: *const u8,
    region_ptr: *const u8,
    len: usize,
) -> i32
```

Returns array index 0–80 for next move, or `-1` if stuck.

## Solver tiers (escalating state machine)

Do not guess randomly. Run cheapest loops first; escalate only when a tier stalls.

### Tier 1 — Beginner (workhorse)

Loop until zero state changes:

1. **Halo Enforcer** — For each cat (`1`), block all empty (`0`) in same row, column, and 8-neighbors → `2`
2. **Naked Singles** — If a row/col/region has exactly one empty and zero cats, place cat there
3. If a cat was placed, restart at Halo Enforcer

### Tier 2 — Intersection logic

When Tier 1 stalls:

- **Region-to-line claims** — Region’s empties all in one row/col → block other empties in that line outside region
- **Line-to-region claims** — Row/col empties all in one region → block other empties in region outside line
- On any block, drop to Tier 1

### Tier 3 — Locked ecosystems

When Tier 2 stalls:

- **2×2 trap avoidance** — Deduce region cat placement from 2×2 empty blocks
- **Locked multiples** — N columns with empties in exactly N regions → lock those regions to those columns

### Tier 4 — DFS / bifurcation

When deterministic tiers stall:

1. Pick first empty cell; clone board
2. Try cat (`1`); run Tiers 1–3 recursively
3. On illegal state, mark original cell blocked (`2`); return to Tier 1

## Implementation prompts (agent phases)

See [PM_PLAN.md](../../PM_PLAN.md) for phased delivery aligned with these tiers.
