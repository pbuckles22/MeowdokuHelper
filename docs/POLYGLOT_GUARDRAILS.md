# Polyglot architecture guardrails

Cross-language rules for MeowdokuHelper and sibling AgenticTemplate bolt-ons (Flutter + Rust via **flutter_rust_bridge**). **Julia** hooks exist in the build template only — not invoked at runtime. **Go** is not used in this repo; Go rules apply when syncing this doc to other bolt-ons.

See also: [SETUP_GUIDE.md](SETUP_GUIDE.md) (FFI plumbing), [AGENT_HANDOFF.md](../AGENT_HANDOFF.md) (high-risk paths), [.cursor/skills/DEV_GUIDE.md](../.cursor/skills/DEV_GUIDE.md) (FFI workflow).

---

## Polyglot architecture guardrails

* **No FFI Serialization:** Never utilize JSON or string serialization across FFI boundaries. Pass flat, contiguous memory buffers or native pointers.
* **Matrix Memory Layouts:** Handle data alignment strictly: Julia uses Column-Major layout; Dart, Rust, Go, and C-ABI use Row-Major layout.
* **Toolchain Immutability:** Never modify native compilation scripts, environment variables, or auto-generated bridge bindings to fix algorithmic errors.
* **Pure Functional Compute:** Keep all solver and math logic inside pure, stateless functions that are fully testable via native CLI toolchains.
* **FFI Boundary Error Handling:** Never allow Rust `panic!`/`unwrap()` or Go `panic()` to cross execution boundaries. Catch all invariants natively and return explicit error types across the bridge.

---

## MeowdokuHelper application

| Guardrail | How this repo applies it |
|-----------|--------------------------|
| No FFI serialization | `calculate_next_move(state, regions, grid_size)` — flat `Vec<u8>` / `List<int>`; row-major `y * N + x` in `Board`. |
| Matrix layouts | Grid state is 1D row-major; do not pass 2D JSON or column-major Julia buffers without explicit mapping. |
| Toolchain immutability | Do not edit `lib/src/rust/` (generated), `ios/`, `rust_builder/`, `flutter_rust_bridge.yaml`, or env vars to patch solver bugs — fix Rust in `rust/src/solver/`. |
| Pure functional compute | Solver tiers in `rust/src/solver/tier*.rs`; orchestrators `run_tiers_1_through_*`; validate with `cargo test --lib`. |
| FFI error handling | Production Rust uses `Option`/`Result`; invalid inputs in `calculate_next_move` return `-1` — no panics across FRB. |

**Threading (Dart):** Main isolate for UI + sync FRB only. JPEG decode and grid parse run in `Isolate`s (`compute()`). See `lib/image/`.

**Solver structure:** Modular tier functions called by an orchestrator loop — no monolithic nested solver loops. Escalation: T1 → T2 → T3 → T4 phantom → T5 crowding → T6 DFS (`run_tiers_1_through_6`).

---

## Algorithmic tier escalation & solver guardrails

* **Strict Tier Escalation:** The solver engine must follow a deterministic execution order. The orchestration loop (`run_tiers_1_through_6`) must exhaustively run lower-cost logic tiers (T1 through T5) to hit a fixed point before ever invoking the heavy Tier 6 DFS fallback.
* **Pure Functional Constraints:** All localized deduction passes (e.g., cell masking inside phantom or crowding layers) must act as stateless functions operating on the board structure. Do not store ephemeral search path properties on the global `Board` struct.
* **Auto-Generated & Bridge Immutability:** Do not allow modifications to generated FFI layers (`frb_generated.rs`), platform bridge structures, or directory paths under `ios/` or `rust_builder/` when refactoring inner algorithmic loops.

**US-6.3+ invariants:**

1. **Orchestrator stack:** `[T1: Halo + Singles] → [T2: Intersection] → [T3: Traps] → [T4: Phantoms] → [T5: Crowding] → [T6: DFS Fallback]`
2. **FFI signature frozen:** `calculate_next_move(state, regions, grid_size) -> i32` — tier reorganization is internal to `rust/src/solver/`.
3. **Fixture gate labeling:** seq 22–30 use `_T6_` suffix (minimum tier = DFS); deterministic tiers are T1–T5.
