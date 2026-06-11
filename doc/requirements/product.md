# MeowdokuHelper — Product SDD

Canonical product SDD. Do **not** use deprecated scratch exports — this file is source of truth.

## Executive summary

High-performance, deterministic constraint satisfaction solver for Star Battle–style N×N grid puzzles (N=9 initially; progressive 10×10, 11×11, etc. supported by design).

**Workflow:** Ingest board screenshot from clipboard → parse grid in Dart isolate → pass flattened state across FFI → Rust state machine returns next forced move without blocking UI.

## Architecture

| Layer | Role | Rationale |
|-------|------|-----------|
| Flutter/Dart | UI, clipboard (`pasteboard`), pixel sampling in isolate | 60/120fps UI; no heavy CV/ML libs |
| Rust | CSP solver, escalating state machine | No GC pauses during DFS; memory-safe backtracking; native FFI performance |
| Julia | Reserved / not invoked | Avoid double FFI latency and +50–100MB bundle; leave build hooks intact |

### Rust rationale (detail)

- **Zero GC pauses:** DFS/bifurcation creates thousands of temporary board states; Rust avoids Dart/Go GC stutter.
- **Memory safety:** Deep recursive backtracking without C/C++ stack overflow risk.
- **FFI:** Compiles to a native library; data crosses the boundary as contiguous byte slices.

## Image pipeline (Flutter)

Avoid ML/YOLO. The game uses a rigid grid — pixel math is sufficient.

### Isolate-Pixel Method

1. **Trigger:** Check system clipboard when app gains focus (`pasteboard` package).
2. **Off-main-thread:** Pass image bytes to Dart `compute` (isolate).
3. **Grid slicing:**
   - Detect background boundary; divide bounding box by **N** for `cell_size`.
   - For each cell `(x, y)` where `0 ≤ x, y < N`:
     - Sample center pixel → map RGB to region ID (1–N).
     - Sample offset pixel (slightly top-left of center) → detect cat or blocked (X).
4. **Return payload:** Two `Uint8List` arrays of length **N²** to the main thread.

Phase 2 ships with **N=9** fixtures; N detection (below) enables larger boards without pipeline rewrite.

## Dynamic grid sizing (N×N)

Progressive puzzles scale from 9×9 to 10×10, 11×11, etc. Use **dynamic vectors**, not fixed `[u8; 81]`.

### Detecting N (no OCR)

**Color region rule:** An N×N board has exactly **N** distinct color regions (one cat per row, column, and region).

During isolate sampling, count unique region RGB values → that count is **N**. Then `cell_size = bounding_box / N` and array length = **N²**.

### Board struct (Rust)

Algorithms use `self.size`, never a hardcoded `9`:

```rust
struct Board {
    state: Vec<u8>,
    regions: Vec<u8>,
    size: u32, // N
}

impl Board {
    fn new(state: Vec<u8>, regions: Vec<u8>, size: u32) -> Self {
        Self { state, regions, size }
    }

    fn idx(&self, x: usize, y: usize) -> usize {
        y * (self.size as usize) + x
    }

    fn coord(&self, idx: usize) -> (usize, usize) {
        let n = self.size as usize;
        (idx % n, idx / n)
    }
}
```

**Phase 1 scope:** implement size-aware `Board`; all tests use `size: 9`.

## Data payload (FFI)

**Cell state (`state`):**

- `0` = Empty
- `1` = Cat (placed)
- `2` = Blocked (halo / X)

**Regions (`regions`):** IDs `1` through `N` per cell.

### Contract (logical)

```rust
// Returns index 0..(N²-1) for next forced move, or -1 if stuck.
fn calculate_next_move(
    state: Vec<u8>,
    regions: Vec<u8>,
    grid_size: u32, // N
) -> i32
```

### Implementation: flutter_rust_bridge (not raw C ABI)

The bootstrapped template uses **flutter_rust_bridge**, not hand-written `#[no_mangle] extern "C"`. Expose the same contract in `meowdoku_helper/rust/src/api/`:

```rust
#[flutter_rust_bridge::frb(sync)]
pub fn calculate_next_move(
    state: Vec<u8>,
    regions: Vec<u8>,
    grid_size: u32,
) -> i32 {
    // 1. Validate state.len() == regions.len() == (grid_size * grid_size) as usize
    // 2. Board::new(state, regions, grid_size)
    // 3. Run state machine
    // 4. Return cell index or -1
}
```

Regenerate bindings: `flutter_rust_bridge_codegen generate` (see [docs/SETUP_GUIDE.md](../../docs/SETUP_GUIDE.md)).

Pointer-based Cargokit plumbing is unchanged; only how slices are sized (N² from `grid_size`) changes on each side.

## Solver tiers (escalating state machine)

Do not guess randomly. Run cheapest loops first; escalate only when a tier stalls.

**Full algorithm catalog (implementation order, acceptance gates, fixture mapping):** [solver_algorithms.md](solver_algorithms.md)

### Tier 1 — Beginner (workhorse) ✅

Loop until zero state changes:

1. **Halo Enforcer** — For each cat (`1`), block all empty (`0`) in same row, column, and 8-neighbors → `2`
2. **Naked Singles** — If a row/col/region has exactly one empty and zero cats, place cat there
3. If a cat was placed, restart at Halo Enforcer

### Tier 2 — Intersection logic

When Tier 1 stalls:

- **Region-to-line claims** — Region’s empties all in one row/col → block other empties in that line outside region
- **Line-to-region claims** — Row/col empties all in one region → block other empties in region outside line
- On any block, drop to Tier 1

### Tier 3 — Locked ecosystems ✅

When Tier 2 stalls:

- **2×2 trap avoidance** — Deduce region cat placement from 2×2 empty blocks
- **Locked multiples** — N columns with empties in exactly N regions → lock those regions to those columns

### Tier 4 — Phantom Cat Projection (planned · EPIC-6)

When Tiers 1–3 stall. Deterministic overlap-halo blocking for regions with 2–3 empties. **Exact steps:** [solver_algorithms.md](solver_algorithms.md) Level 4.

### Tier 5 — Region-to-Region Crowding (shipped · EPIC-6 US-6.2)

When Tier 4 stalls. Deterministic mutual-destruction blocks across adjacent regions. **Exact steps:** [solver_algorithms.md](solver_algorithms.md) Level 5. Not required for correctness (DFS already finds these contradictions); reduces search depth.

### Tier 6 — DFS / bifurcation (ultimate failsafe) ✅

When deterministic tiers stall. Shipped as **`tier4.rs`** (T6 DFS module) / **`run_tiers_1_through_6`**:

1. Pick first empty cell; clone board
2. Try cat (`1`); run Tiers 1–3 recursively (target: T1–T5 after EPIC-6)
3. On illegal state (e.g. row with zero cats and zero empties), mark original cell blocked (`2`); return to Tier 1

**Full catalog:** [solver_algorithms.md](solver_algorithms.md) — tier ladder, state machine, fixture gates.

## Hint UX (planned · post EPIC-3)

**Today:** `PuzzleGridPreview` highlights a **single cell index** for the next forced cat (or stalled banner). No rule name or plain-language explanation.

**Target:** When the solver deduces a move or block, show:

1. **Rule name** in human language (e.g. “Region crowding”, “Only spot in row”, “Overlap halos”).
2. **One-line why** — e.g. *“Placing here excludes all cells in Column 5 – no cat can be placed.”*
3. **Highlights** — primary cell(s) involved (hypothetical cat, blocked cells, or forced placement), not only the final cat index.

**Reference mockup:** [assets/reference/hint_t5_region_crowding_column5.jpeg](../../assets/reference/hint_t5_region_crowding_column5.jpeg) — T5 Region Crowding example with **Cat?** + column block highlights. Catalogued in [FIXTURES.md](../plan/FIXTURES.md) → Reference assets.

Requires Rust to return **move kind + explanation + highlight set** (FRB change — defer until EPIC-6+ hint story).

## Implementation phases

See [PM_PLAN.md](../../PM_PLAN.md) for delivery checklist and acceptance criteria.
