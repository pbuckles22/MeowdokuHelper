# Derivation — H1 uniqueness filter on hint API

**Session:** 2026-06-12 (Phase 8 H1)  
**Spec:** [solver_algorithms.md](../requirements/solver_algorithms.md), [product.md](../requirements/product.md)

## Behavior

`calculate_next_move` now returns:

| Code | Meaning |
|------|---------|
| `>= 0` | Block-test confirms the T1–T5 propagation move is uniqueness-forced |
| `-2` | Propagation finds a move but alternates exist, **or** T6 alone advances |
| `-1` | Invalid input or fully stuck |

Internal tier propagation unchanged (`propagate_next_move_index`); QA block-test uses raw propagation.

## Verification

- Synthetic choke board + tier4 DFS board: still return forced index (`meowdoku.rs` tests)
- All fixture gates (seq 01–02, 09–19, 22–30): hint API `-2` (0/N block-test forced on locked propagation indices)
- Integration smoke (08, 14, 29, 30): hint API `-2`; propagation indices unchanged in trace maps

## Oracle update

Fixture `expected_move` / `expectedMove` columns now mean **hint API response**, not propagation convention. Propagation indices preserved in QA audit trace maps and `branch_probe_index` (t6).

## Flutter

Existing `clipboard_flow.dart` branch banner (`SolverResult.branchRequired`) — no UI code change required.
