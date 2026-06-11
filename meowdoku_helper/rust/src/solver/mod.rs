//! Star Battle CSP solver — tiered propagation ending in DFS bifurcation.
//!
//! **Propagation model:** Each tier applies local rules until stall, then the next
//! tier runs. When a higher tier blocks cells, lower tiers restart (see
//! `run_tiers_1_and_2`, `run_tiers_1_through_3`, `run_tiers_1_through_4`).
//!
//! **Shipped ladder:** tier1 → tier2 → tier3 → tier4_phantom (T4) → tier4 (DFS / T6 until US-6.3).

pub mod board;
pub mod tier1;
pub mod tier2;
pub mod tier3;
pub mod tier4;
pub mod tier4_phantom;
pub mod t4_fixtures;

#[cfg(test)]
pub mod test_helpers;

pub use board::Board;
pub use tier1::{apply_halo_enforcer, apply_naked_singles, run_tier1};
pub use tier2::{apply_line_claims_region, apply_region_claims_line, run_tiers_1_and_2};
pub use tier3::{apply_locked_sets, apply_trap_2x2, run_tiers_1_through_3};
pub use tier4::{dfs_bifurcation, is_illegal, is_solved, run_tiers_1_through_4};
pub use tier4_phantom::apply_phantom_projection;
