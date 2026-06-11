pub mod board;
pub mod tier1;
pub mod tier2;
pub mod tier3;
pub mod tier4;
pub mod t4_fixtures;

pub use board::Board;
pub use tier1::{apply_halo_enforcer, apply_naked_singles, run_tier1};
pub use tier2::{apply_line_claims_region, apply_region_claims_line, run_tiers_1_and_2};
pub use tier3::{apply_locked_sets, apply_trap_2x2, run_tiers_1_through_3};
pub use tier4::{dfs_bifurcation, is_illegal, is_solved, run_tiers_1_through_4};
